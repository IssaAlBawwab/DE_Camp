# Homework 4


## Question 1
 - select * from myproject.raw_nyc_tripdata.ext_green_taxi

## Question 2
 - Update the WHERE clause to pickup_datetime >= CURRENT_DATE - INTERVAL '{{ var("days_back", env_var("DAYS_BACK", "30")) }}' DAY

## Question 3
 - dbt run --select models/staging/+

## Question 4
 - Setting a value for DBT_BIGQUERY_TARGET_DATASET env var is mandatory, or it'll fail to compile
 - When using core, it materializes in the dataset defined in DBT_BIGQUERY_TARGET_DATASET
 - When using stg, it materializes in the dataset defined in DBT_BIGQUERY_STAGING_DATASET, or defaults to DBT_BIGQUERY_TARGET_DATASET
 - When using staging, it materializes in the dataset defined in DBT_BIGQUERY_STAGING_DATASET, or defaults to DBT_BIGQUERY_TARGET_DATASET

## Question 5
 - with trip_data as (
    select year_quarter,quarter, year, total_amount,   service_type
    from {{ ref('fact_trips') }}
    ),
    grouped as (
        select service_type,year,quarter , sum(total_amount) as quarterly_revenue
        from trip_data
        where year in (2019,2020)
        group by service_type,year, quarter
        order by year, quarter)

    select 
    curr.service_type,curr.year as curr_year, prev.year as prev_year, curr.quarter as curr_quarter,prev.quarter as prev_quarter,
    curr.quarterly_revenue as curr_revenue, prev.quarterly_revenue as prev_revenue,
    ROUND(
            ((curr.quarterly_revenue - prev.quarterly_revenue) / prev.quarterly_revenue) * 100, 2
        ) AS yoy_growth_percentage
    from grouped curr
    left join grouped prev
    on curr.quarter = prev.quarter
    and curr.year = prev.year + 1
    and curr.service_type = prev.service_type
    where curr.year = 2020
    order by  service_type, yoy_growth_percentage desc
 - green: {best: 2020/Q1, worst: 2020/Q2}, yellow: {best: 2020/Q1, worst: 2020/Q2}

## Question 6
 - {{
    config(
        materialized='table'
    )
    }}

    WITH filtered_data AS (
        SELECT *
        FROM {{ ref('fact_trips') }}
        WHERE fare_amount > 0
        AND trip_distance > 0
        AND payment_type_description IN ('Cash', 'Credit Card')
    )

    SELECT 
        service_type,
        year,
        EXTRACT(MONTH FROM pickup_datetime) AS month,
        fare_amount,
        PERCENT_RANK() OVER (
            PARTITION BY service_type, year, EXTRACT(MONTH FROM pickup_datetime)
            ORDER BY fare_amount ASC
        ) AS fare_percentile
    FROM filtered_data

 - SELECT 
    service_type,
    year,
    month,
    PERCENTILE_CONT(fare_amount,0.97)  OVER() AS p97,
    PERCENTILE_CONT(fare_amount,0.95)  OVER() AS p95,
    PERCENTILE_CONT(fare_amount,0.90)  OVER() AS p90
    FROM `dbt_fdota.fct_taxi_trips_monthly_fare_p95`
    WHERE year = 2020 
    AND month = 4
 - green: {p97: 40.0, p95: 33.0, p90: 24.5}, yellow: {p97: 31.5, p95: 25.5, p90: 19.0}

## Question 7
 - LaGuardia Airport, Saint Albans, Howard Beach
 - WITH ranked_trips AS (
    SELECT 
        pickup_zone,
        dropoff_zone,
        p90,
        ROW_NUMBER() OVER (
            PARTITION BY pickup_zone 
            ORDER BY p90 DESC
        ) AS rank
    FROM `fluid-stratum-440314-g5.dbt_fdota.fct_fhv_monthly_zone_traveltime_p90`
    WHERE 
        pickup_zone IN ('Newark Airport', 'SoHo', 'Yorkville East')
        AND EXTRACT(YEAR FROM pickup_datetime) = 2019
        AND EXTRACT(MONTH FROM pickup_datetime) = 11
)
SELECT 
    pickup_zone,
    dropoff_zone,
    p90
FROM ranked_trips
WHERE rank = 2;