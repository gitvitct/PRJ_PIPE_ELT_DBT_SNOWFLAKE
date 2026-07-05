-- models/staging/stg_orders.sql

with source as (

    select *
    from {{ source('raw', 'orders') }}

),

deduplicated as (

    select *
    from source

    qualify row_number() over (
        partition by order_id
        order by updated_at desc
    ) = 1

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

from deduplicated