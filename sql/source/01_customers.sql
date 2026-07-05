-- ============================================================================
-- ERP Provider - Customers
-- ============================================================================

USE ROLE ACCOUNTADMIN;
USE WAREHOUSE COMPUTE_WH;

USE DATABASE ERP_PROVIDER_DB;
USE SCHEMA SHARE;

CREATE OR REPLACE TABLE CUSTOMERS
(
    CUSTOMER_ID     NUMBER          NOT NULL,
    CUSTOMER_NAME   VARCHAR(200)    NOT NULL,
    COUNTRY         VARCHAR(100),
    CITY            VARCHAR(100),
    CREATED_AT      TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),

    CONSTRAINT PK_CUSTOMERS
        PRIMARY KEY (CUSTOMER_ID)
);

INSERT OVERWRITE INTO CUSTOMERS
SELECT
    SEQ4() + 1                                            AS CUSTOMER_ID,
    'Customer ' || (SEQ4() + 1)                           AS CUSTOMER_NAME,
    CASE MOD(SEQ4(),5)
        WHEN 0 THEN 'USA'
        WHEN 1 THEN 'Brazil'
        WHEN 2 THEN 'Canada'
        WHEN 3 THEN 'Germany'
        ELSE 'UK'
    END                                                   AS COUNTRY,
    CASE MOD(SEQ4(),5)
        WHEN 0 THEN 'New York'
        WHEN 1 THEN 'Florianopolis'
        WHEN 2 THEN 'Toronto'
        WHEN 3 THEN 'Berlin'
        ELSE 'London'
    END                                                   AS CITY,
    DATEADD(
        DAY,
        -UNIFORM(1,365,RANDOM()),
        CURRENT_TIMESTAMP()
    )                                                     AS CREATED_AT
FROM TABLE(GENERATOR(ROWCOUNT=>100));

SELECT COUNT(*) AS TOTAL_CUSTOMERS
FROM CUSTOMERS;