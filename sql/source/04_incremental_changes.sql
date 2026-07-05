-- =========================================================
-- SIMULATE UPDATES + NEW DATA (ERP SOURCE)
-- =========================================================

USE DATABASE ERP_PROVIDER_DB;
USE SCHEMA SHARE;

-- 1) Update existing orders (simulate late updates)
UPDATE ORDERS
SET
    STATUS = 'DELIVERED',
    UPDATED_AT = CURRENT_TIMESTAMP()
WHERE ORDER_ID BETWEEN 10 AND 30;

-- 2) Insert new orders (simulate new ingestion)
INSERT INTO ORDERS
(
    ORDER_ID,
    CUSTOMER_ID,
    PRODUCT_CODE,
    ORDER_DATE,
    QUANTITY,
    UNIT_PRICE,
    TOTAL_AMOUNT,
    STATUS,
    CREATED_AT,
    UPDATED_AT
)
SELECT
    1000 + SEQ4() + 1,
    MOD(SEQ4(),100) + 1,
    'PRD-' || LPAD(MOD(SEQ4(),50) + 1, 4, '0'),
    CURRENT_DATE(),
    MOD(SEQ4(),10) + 1,
    150,
    (MOD(SEQ4(),10) + 1) * 150,
    'NEW',
    CURRENT_TIMESTAMP(),
    CURRENT_TIMESTAMP()
FROM TABLE(GENERATOR(ROWCOUNT => 20));