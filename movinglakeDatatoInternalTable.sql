--- Create internal table 
CREATE TABLE Invoice ( [Invoice ID] varchar(100)    ,
   [Branch]    varchar(100)    ,
   [City]  varchar(100)    ,
   [Customer type] varchar(100)    ,
   [Gender]    varchar(100)    ,
   [Product line]  varchar(100)    ,
   [Unit price]    varchar(100)    ,
   [Quantity]  varchar(100)    ,
   [Tax 5%]    varchar(100)    ,
   [Total] varchar(100)    ,
   [Date]  varchar(100)    ,
   [Time]  varchar(100)    ,
   [Payment]   varchar(100)    ,
   [cogs]  varchar(100)    ,
   [gross margin percentage]   varchar(100)    ,
   [gross income]  varchar(100)    ,
   [Rating]    varchar(100)    );
   

--- remove any old data from the current table
TRUNCATE TABLE [Invoice];

--- Populate table from datalake file
COPY INTO [Invoice]
(  [Invoice ID]   ,[Branch]    ,[City]  ,[Customer type] ,
   [Gender]    ,[Product line]  ,[Unit price]    ,
   [Quantity]  ,[Tax 5%]    ,[Total] ,
   [Date]  ,[Time]  ,[Payment]   ,[cogs]  ,
   [gross margin percentage]   ,[gross income]  ,
   [Rating]
)
FROM 'https://stgstoresales.dfs.core.windows.net/stgstoresales-container/supermarket_sales.csv'
WITH (
      FILE_TYPE = 'CSV'
      ,ROWTERMINATOR = '0x0A'
      ,FirstRow = 2
      ,FIELDTERMINATOR = ','
      ,CREDENTIAL = (IDENTITY = 'Managed Identity')
);
