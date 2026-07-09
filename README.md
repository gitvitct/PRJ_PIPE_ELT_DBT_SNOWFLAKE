# Enterprise ELT Pipeline | Airflow + Snowflake + dbt

A production-inspired ELT pipeline built with Airflow, Snowflake and dbt, demonstrating modern Data Engineering practices including orchestration, incremental loading, data quality validation and layered data modeling.

---

## Architecture

```
                ERP Provider
                     │
                     │
                     ▼
          Snowflake Shared Database
                     │
                     ▼
              SNOWFLAKE TASKS
      Initial Load / Incremental Load
                     │
                     ▼
             RAW Schema (Landing)
                     │
                     ▼
                  dbt Models
         Staging Layer → Mart Layer
                     │
                     ▼
               Analytics Tables
                     │
                     ▼
               dbt Data Tests
```

Airflow orchestrates the complete workflow.

---

## Technology Stack

- Apache Airflow
- Snowflake
- dbt Core
- Docker & Docker Compose
- SQL
- Python

---

## Project Structure

```
.
├── airflow/
│   ├── dags/
│   └── plugins/
│
├── dbt_project/
│   ├── models/
│   │   ├── sources/
│   │   ├── staging/
│   │   └── marts/
│   ├── dbt_project.yml
│   └── profiles.yml
│
├── snowflake/
│   ├── bootstrap_snowflake.sql
│   └── procedures/
│
├── docker-compose.yml
└── README.md
```

---

## Pipeline Flow

### 1. Initial Load

The pipeline starts by executing a Snowflake Stored Procedure responsible for performing the initial load.

```
ERP Share
      │
      ▼
RAW.ORDERS
```

---

### 2. Incremental Load

Subsequent executions use a MERGE statement to:

- insert new orders
- update modified orders

This minimizes processing time while maintaining consistency.

---

### 3. dbt Staging Layer

The staging layer:

- standardizes data
- removes duplicated records
- keeps only the latest version of each order

using

```
ROW_NUMBER()
QUALIFY
```

---

### 4. Mart Layer

Business-ready tables are created for analytics.

Example:

```
FCT_ORDERS
```

---

### 5. Data Quality

dbt tests validate:

- Primary Keys
- Not Null
- Accepted Values
- Source Validation
- Uniqueness

Pipeline execution fails automatically if any quality rule is violated.

---

## Airflow DAG

```
start
   │
   ▼
Initial Load
   │
   ▼
Incremental Load
   │
   ▼
dbt run
   │
   ▼
dbt test
   │
   ▼
end
```

---

## Features

- Incremental ELT pipeline
- Snowflake Stored Procedures
- Automatic orchestration
- Data Quality validation
- Incremental dbt models
- Dockerized environment
- Enterprise folder structure

---

## Running

Start containers

```bash
docker compose up -d
```

Run Airflow

```
http://localhost:8080
```

Execute the DAG

```
el_azure_enterprise_pipeline
```

---

## Data Layers

### RAW

Landing layer.

No transformations.

---

### STAGING

Data cleansing.

Deduplication.

Standardization.

---

### MART

Business layer optimized for analytics.

---

## Example Technologies Used

| Layer | Technology |
|---------|------------|
| Orchestration | Airflow |
| Data Warehouse | Snowflake |
| Transformations | dbt |
| Infrastructure | Docker |
| SQL Processing | Snowflake SQL |
| Data Quality | dbt Tests |

---

## Future Improvements

- CDC using Kafka + Debezium
- Azure Data Factory integration
- Azure Data Lake Storage
- CI/CD with GitHub Actions
- Terraform infrastructure
- Monitoring dashboard
- Data Lineage
- Great Expectations
- dbt Documentation
- Unit tests
- SCD Type 2 dimensions

---

## Author

Vitor Melo

Data Engineer
