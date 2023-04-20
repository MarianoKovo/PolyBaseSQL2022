-- Create a database master key if one does not already exist, using your own password. This key is used to encrypt the credential secret in next step.
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'Pass@word1!!!' ;
GO

--DROP DATABASE SCOPED CREDENTIAL AzureStorageCredentialv2
CREATE DATABASE SCOPED CREDENTIAL AzureStorageCredentialv2
WITH
  IDENTITY = 'SHARED ACCESS SIGNATURE', -- to use SAS the identity must be fixed as-is
  SECRET = '<SAS SIGNATURE FROM AZURE>' ;
GO

-- Create an external data source with CREDENTIAL option.

  CREATE EXTERNAL DATA SOURCE data_lake_gen2_dfs
WITH
(
LOCATION = 'adls://<Container>@<ADLS Account>.dfs.core.windows.net'
,CREDENTIAL = AzureStorageCredentialv2
)

-- Create an external File Format for CSV option.

CREATE EXTERNAL FILE FORMAT COMMA_CSV
WITH (FORMAT_TYPE = DELIMITEDTEXT,
      FORMAT_OPTIONS(
          FIELD_TERMINATOR = ',',
          STRING_DELIMITER = '',
          FIRST_ROW = 2,
          USE_TYPE_DEFAULT = True)
);

-- Create an external TABLE.

CREATE EXTERNAL TABLE extCall_People_csv
(
            PIndex  bigint,
            UserId varchar(15),
            First_Name varchar(50),
            Last_Name varchar(50),
            Sex varchar(15),
            Email varchar(100),
            Phone varchar(100),
            Date_of_birth date,
            Job_Title varchar(100)
)
WITH (
    LOCATION = '/2022/',					--Location pointing to Folder
    DATA_SOURCE =  data_lake_gen2_dfs       -- Datasource
    ,FILE_FORMAT = COMMA_CSV				-- FIle format
);
GO
