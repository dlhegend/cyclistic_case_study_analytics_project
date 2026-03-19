/* The 12 months have the same fields and can be merged to one annual table for analysis
This is done using the `UNION ALL` statement rather than any of the `JOIN` statements as we want to merge the data vertically rather than horizontally.*/

CREATE TABLE `big-keyword-484012-f6.cyclistic_bike_db.2025_tripdata` AS
  SELECT * FROM `big-keyword-484012-f6.cyclistic_bike_db.202501_tripdata`
  UNION ALL
  SELECT * FROM `big-keyword-484012-f6.cyclistic_bike_db.202502_tripdata`
  UNION ALL
  SELECT * FROM `big-keyword-484012-f6.cyclistic_bike_db.202503_tripdata`
  UNION ALL
  SELECT * FROM `big-keyword-484012-f6.cyclistic_bike_db.202504_tripdata`
  UNION ALL
  SELECT * FROM `big-keyword-484012-f6.cyclistic_bike_db.202505_tripdata`
  UNION ALL
  SELECT * FROM `big-keyword-484012-f6.cyclistic_bike_db.202506_tripdata`
  UNION ALL
  SELECT * FROM `big-keyword-484012-f6.cyclistic_bike_db.202507_tripdata`
  UNION ALL
  SELECT * FROM `big-keyword-484012-f6.cyclistic_bike_db.202508_tripdata`
  UNION ALL
  SELECT * FROM `big-keyword-484012-f6.cyclistic_bike_db.202509_tripdata`
  UNION ALL
  SELECT * FROM `big-keyword-484012-f6.cyclistic_bike_db.202510_tripdata`
  UNION ALL
  SELECT * FROM `big-keyword-484012-f6.cyclistic_bike_db.202511_tripdata`
  UNION ALL
  SELECT * FROM `big-keyword-484012-f6.cyclistic_bike_db.202512_tripdata`;

-- The annual table `2025_tripdata` has been successfully created

-- We can view the head of this data
SELECT *
FROM `big-keyword-484012-f6.cyclistic_bike_db.2025_tripdata`
LIMIT 10;

-- We can also confirm the total number of rows in our new table
SELECT COUNT(*) AS `total_rows`
FROM `big-keyword-484012-f6.cyclistic_bike_db.2025_tripdata`;

-- This confirms that we have `5,552,994 rows` in our table

-- Let's also confirm there are no duplicates using the `ride_id`
SELECT
  COUNT(ride_id) AS `total_rows`,
  COUNT(DISTINCT(ride_id)) AS `unique_rows`
FROM `big-keyword-484012-f6.cyclistic_bike_db.2025_tripdata`;

-- This confirms each observation is `unique`

-- View percentage of data where `started_at` is erroneously greater than or equal to `ended_at`
SELECT COUNT(*) / 5552994 * 100 AS `error_%`
FROM `big-keyword-484012-f6.cyclistic_bike_db.2025_tripdata`
WHERE started_at >= ended_at;

-- approx. 0.00%; though such rows exists

-- Check if such rows exists where `start_station_name` is given but no `start_station_id` or vice versa
SELECT COUNT(*)
FROM `big-keyword-484012-f6.cyclistic_bike_db.2025_tripdata`
WHERE (start_station_name IS NOT NULL AND start_station_id IS NULL) OR (start_station_name IS NULL AND start_station_id IS NOT NULL);

-- Result: (0); No such rows 

-- Run a similar check for `end_station_name` and `end_station_id`
SELECT COUNT(*)
FROM `big-keyword-484012-f6.cyclistic_bike_db.2025_tripdata`
WHERE (end_station_name IS NOT NULL AND end_station_id IS NULL) OR (end_station_name IS NULL AND end_station_id IS NOT NULL);

-- Result: (0); No such rows 

SELECT 
    SUM(CASE WHEN (rideable_type IS NULL) OR (rideable_type = "") THEN 1 ELSE 0 END) `missing_rideable_type`,
    5552994 - COUNT(started_at) `missing_started_at`,
    5552994 - COUNT(ended_at) `missing_ended_at`,
    SUM(CASE WHEN (start_station_name IS NULL) OR (start_station_name = "") THEN 1 ELSE 0 END) `missing_start_station_name`,
    SUM(CASE WHEN (end_station_name IS NULL) OR (end_station_name = "") THEN 1 ELSE 0 END) `missing_end_station_name`,
    SUM(CASE WHEN (member_casual IS NULL) OR (member_casual = "") THEN 1 ELSE 0 END) `missing_member_casual`
FROM `big-keyword-484012-f6.cyclistic_bike_db.2025_tripdata`;

-- This confirms missing values in the station names columns and consequently in the station IDs columns

-- View percentage of missing values
SELECT ROUND(COUNT(*) / 5552994 * 100, 2) AS `missing_%`
FROM `big-keyword-484012-f6.cyclistic_bike_db.2025_tripdata`
WHERE (start_station_name IS NOT NULL AND end_station_name IS NULL) OR (start_station_name IS NULL AND end_station_name IS NOT NULL) OR (start_station_name IS NULL AND end_station_name IS NULL);

-- ~33.49% might be a lot of data to drop;

/* We will now continue our analysis in Connected Sheets
This allows us to work in the familiar Spreadsheets environment for analysis and visualizations*/