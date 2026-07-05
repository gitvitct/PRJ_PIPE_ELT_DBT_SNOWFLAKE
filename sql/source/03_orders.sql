-- ============================================================================
-- ERP Provider - Orders (SNOWFLAKE SAFE VERSION)
-- ============================================================================

USE ROLE ACCOUNTADMIN;
USE WAREHOUSE COMPUTE_WH;

USE DATABASE ERP_PROVIDER_DB;
USE SCHEMA SHARE;

-- ============================================================================
-- TABLE
-- ============================================================================

CREATE OR REPLACE TABLE ORDERS
(
    ORDER_ID        NUMBER          NOT NULL,
    CUSTOMER_ID     NUMBER          NOT NULL,
    PRODUCT_CODE    VARCHAR(20)     NOT NULL,

    ORDER_DATE      DATE            NOT NULL,
    QUANTITY        NUMBER(10,0)    NOT NULL,

    UNIT_PRICE      NUMBER(10,2)    NOT NULL,
    TOTAL_AMOUNT    NUMBER(12,2)    NOT NULL,

    STATUS          VARCHAR(30)     NOT NULL,

    CREATED_AT      TIMESTAMP_NTZ   NOT NULL,
    UPDATED_AT      TIMESTAMP_NTZ   NOT NULL
);

-- ============================================================================
-- DATA GENERATION (SAFE)
-- ============================================================================

INSERT OVERWRITE INTO ORDERS
SELECT
    seq.ORDER_ID,

    (MOD(seq.ORDER_ID, 100) + 1) AS CUSTOMER_ID,

    'PRD-' || LPAD(MOD(seq.ORDER_ID, 50) + 1, 4, '0') AS PRODUCT_CODE,

    DATEADD(DAY, -MOD(seq.ORDER_ID, 180), CURRENT_DATE()) AS ORDER_DATE,

    (MOD(seq.ORDER_ID, 10) + 1) AS QUANTITY,

    (MOD(seq.ORDER_ID, 50) + 1) * 10 AS UNIT_PRICE,

    ((MOD(seq.ORDER_ID, 10) + 1) * ((MOD(seq.ORDER_ID, 50) + 1) * 10)) AS TOTAL_AMOUNT,

    CASE MOD(seq.ORDER_ID, 5)
        WHEN 0 THEN 'NEW'
        WHEN 1 THEN 'PROCESSING'
        WHEN 2 THEN 'SHIPPED'
        WHEN 3 THEN 'DELIVERED'
        ELSE 'CANCELLED'
    END AS STATUS,

    DATEADD(DAY, -MOD(seq.ORDER_ID, 180), CURRENT_TIMESTAMP()) AS CREATED_AT,

    DATEADD(DAY, -MOD(seq.ORDER_ID, 30), CURRENT_TIMESTAMP()) AS UPDATED_AT

FROM (
    SELECT
        SEQ4() + 1 AS ORDER_ID
    FROM TABLE(GENERATOR(ROWCOUNT => 1000))
) seq;

-- ============================================================================
-- VALIDATION
-- ============================================================================

SELECT COUNT(*) AS TOTAL_ORDERS FROM ORDERS;

SELECT * FROM ORDERS LIMIT 10;