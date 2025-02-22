with fhv as (
    select * from {{ ref('dim_fhv_trips') }}
),
fhv_with_duration as 
(select *, TIMESTAMP_DIFF(dropOff_datetime,pickup_datetime,SECOND) as trip_duration 
from fhv)

select *, PERCENTILE_CONT(trip_duration,0.9) OVER(
    PARTITION BY year, month,puID,doID
) AS p90 from fhv_with_duration