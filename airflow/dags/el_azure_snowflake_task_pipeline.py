from airflow import DAG
from airflow.providers.common.sql.operators.sql import SQLExecuteQueryOperator
from airflow.operators.bash import BashOperator

from datetime import datetime

default_args = {
    "owner": "data-platform"
}

with DAG(

    dag_id="el_azure_snowflake_task_pipeline",

    start_date=datetime(2026,1,1),

    catchup=False,

    schedule=None,

    default_args=default_args,

    tags=["snowflake","tasks","dbt"]

) as dag:

    execute_task = SQLExecuteQueryOperator(

        task_id="execute_snowflake_task",

        conn_id="snowflake_default",

        sql="""
        EXECUTE TASK CLIENT_DATA_PLATFORM.METADATA.TASK_INCREMENTAL_ORDERS;
        """

    )

    dbt_run = BashOperator(

        task_id="dbt_run",

        bash_command="""
        set -e

        cd /opt/airflow/dbt_project

        dbt run --profiles-dir .
        """

    )

    dbt_test = BashOperator(

        task_id="dbt_test",

        bash_command="""
        set -e

        cd /opt/airflow/dbt_project

        dbt test --profiles-dir .
        """

    )

    execute_task >> dbt_run >> dbt_test