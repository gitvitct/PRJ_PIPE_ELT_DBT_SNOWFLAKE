from airflow import DAG
from airflow.operators.bash import BashOperator

from datetime import datetime, timedelta

default_args = {
    "owner": "data-platform",
    "retries": 2,
    "retry_delay": timedelta(minutes=2),
}

with DAG(
    dag_id="el_azure_enterprise_pipeline_snowsql",
    default_args=default_args,
    start_date=datetime(2024, 1, 1),
    schedule_interval="@daily",
    catchup=False,
    description="Enterprise EL pipeline Snowflake + dbt",
    tags=["snowflake", "dbt", "elt"],
) as dag:

    # =========================
    # 1. INITIAL LOAD (Snowflake)
    # =========================
    initial_load = BashOperator(
        task_id="snowflake_initial_load",
        bash_command="""
        snowsql -q "CALL CLIENT_DATA_PLATFORM.METADATA.SP_LOAD_INITIAL_ORDERS();"
        """,
    )

    # =========================
    # 2. INCREMENTAL LOAD
    # =========================
    incremental_load = BashOperator(
        task_id="snowflake_incremental_load",
        bash_command="""
        snowsql -q "CALL CLIENT_DATA_PLATFORM.METADATA.SP_LOAD_INCREMENTAL_ORDERS();"
        """,
    )

    # =========================
    # 3. DBT BUILD
    # =========================
    dbt_run = BashOperator(
        task_id="dbt_run",
        bash_command="""
        cd /opt/airflow/dbt_project &&
        dbt run
        """,
    )

    # =========================
    # 4. DBT TEST
    # =========================
    dbt_test = BashOperator(
        task_id="dbt_test",
        bash_command="""
        cd /opt/airflow/dbt_project &&
        dbt test
        """,
    )

    # =========================
    # DEPENDENCIES
    # =========================

    initial_load >> incremental_load >> dbt_run >> dbt_test