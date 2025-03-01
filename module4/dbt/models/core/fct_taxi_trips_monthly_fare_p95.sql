{{
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