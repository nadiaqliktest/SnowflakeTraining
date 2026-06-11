create view truck_franchise
as
SELECT
    t.*,
    f.first_name AS franchisee_first_name,
    f.last_name AS franchisee_last_name
FROM tasty_bytes.raw_pos.truck t
JOIN tasty_bytes.raw_pos.franchise f
    ON t.franchise_id = f.franchise_id;

    select * from truck_franchise
    where franchisee_first_name='Sara' and franchisee_last_name='Nicholson';


    describe view truck_franchise;

        drop view truck_franchise;

        create or replace dynamic table truck_franchise_dynamic
        target_lag = '1 minute'
        warehouse = compute_wh
        as
        SELECT
    t.*,
    f.first_name AS franchisee_first_name,
    f.last_name AS franchisee_last_name
FROM tasty_bytes.raw_pos.truck t
JOIN tasty_bytes.raw_pos.franchise f
    ON t.franchise_id = f.franchise_id;

    CREATE OR REPLACE DYNAMIC TABLE test_database.test_schema.nissan 
TARGET_LAG = '5 minutes' 
WAREHOUSE = compute_wh 
AS SELECT t.* 
FROM tasty_bytes.raw_pos.truck t 
WHERE t.make = 'Nissan';

select Count(*) from test_database.test_schema.nissan ;

 DROP DYNAMIC TABLE test_database.test_schema.nissan ;
