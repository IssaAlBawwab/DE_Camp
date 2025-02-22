with fhv as (
    select * from {{ ref('stg_fhv') }}
),
dim_zones as (
    select * from {{ ref('dim_zones') }}
    where borough != 'Unknown'
)
select fhv.dispatching_base_num,fhv.pickup_datetime,
EXTRACT(YEAR from pickup_datetime) as year,
EXTRACT (MONTH from pickup_datetime) as month,fhv.dropOff_datetime,
fhv.PULocationID as puID, fhv.DOLocationID as doID,
pickup_zone.zone as pickup_zone,
pickup_zone.borough as pickup_borough,
dropoff_zone.zone as dropoff_zone,
dropoff_zone.borough as dropoff_borough
from fhv
inner join dim_zones as pickup_zone
on fhv.PULocationID= pickup_zone.locationid
inner join dim_zones as dropoff_zone
on fhv.DOLocationID = dropoff_zone.locationid