-- ============================================================================
-- Enterprise Snowflake EL Platform
-- Security
--
-- Purpose:
--   Grants permissions for dbt and Airflow.
-- ============================================================================

USE ROLE ACCOUNTADMIN;

-- ============================================================================
-- Warehouse
-- ============================================================================

GRANT USAGE, OPERATE
ON WAREHOUSE COMPUTE_WH
TO ROLE TRANSFORMER_ROLE;

GRANT USAGE, OPERATE
ON WAREHOUSE COMPUTE_WH
TO ROLE AIRFLOW_ROLE;

-- ============================================================================
-- CLIENT DATA PLATFORM
-- ============================================================================

GRANT USAGE
ON DATABASE CLIENT_DATA_PLATFORM
TO ROLE TRANSFORMER_ROLE;

GRANT USAGE
ON DATABASE CLIENT_DATA_PLATFORM
TO ROLE AIRFLOW_ROLE;

GRANT USAGE
ON ALL SCHEMAS IN DATABASE CLIENT_DATA_PLATFORM
TO ROLE TRANSFORMER_ROLE;

GRANT USAGE
ON ALL SCHEMAS IN DATABASE CLIENT_DATA_PLATFORM
TO ROLE AIRFLOW_ROLE;

GRANT USAGE
ON FUTURE SCHEMAS IN DATABASE CLIENT_DATA_PLATFORM
TO ROLE TRANSFORMER_ROLE;

GRANT USAGE
ON FUTURE SCHEMAS IN DATABASE CLIENT_DATA_PLATFORM
TO ROLE AIRFLOW_ROLE;

-- ============================================================================
-- MONITORING
-- ============================================================================

GRANT USAGE
ON DATABASE MONITORING_DB
TO ROLE TRANSFORMER_ROLE;

GRANT USAGE
ON DATABASE MONITORING_DB
TO ROLE AIRFLOW_ROLE;

GRANT USAGE
ON ALL SCHEMAS IN DATABASE MONITORING_DB
TO ROLE TRANSFORMER_ROLE;

GRANT USAGE
ON ALL SCHEMAS IN DATABASE MONITORING_DB
TO ROLE AIRFLOW_ROLE;

-- ============================================================================
-- ERP PROVIDER
-- ============================================================================

GRANT USAGE
ON DATABASE ERP_PROVIDER_DB
TO ROLE TRANSFORMER_ROLE;

GRANT USAGE
ON DATABASE ERP_PROVIDER_DB
TO ROLE AIRFLOW_ROLE;

GRANT USAGE
ON ALL SCHEMAS IN DATABASE ERP_PROVIDER_DB
TO ROLE TRANSFORMER_ROLE;

GRANT USAGE
ON ALL SCHEMAS IN DATABASE ERP_PROVIDER_DB
TO ROLE AIRFLOW_ROLE;

-- ============================================================================
-- Tables
-- ============================================================================

GRANT SELECT, INSERT, UPDATE, DELETE
ON ALL TABLES IN DATABASE CLIENT_DATA_PLATFORM
TO ROLE TRANSFORMER_ROLE;

GRANT SELECT, INSERT, UPDATE, DELETE
ON FUTURE TABLES IN DATABASE CLIENT_DATA_PLATFORM
TO ROLE TRANSFORMER_ROLE;

GRANT SELECT, INSERT, UPDATE, DELETE
ON ALL TABLES IN DATABASE CLIENT_DATA_PLATFORM
TO ROLE AIRFLOW_ROLE;

GRANT SELECT, INSERT, UPDATE, DELETE
ON FUTURE TABLES IN DATABASE CLIENT_DATA_PLATFORM
TO ROLE AIRFLOW_ROLE;

-- ============================================================================
-- ERP Source
-- ============================================================================

GRANT SELECT
ON ALL TABLES IN DATABASE ERP_PROVIDER_DB
TO ROLE TRANSFORMER_ROLE;

GRANT SELECT
ON FUTURE TABLES IN DATABASE ERP_PROVIDER_DB
TO ROLE TRANSFORMER_ROLE;

GRANT SELECT
ON ALL TABLES IN DATABASE ERP_PROVIDER_DB
TO ROLE AIRFLOW_ROLE;

GRANT SELECT
ON FUTURE TABLES IN DATABASE ERP_PROVIDER_DB
TO ROLE AIRFLOW_ROLE;

-- ============================================================================
-- Monitoring
-- ============================================================================

GRANT SELECT, INSERT, UPDATE
ON ALL TABLES IN DATABASE MONITORING_DB
TO ROLE TRANSFORMER_ROLE;

GRANT SELECT, INSERT, UPDATE
ON FUTURE TABLES IN DATABASE MONITORING_DB
TO ROLE TRANSFORMER_ROLE;

GRANT SELECT, INSERT, UPDATE
ON ALL TABLES IN DATABASE MONITORING_DB
TO ROLE AIRFLOW_ROLE;

GRANT SELECT, INSERT, UPDATE
ON FUTURE TABLES IN DATABASE MONITORING_DB
TO ROLE AIRFLOW_ROLE;

-- ============================================================================
-- END
-- ============================================================================

SELECT 'Security configuration completed successfully.' AS STATUS;