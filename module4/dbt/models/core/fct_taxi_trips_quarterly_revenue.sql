{{
    config(
        materialized='table'
    )
}}

with trip_data as (
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