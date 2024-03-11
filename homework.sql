CREATE MATERIALIZED VIEW taxi_zone_trip_stats AS
SELECT
    pz.Zone AS pickup_zone,
    dz.Zone AS dropoff_zone,
    AVG(td.tpep_dropoff_datetime - td.tpep_pickup_datetime) AS avg_trip_time_minutes,
    MIN(td.tpep_dropoff_datetime - td.tpep_pickup_datetime) AS min_trip_time_minutes,
    MAX(td.tpep_dropoff_datetime - td.tpep_pickup_datetime) AS max_trip_time_minutes
FROM
    trip_data td
JOIN
    taxi_zone pz ON td.PULocationID = pz.location_id
JOIN
    taxi_zone dz ON td.DOLocationID = dz.location_id
GROUP BY
    pz.Zone,
    dz.Zone;

# Question 1
SELECT 
    pickup_zone, 
    dropoff_zone, 
    avg_trip_time_minutes AS max_avg_time
FROM 
    taxi_zone_trip_stats
ORDER BY 
    avg_trip_time_minutes DESC
LIMIT 1;

# Question 2
SELECT COUNT(*) 
FROM taxi_zone_trip_stats 
WHERE pickup_zone = 'Yorkville East' AND dropoff_zone = 'Steinway';

# Question 3
SELECT 
    pz.Zone AS pickup_zone_name, 
    COUNT(td.vendorid) AS total_pickups
FROM 
    trip_data td
JOIN 
    taxi_zone pz ON td.PULocationID = pz.location_id
WHERE 
    td.tpep_pickup_datetime BETWEEN
    (SELECT MAX(tpep_pickup_datetime) - INTERVAL '17 hours' FROM trip_data)
    AND
    (SELECT MAX(tpep_pickup_datetime) FROM trip_data)
GROUP BY 
    pz.Zone
ORDER BY 
    total_pickups DESC;


