

-- CHART 1

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

--CHART 2

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

-- CHART 3

SELECT y.startyear, COUNT(f.datavalue) AS count_values
        FROM fact_analytics_2 f
        JOIN dim_year y ON f.year_id = y.year_id
        GROUP BY y.startyear
        ORDER BY y.startyear;

--CHART 4

SELECT ds.datasource AS DataSource,
                COUNT(DISTINCT f.topicid) AS TopicsContributed
            FROM fact_analytics_2 f
            JOIN dim_data_source ds ON f.datavalue_source_id = ds.data_source_id
            GROUP BY ds.datasource
            ORDER BY TopicsContributed DESC;

--CHART 5

SELECT t.topic AS Topic,
                COUNT(f.factid) AS ReferenceCount
            FROM fact_analytics_2 f
            JOIN dim_topic t ON f.topicid = t.topicid
            GROUP BY t.topic
            ORDER BY ReferenceCount DESC;