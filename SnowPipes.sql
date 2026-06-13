CREATE OR REPLACE STORAGE INTEGRATION S3_role_integration 
    TYPE = EXTERNAL_STAGE
    STORAGE_PROVIDER = S3
    ENABLED = TRUE
    STORAGE_AWS_ROLE_ARN = "arn:aws:iam::123416524369:role/snowflake_role_snowpipe"
    STORAGE_ALLOWED_LOCATIONS = ("s3://06132026snowflake/");

    DESCRIBE INTEGRATION S3_role_integration;

    CREATE OR REPLACE DATABASE S3_db;

    CREATE OR REPLACE TABLE S3_table (food STRING, taste INT );

    CREATE OR REPLACE STAGE S3_stage
        url = ("s3://06132026snowflake/")
        storage_integration = S3_role_integration ;

SHOW STAGES;

LIST @S3_stage;

select $1, $2 FROM @S3_stage/food_taste_ratings.csv;

use warehouse compute_wh;

CREATE OR REPLACE FILE FORMAT my_csv_format
  TYPE = CSV
  FIELD_DELIMITER = ','
  SKIP_HEADER = 1
  FIELD_OPTIONALLY_ENCLOSED_BY = '"';


CREATE OR REPLACE PIPE s3_db.public.s3_pipe
  AUTO_INGEST = TRUE
AS
COPY INTO s3_db.public.s3_table
FROM @s3_db.public.s3_stage
FILE_FORMAT = (FORMAT_NAME = s3_db.public.my_csv_format)
PATTERN = '.*\\.csv';

SELECT * FROM s3_db.public.s3_table;

SELECT SYSTEM$PIPE_STATUS('s3_db.public.s3_pipe');


SELECT *
FROM TABLE(
  INFORMATION_SCHEMA.COPY_HISTORY(
    TABLE_NAME => 's3_db.public.s3_table',
    START_TIME => DATEADD(hours, -2, CURRENT_TIMESTAMP())
  )
)
ORDER BY LAST_LOAD_TIME DESC;

SHOW PIPES;

DESC PIPE s3_db.public.s3_pipe;

alter pipe s3_db.public.s3_pipe set pipe_execution_paused = TRUE;

DROP PIPE s3_pipe;

SHOW PIPES;
