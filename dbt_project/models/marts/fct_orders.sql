-- models/marts/fct_orders.sql

{{ config(
    materialized='incremental',
    unique_key='order_id'
) }}

with source as (

    select *
    from {{ ref('stg_orders') }}

)

select
    order_id,
    customer_id,
    product_code,
    order_date,
    quantity,
    unit_price,
    total_amount,
    status,
    created_at,
    updated_at

from source

{% if is_incremental() %}

-- only process new or updated records
where updated_at > (select max(updated_at) from {{ this }})

{% endif %}