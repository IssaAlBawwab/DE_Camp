# Homework 1
## Question 1
- pip 24.3.1 
## Question 2
 - db:5432
## Question 3
1. 104,802
    - SELECT COUNT(*)
FROM "green-taxi-data-2019" AS G
WHERE lpep_pickup_datetime >= TO_DATE('20191001', 'YYYYMMDD')
  AND lpep_dropoff_datetime < TO_DATE('20191101', 'YYYYMMDD')
  AND trip_distance <= 1 ;

2. 198,924
    - SELECT COUNT(*)
FROM "green-taxi-data-2019" AS G
WHERE lpep_pickup_datetime >= TO_DATE('20191001', 'YYYYMMDD')
  AND lpep_dropoff_datetime < TO_DATE('20191101', 'YYYYMMDD')
  AND trip_distance > 1  AND trip_distance <= 3;

3. 109,603
    - just replacing numbers from above sqls

4. 27,678
    - just replacing numbers from sql above

5. 35,189
    - just replaced condition with > 10

## Question 4
- 2019-10-31
   - SELECT CAST(lpep_pickup_datetime AS DATE) AS pickup , MAX(trip_distance) as dist
    FROM "green-taxi-data-2019"
    GROUP BY pickup
    ORDER BY dist DESC 

## Question 5
- East Harlem North, East Harlem South, Morningside Heights
- SELECT z."Zone" AS pickup, SUM(t.total_amount) as total_amount
FROM "taxi_zone_lookup" AS z
INNER JOIN "green-taxi-data-2019" AS t ON t."PULocationID" = z."LocationID"
WHERE CAST(t.lpep_pickup_datetime AS DATE) = TO_DATE('2019-10-18', 'yyyy-mm-dd')
GROUP BY z."Zone"
ORDER BY total_amount DESC;

## Question 6
- JFK Airport
- SELECT lp."Zone" as pickup_zone, ld."Zone" as dropoff_zone , MAX(trip.tip_amount) as tip
FROM "green-taxi-data-2019" as trip
LEFT JOIN taxi_zone_lookup lp on trip."PULocationID" = lp."LocationID"
LEFT JOIN taxi_zone_lookup ld on trip."DOLocationID" = ld."LocationID"
WHERE lp."Zone" = 'East Harlem North'
AND EXTRACT(MONTH FROM trip."lpep_dropoff_datetime") = 10
GROUP BY pickup_zone, dropoff_zone
ORDER BY tip DESC;

## Question 7
- terraform init, terraform apply -auto-approve, terraform destroy
