FROM apache/airflow:2.8.1

USER root

# dependências básicas
RUN apt-get update && apt-get install -y \
    gcc \
    python3-dev \
    curl \
    && apt-get clean

# diretórios
RUN mkdir -p \
    /opt/airflow/logs \
    /opt/airflow/dbt_project \
    /opt/airflow/scripts

# permissões
RUN chown -R airflow:0 /opt/airflow

USER airflow

# Python deps (AIRFLOW + DBT + SNOWFLAKE)
RUN pip install --no-cache-dir \
    dbt-core \
    dbt-snowflake \
    apache-airflow-providers-snowflake \
    apache-airflow-providers-common-sql