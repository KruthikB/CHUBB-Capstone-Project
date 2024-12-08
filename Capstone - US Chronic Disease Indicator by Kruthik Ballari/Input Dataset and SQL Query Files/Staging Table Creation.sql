CREATE TABLE stg_us_chronic (
    YearStart INT,
    YearEnd INT,
    LocationAbbr VARCHAR(255),
    LocationDesc VARCHAR(255),
    DataSource VARCHAR(255) ,
    Topic VARCHAR(255) ,
    Question VARCHAR(255) ,
    Response FLOAT,
    DataValueUnit VARCHAR(255),
    DataValueType VARCHAR(255),
    DataValue varchar(255),
    DataValueAlt FLOAT,
    DataValueFootnoteSymbol VARCHAR(255),
    DatavalueFootnote VARCHAR(255),
    LowConfidenceLimit FLOAT,
    HighConfidenceLimit FLOAT,
    StratificationCategory1 VARCHAR(255),
    Stratification1 VARCHAR(255) ,
    StratificationCategory2 VARCHAR(255),
    Stratification2 VARCHAR(255),
    StratificationCategory3 VARCHAR(255),
    Stratification3 VARCHAR(255),
    GeoLocation VARCHAR(255),
    ResponseID FLOAT,
    LocationID INT,
    TopicID VARCHAR(255),
    QuestionID VARCHAR(255),
    DataValueTypeID VARCHAR(255),
    StratificationCategoryID1 VARCHAR(255),
    StratificationID1 VARCHAR(255),
    StratificationCategoryID2 VARCHAR(255),
    StratificationID2 VARCHAR(255),
    StratificationCategoryID3 VARCHAR(255),
    StratificationID3 VARCHAR(255)
);


select * from  stg_us_chronic

--drop table stg_us_chronic
--truncate table stg_us_chronic