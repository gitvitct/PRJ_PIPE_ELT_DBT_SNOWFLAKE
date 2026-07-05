-- ============================================================================
-- Enterprise Snowflake EL Platform
-- Bootstrap
--
-- Purpose:
--   Creates the base infrastructure for the Enterprise EL Platform.
--
-- Safe to execute multiple times.
-- ============================================================================

USE ROLE ACCOUNTADMIN;

-- ============================================================================
-- WAREHOUSE
-- ============================================================================

CREATE WAREHOUSE IF NOT EXISTS COMPUTE_WH
WITH
    WAREHOUSE_SIZE = 'XSMALL'
    AUTO_SUSPEND = 60
    AUTO_RESUME = TRUE
    INITIALLY_SUSPENDED = TRUE
    COMMENT = 'Warehouse used by the Enterprise EL Platform POC';

-- ============================================================================
-- DATABASES
-- ============================================================================

CREATE DATABASE IF NOT EXISTS ERP_PROVIDER_DB
COMMENT = 'Simulates the ERP Provider Snowflake Account';

CREATE DATABASE IF NOT EXISTS CLIENT_DATA_PLATFORM
COMMENT = 'Client Data Platform';

CREATE DATABASE IF NOT EXISTS MONITORING_DB
COMMENT = 'Monitoring Database';

-- ============================================================================
-- ERP PROVIDER
-- ============================================================================

CREATE SCHEMA IF NOT EXISTS ERP_PROVIDER_DB.SHARE
COMMENT = 'Simulated Snowflake Data Share';

-- ============================================================================
-- CLIENT PLATFORM
-- ============================================================================

CREATE SCHEMA IF NOT EXISTS CLIENT_DATA_PLATFORM.RAW
COMMENT = 'Raw replicated data';

CREATE SCHEMA IF NOT EXISTS CLIENT_DATA_PLATFORM.CORE
COMMENT = 'Business transformation layer';

CREATE SCHEMA IF NOT EXISTS CLIENT_DATA_PLATFORM.ANALYTICS
COMMENT = 'Analytics ready layer';

CREATE SCHEMA IF NOT EXISTS CLIENT_DATA_PLATFORM.METADATA
COMMENT = 'Pipeline metadata';

-- ============================================================================
-- MONITORING
-- ============================================================================

CREATE SCHEMA IF NOT EXISTS MONITORING_DB.PIPELINE
COMMENT = 'Pipeline monitoring';

-- ============================================================================
-- ROLES
-- ============================================================================

CREATE ROLE IF NOT EXISTS TRANSFORMER_ROLE
COMMENT = 'Role used by dbt';

CREATE ROLE IF NOT EXISTS AIRFLOW_ROLE
COMMENT = 'Role used by Apache Airflow';

-- ============================================================================
-- END
-- ============================================================================

SELECT 'Bootstrap completed successfully.' AS STATUS;