-- ============================================================================
-- Enterprise Snowflake EL Platform
-- Metadata Configuration
--
-- Purpose:
--   Stores pipeline configuration for ingestion.
-- ============================================================================

USE ROLE ACCOUNTADMIN;
USE WAREHOUSE COMPUTE_WH;

USE DATABASE CLIENT_DATA_PLATFORM;
USE SCHEMA METADATA;

-- ============================================================================
-- TABLE CONFIGURATION
-- ============================================================================

CREATE OR REPLACE TABLE TABLE_CONFIG
(
    CONFIG_ID              NUMBER AUTOINCREMENT,

    SOURCE_DATABASE        STRING          NOT NULL,
    SOURCE_SCHEMA          STRING          NOT NULL,
    SOURCE_TABLE           STRING          NOT NULL,

    TARGET_DATABASE        STRING          NOT NULL,
    TARGET_SCHEMA          STRING          NOT NULL,
    TARGET_TABLE           STRING          NOT NULL,

    LOAD_TYPE              STRING          NOT NULL,      -- FULL | INCREMENTAL

    PRIMARY_KEY            STRING,

    INCREMENTAL_COLUMN     STRING,

    ACTIVE                 BOOLEAN DEFAULT TRUE,

    LOAD_ORDER             NUMBER DEFAULT 1,

    CREATED_AT             TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),

    CONSTRAINT PK_TABLE_CONFIG
        PRIMARY KEY (CONFIG_ID)
);

-- ============================================================================
-- INITIAL CONFIGURATION
-- ============================================================================

INSERT INTO TABLE_CONFIG
(
    SOURCE_DATABASE,
    SOURCE_SCHEMA,
    SOURCE_TABLE,

    TARGET_DATABASE,
    TARGET_SCHEMA,
    TARGET_TABLE,

    LOAD_TYPE,

    PRIMARY_KEY,

    INCREMENTAL_COLUMN,

    ACTIVE,

    LOAD_ORDER
)

VALUES
(

'ERP_PROVIDER_DB',
'SHARE',
'ORDERS',

'CLIENT_DATA_PLATFORM',
'RAW',
'ORDERS',

'INCREMENTAL',

'ORDER_ID',

'UPDATED_AT',

TRUE,

1

);

-- ============================================================================

SELECT *

FROM TABLE_CONFIG;