with fhv as (
    select * from {{ source('staging', 'fhv_tripdata') }}
)

select * from fhv
where dispatching_base_num is not null