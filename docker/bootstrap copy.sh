#!/bin/bash

set -e

echo "========================================="
echo "🚀 EL AZURE POC BOOTSTRAP"
echo "========================================="

echo ""
echo "========================================="
echo "Criando .env"
echo "========================================="

cat <<EOF > .env

# =========================================================
# POSTGRES
# =========================================================
POSTGRES_USER=admin
POSTGRES_PASSWORD=admin
POSTGRES_HOST=postgres
POSTGRES_PORT=5432
POSTGRES_DB=airflow

AIRFLOW_DB=airflow

# =========================================================
# DBT
# =========================================================
DBT_TARGET=dev
DBT_THREADS=2

# =========================================================
# SNOWFLAKE
# =========================================================
SNOWFLAKE_ACCOUNT=<SEU_ACCOUNT>
SNOWFLAKE_USER=<SEU_USER>
SNOWFLAKE_PASSWORD=<SUA_SENHA>

SNOWFLAKE_WAREHOUSE=COMPUTE_WH
SNOWFLAKE_DATABASE=CLIENT_DATA_PLATFORM
SNOWFLAKE_SCHEMA=METADATA
SNOWFLAKE_ROLE=TRANSFORMER_ROLE

# =========================================================
# AIRFLOW CONNECTIONS
# =========================================================
AIRFLOW_CONN_SNOWFLAKE_DEFAULT=snowflake://dw0snw0dbt:Sabote.123.123@cvumtbb-yxb52563/?warehouse=COMPUTE_WH&database=CLIENT_DATA_PLATFORM&schema=METADATA&role=TRANSFORMER_ROLE

EOF

echo ".env criado com sucesso"

echo ""
echo "========================================="
echo "Limpando ambiente Docker"
echo "========================================="

docker compose down -v --remove-orphans || true
docker network prune -f || true

echo ""
echo "========================================="
echo "Subindo containers"
echo "========================================="

docker compose up -d --build

echo ""
echo "========================================="
echo "Aguardando Postgres"
echo "========================================="

until docker exec docker-postgres-1 pg_isready -U admin >/dev/null 2>&1
do
    echo "Aguardando Postgres..."
    sleep 3
done

echo "Postgres OK"

echo ""
echo "========================================="
echo "Aguardando Airflow"
echo "========================================="

until curl -s http://localhost:8080/health >/dev/null 2>&1
do
    echo "Aguardando Airflow..."
    sleep 5
done

echo "Airflow OK"

echo ""
echo "========================================="
echo "Garantindo migração do banco"
echo "========================================="

docker exec docker-airflow-webserver-1 airflow db migrate

echo ""
echo "========================================="
echo "Criando usuário Admin"
echo "========================================="

docker exec docker-airflow-webserver-1 airflow users create \
    --username airflow \
    --firstname Airflow \
    --lastname Admin \
    --role Admin \
    --email admin@email.com \
    --password airflow || true

echo ""
echo "========================================="
echo "Verificando Connection Snowflake"
echo "========================================="

docker exec docker-airflow-webserver-1 airflow connections get snowflake_default

echo ""
echo "========================================="
echo "BOOTSTRAP FINALIZADO"
echo "========================================="

echo ""
echo "Airflow:"
echo "http://localhost:8080"
echo ""
echo "Usuário : airflow"
echo "Senha   : airflow"
echo ""
echo "Snowflake Connection:"
echo "snowflake_default"