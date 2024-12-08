CREATE TABLE [dim_location] (
	[locationid] int NOT NULL,
	[locationid_cd] int NOT NULL,
	[locationabbr] varchar(50) NOT NULL,
	[locationdesc] varchar(255) NOT NULL,
	[geolocation] varchar(255),
	[createdate] DATE,
	PRIMARY KEY ([locationid])
);

CREATE TABLE [dim_question] (
	[questionid] int NOT NULL,
	[question_cd] varchar(50) NOT NULL,
	[topicid] int NOT NULL,
	[question] varchar(255),
	[createdate] DATE,
	PRIMARY KEY ([questionid])
);

CREATE TABLE [dim_topic] (
	[topicid] int NOT NULL,
	[topic_cd] varchar(50) NOT NULL,
	[topic] varchar(255),
	[createdate] DATE,
	PRIMARY KEY ([topicid])
);

CREATE TABLE [dim_year] (
	[year_id] int NOT NULL,
	[startyear] int NOT NULL ,
	PRIMARY KEY ([year_id])
);

CREATE TABLE [dim_data_source](
	data_source_id int NOT NULL,
	datasource varchar(255),
	[createdate] DATE
	primary key ([data_source_id])
);



CREATE TABLE [dim_datavalue_type](
	data_type_id int NOT NULL,
	datavaluetypeid varchar(255),
	[datavaluetype] varchar(255),
	[createdate] DATE
	primary key ([data_type_id])
);

CREATE TABLE [dim_datavalue_unit](
	data_unit_id int NOT NULL,
	datavalueunit varchar(255),
	[createdate] DATE
	primary key ([data_unit_id])
);

CREATE TABLE [dim_stratification_category] (
	[stratification_id] int NOT NULL,
	[stratification_category_id] varchar(255),
	[stratification_category] varchar(255),
	[createdate] DATE,
	PRIMARY KEY ([stratification_id])
);

CREATE TABLE [dim_stratification_division] (
	[stratification_division_id] int NOT NULL,
	[stratification_cd] varchar(50),
	[stratification] varchar(255),
	[createdate] DATE,
	PRIMARY KEY ([stratification_division_id])
);

CREATE TABLE [dim_datafootnote](
	data_footnote_id int NOT NULL,
	datafootnotesymbol varchar(255),
	datafootnote varchar(255),
	[createdate] DATE
	primary key ([data_footnote_id])
);

CREATE TABLE fact_analytics_2(
    factid INT NOT NULL PRIMARY KEY,           
    locationid INT NOT NULL,                   
	topicid INT NOT NULL,
    questionid INT NOT NULL,                   
	year_id INT NOT NULL,                      
    stratification_id INT NOT NULL,            
    stratification_division_id INT NOT NULL,
	datavalue_source_id INT NOT NULL,
	datavalue FLOAT,
	lowconfidencelevel FLOAT,
	highconfidencelevel FLOAT,
	datavalueunit_id INT NOT NULL,
	datavaluetype_id INT NOT NULL,
	data_footnote_id INT NOT NULL,
	activeflag VARCHAR(1),
    createdate DATE,                           
    updatedate DATE,                           
    CONSTRAINT fk_location_id FOREIGN KEY (locationid) REFERENCES dim_location(locationid),
	CONSTRAINT fk_topic_id FOREIGN KEY (topicid) REFERENCES dim_topic(topicid),
    CONSTRAINT fk_question_id FOREIGN KEY (questionid) REFERENCES dim_question(questionid),
    CONSTRAINT fk_year_id FOREIGN KEY (year_id) REFERENCES dim_year(year_id),
    CONSTRAINT fk_stratification_id FOREIGN KEY (stratification_id) REFERENCES dim_stratification_category(stratification_id),
	CONSTRAINT fk_datasource_id FOREIGN KEY (datavalue_source_id) REFERENCES dim_data_source(data_source_id),
	CONSTRAINT fk_dataunit_id FOREIGN KEY (datavalueunit_id) REFERENCES dim_datavalue_unit(data_unit_id),
	CONSTRAINT fk_datatype_id FOREIGN KEY (datavaluetype_id) REFERENCES dim_datavalue_type(data_type_id),
	CONSTRAINT fk_datafootnote_id FOREIGN KEY (data_footnote_id) REFERENCES dim_datafootnote(data_footnote_id),
    CONSTRAINT fk_stratification_division_id FOREIGN KEY (stratification_division_id) REFERENCES dim_stratification_division(stratification_division_id)
);