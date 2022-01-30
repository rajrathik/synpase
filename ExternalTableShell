-- Add Scoped Credentials to connect datalake using managed Identity (no keys to maintain)
IF NOT EXISTS  (SELECT * FROM  sys.database_scoped_credentials WHERE name = 'crd_stgstoresales_01')
    CREATE DATABASE SCOPED CREDENTIAL crd_stgstoresales_01
        WITH    IDENTITY = 'Managed Identity'  ;

--- Add external data source 
IF NOT EXISTS (SELECT * FROM sys.external_data_sources WHERE name = 'eDSstgstoresales_01') 
    CREATE EXTERNAL DATA SOURCE eDSstgstoresales_01
    WITH (
        TYPE = HADOOP,
        LOCATION = 'abfss://stgstoresales-container@stgstoresales.dfs.core.windows.net',
        CREDENTIAL = crd_stgstoresales_01
    );

-- Add format file for lake (row 1 contains header, it is comma seperated file with string delimiter ")
IF NOT EXISTS  (SELECT * FROM  sys.external_file_formats where name='eFMT_CSV_01')
    CREATE EXTERNAL FILE FORMAT [eFMT_CSV_01] 
    WITH (
        FORMAT_TYPE = DELIMITEDTEXT,
        FORMAT_OPTIONS (
            FIELD_TERMINATOR = N',',
            STRING_DELIMITER = N'"',
            FIRST_ROW=2,
            USE_TYPE_DEFAULT=False
        )
    );

--- Add Schema
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'ext')   
    EXEC('CREATE SCHEMA [ext]'); 

-- Create table from data lake data to be mounted as external table
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Invoice'  
            AND SCHEMA_NAME(schema_id) = 'EXT')  
    CREATE EXTERNAL TABLE [ext].[Invoice]
    (
            [InvoiceID]	varchar(100)	,
            [Branch]	varchar(100)	,
            [City]	varchar(100)	,
            [CustomerType]	varchar(100)	,
            [Gender]	varchar(100)	,
            [ProductLine]	varchar(100)	,
            [UnitPrice]	varchar(100)	,
            [Quantity]	varchar(100)	,
            [Tax]	varchar(100)	,
            [Total]	varchar(100)	,
            [InvoiceDate]	varchar(100)	,
            [Time]	varchar(100)	,
            [Payment]	varchar(100)	,
            [COGS]	varchar(100)	,
            [GrossMarginPercnetage]	varchar(100)	,
            [GrossIncome]	varchar(100)	,
            [Rating]	varchar(100)
    )
    WITH (
        DATA_SOURCE = [eDSstgstoresales_01],
        LOCATION = N'supermarket_sales.csv',
        FILE_FORMAT = eFMT_CSV_01,
        REJECT_TYPE = VALUE,
        REJECT_VALUE = 0
    );

-- Read data
SELECT * FROM EXT.Invoice
