from datetime import datetime, timedelta

from airflow import DAG
from airflow.operators.empty import EmptyOperator
from airflow.operators.bash import BashOperator
from airflow.providers.common.sql.operators.sql import SQLExecuteQueryOperator
#from airflow.providers.snowflake.operators.snowflake import SnowflakeOperator

default_args = {
    "owner": "data-platform",
    "retries": 2,
    "retry_delay": timedelta(minutes=5),
}

with DAG(
    dag_id="el_azure_enterprise_pipeline",
    default_args=default_args,
    start_date=datetime(2026, 7, 1),
    catchup=False,
    schedule="@daily",
    tags=["snowflake", "dbt", "enterprise"],
) as dag:

    start = EmptyOperator(task_id="start")

    initial_load = SQLExecuteQueryOperator(
        task_id="snowflake_initial_load",
        conn_id="snowflake_default",
        sql="CALL CLIENT_DATA_PLATFORM.METADATA.SP_LOAD_INITIAL_ORDERS();",
        autocommit=True,
        
    )

    incremental_load = SQLExecuteQueryOperator(
        task_id="snowflake_incremental_load",
        conn_id="snowflake_default",
        sql="CALL CLIENT_DATA_PLATFORM.METADATA.SP_LOAD_INCREMENTAL_ORDERS();",
        autocommit=True,
        
    )

    dbt_run = BashOperator(
        task_id="dbt_run",
        bash_command="""
        set -euo pipefail
        cd /opt/airflow/dbt_project
        dbt deps --profiles-dir .
        dbt run --profiles-dir .
        """,
    )

    dbt_test = BashOperator(
        task_id="dbt_test",
        bash_command="""
        set -euo pipefail
        cd /opt/airflow/dbt_project
        dbt test --profiles-dir .
        """,
    )

    end = EmptyOperator(task_id="end")

    start >> initial_load >> incremental_load >> dbt_run >> dbt_test >> end