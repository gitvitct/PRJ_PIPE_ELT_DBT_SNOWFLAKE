-- ============================================================================
-- ERP Provider - Products
-- ============================================================================

USE ROLE ACCOUNTADMIN;
USE WAREHOUSE COMPUTE_WH;

USE DATABASE ERP_PROVIDER_DB;
USE SCHEMA SHARE;

CREATE OR REPLACE TABLE PRODUCTS
(
    PRODUCT_CODE    VARCHAR(20)      NOT NULL,
    PRODUCT_NAME    VARCHAR(200),
    CATEGORY        VARCHAR(100),
    UNIT_PRICE      NUMBER(10,2),

    CONSTRAINT PK_PRODUCTS
        PRIMARY KEY (PRODUCT_CODE)
);

INSERT OVERWRITE INTO PRODUCTS
SELECT
    'PRD-' || LPAD(SEQ4()+1,4,'0')                   AS PRODUCT_CODE,

    'Product ' || (SEQ4()+1)                         AS PRODUCT_NAME,

    CASE MOD(SEQ4(),5)
        WHEN 0 THEN 'Hardware'
        WHEN 1 THEN 'Software'
        WHEN 2 THEN 'Accessories'
        WHEN 3 THEN 'Services'
        ELSE 'Office'
    END                                              AS CATEGORY,

    ROUND(UNIFORM(20,2000,RANDOM()),2)               AS UNIT_PRICE

FROM TABLE(GENERATOR(ROWCOUNT=>50));

SELECT COUNT(*) AS TOTAL_PRODUCTS
FROM PRODUCTS;