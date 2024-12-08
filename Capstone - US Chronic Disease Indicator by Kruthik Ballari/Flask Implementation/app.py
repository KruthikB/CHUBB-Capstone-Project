from flask import Flask, render_template, request
from flask_sqlalchemy import SQLAlchemy
import matplotlib.pyplot as plt
import io
from sqlalchemy.sql import text
import base64

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'mssql+pymssql://INFA_DOM3:kruthik1207@localhost:1433/hr'  # Replace with your DB URI
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
db = SQLAlchemy(app)

def generate_chart(chart_type):
    if chart_type == "Alcohol Use Among Youth by Race/Ethnicity in 2019 under Crude Prevalence":
        query = text('''
            SELECT r.stratification AS RaceEthnicity,f.datavalue AS DataValue,y.startyear AS Year
            FROM fact_analytics_2 f
            JOIN dim_question q ON f.questionid = q.questionid
            JOIN dim_year y ON f.year_id = y.year_id
            JOIN dim_stratification_division r ON f.stratification_division_id = r.stratification_division_id
            JOIN dim_datavalue_type d on f.datavaluetype_id = d.data_type_id
            WHERE 
                q.question = 'Alcohol use among youth'
                AND f.locationid = (SELECT locationid FROM dim_location WHERE locationdesc = 'United States')
                AND y.startyear = 2019
                AND d.datavaluetype='Crude Prevalence'
            ORDER BY r.stratification;
        ''')
        result = db.session.execute(query).fetchall()
        race_ethnicities = [row[0] for row in result]
        data_values = [row[1] for row in result]

        # Bar Chart
        plt.figure(figsize=(14, 7))
        plt.bar(race_ethnicities, data_values, color='lightgreen')
        plt.xlabel('Race/Ethnicity')
        plt.ylabel('Data Value')
        plt.title('Alcohol Use Among Youth by Race/Ethnicity in 2019 under Crude Prevalence')
        plt.xticks(rotation=45, ha='right')
        plt.tight_layout()

    elif chart_type == "Chronic liver disease mortality in California in 2013":
        query = text('''
        SELECT r.stratification AS RaceEthnicity,f.datavalue AS DataValue,y.startyear AS Year
        FROM fact_analytics_2 f
        JOIN dim_question q ON f.questionid = q.questionid
        JOIN dim_year y ON f.year_id = y.year_id
        JOIN dim_stratification_division r ON f.stratification_division_id = r.stratification_division_id
        JOIN dim_datavalue_type d ON f.datavaluetype_id = d.data_type_id
        WHERE 
            q.question = 'Chronic liver disease mortality'
            AND f.locationid = (SELECT locationid FROM dim_location WHERE locationdesc = 'California')
            AND y.startyear = 2013
            AND d.datavaluetype = 'Crude Rate'
        ORDER BY r.stratification;
        ''')
        result = db.session.execute(query).fetchall()
        race_ethnicities = [row[0] for row in result]
        data_values = [row[1] for row in result]

        # Bar Chart
        plt.figure(figsize=(14, 7))
        plt.bar(race_ethnicities, data_values, color='lightcoral')
        plt.xlabel('Race/Ethnicity')
        plt.ylabel('Data Value (Crude Rate)')
        plt.title('Chronic Liver Disease Mortality by Race/Ethnicity in California (2013)')
        plt.xticks(rotation=45, ha='right')
        plt.tight_layout()

    elif chart_type == "year_distribution":
        query = text('''
        SELECT y.startyear, COUNT(f.datavalue) AS count_values
        FROM fact_analytics_2 f
        JOIN dim_year y ON f.year_id = y.year_id
        GROUP BY y.startyear
        ORDER BY y.startyear;
        ''')
        result = db.session.execute(query).fetchall()
        years = [row[0] for row in result]
        counts = [row[1] for row in result]

        # Line Chart
        plt.figure(figsize=(10, 5))
        plt.plot(years, counts, marker='o', linestyle='-', color='blue')
        plt.xlabel('Year')
        plt.ylabel('Number of Data Values')
        plt.title('Data Value Distribution by Year')
        plt.grid(True)
        plt.tight_layout()

    elif chart_type == "topics_distribution":
        query = text('''
            SELECT ds.datasource AS DataSource,
                COUNT(DISTINCT f.topicid) AS TopicsContributed
            FROM fact_analytics_2 f
            JOIN dim_data_source ds ON f.datavalue_source_id = ds.data_source_id
            GROUP BY ds.datasource
            ORDER BY TopicsContributed DESC;
        ''')
        result = db.session.execute(query).fetchall()
        data_sources = [row[0] for row in result]
        topic_counts = [row[1] for row in result]

        # Bar Chart
        plt.figure(figsize=(12, 6))
        plt.bar(data_sources, topic_counts, color='skyblue')
        plt.xlabel('Data Source')
        plt.ylabel('Number of Topics Contributed')
        plt.title('Distribution of Topics Contributed by Data Source')
        plt.xticks(rotation=45, ha='right')
        plt.tight_layout()
        
    elif chart_type == "reference_count":
        query = text('''
            SELECT t.topic AS Topic,
                COUNT(f.factid) AS ReferenceCount
            FROM fact_analytics_2 f
            JOIN dim_topic t ON f.topicid = t.topicid
            GROUP BY t.topic
            ORDER BY ReferenceCount DESC;
        ''')
        result = db.session.execute(query).fetchall()
        topics = [row[0] for row in result]
        reference_counts = [row[1] for row in result]

        # Bar Chart
        plt.figure(figsize=(14, 7))
        plt.bar(topics, reference_counts, color='lightgreen')
        plt.xlabel('Topic')
        plt.ylabel('Reference Count')
        plt.title('Reference Count by Topic')
        plt.xticks(rotation=45, ha='right')
        plt.tight_layout()
    else:
        return None

    img = io.BytesIO()
    plt.savefig(img, format='png')
    img.seek(0)
    plot_url = base64.b64encode(img.getvalue()).decode()
    return plot_url

@app.route('/', methods=['GET', 'POST'])
def index():
    chart_type = None
    plot_url = None
    if request.method == 'POST':
        chart_type = request.form.get('chart_type')
        if chart_type:
            plot_url = generate_chart(chart_type)
    return render_template('index.html', chart_type=chart_type, plot_url=plot_url)

if __name__ == '__main__':
    app.run(debug=True)
