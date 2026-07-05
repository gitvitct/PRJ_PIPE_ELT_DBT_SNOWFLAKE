#!/bin/bash

set -e

echo "=================================================="
echo "🚀 EL AZURE ENTERPRISE PLATFORM BOOTSTRAP"
echo "=================================================="

####################################################
# CREATE .ENV
####################################################

echo ""
echo "=================================================="
echo "Criando arquivo .env"
echo "=================================================="

cat <<EOF > .env

####################################################
# POSTGRES
####################################################
POSTGRES_USER=admin
POSTGRES_PASSWORD=admin
POSTGRES_HOST=postgres
POSTGRES_PORT=5432
POSTGRES_DB=airflow

AIRFLOW_DB=airflow

####################################################
# DBT
####################################################
DBT_TARGET=dev
DBT_THREADS=2

####################################################
# SNOWFLAKE
####################################################
SNOWFLAKE_ACCOUNT=cvumtbb-yxb52563
SNOWFLAKE_USER=dw0snw0dbt
SNOWFLAKE_PASSWORD=Sabote.123.123

SNOWFLAKE_WAREHOUSE=COMPUTE_WH
SNOWFLAKE_DATABASE=CLIENT_DATA_PLATFORM
SNOWFLAKE_SCHEMA=METADATA
SNOWFLAKE_ROLE=TRANSFORMER_ROLE

EOF

echo "✅ .env criado"

####################################################
# PERMISSIONS
####################################################

echo ""
echo "=================================================="
echo "Ajustando permissões"
echo "=================================================="

mkdir -p ../logs

sudo chown -R 50000:0 ../logs || true
sudo chown -R 50000:0 ../dbt_project || true
sudo chmod -R 775 ../logs || true

####################################################
# CLEAN ENVIRONMENT
####################################################

echo ""
echo "=================================================="
echo "Limpando ambiente Docker"
echo "=================================================="

docker compose down -v --remove-orphans || true
docker network prune -f || true

####################################################
# BUILD
####################################################

echo ""
echo "=================================================="
echo "Buildando imagens"
echo "=================================================="

docker compose build

####################################################
# START
####################################################

echo ""
echo "=================================================="
echo "Subindo containers"
echo "=================================================="

docker compose up -d

####################################################
# WAIT POSTGRES
####################################################

echo ""
echo "=================================================="
echo "Aguardando Postgres"
echo "=================================================="

until docker exec docker-postgres-1 pg_isready -U admin >/dev/null 2>&1
do
    echo "⏳ aguardando postgres..."
    sleep 3
done

echo "✅ Postgres OK"

####################################################
# WAIT AIRFLOW
####################################################

echo ""
echo "=================================================="
echo "Aguardando Airflow"
echo "=================================================="

until curl -s http://localhost:8080/health >/dev/null 2>&1
do
    echo "⏳ aguardando airflow..."
    sleep 5
done

echo "✅ Airflow OK"

####################################################
# DB MIGRATION
####################################################

echo ""
echo "=================================================="
echo "Migrando banco Airflow"
echo "=================================================="

docker exec docker-airflow-webserver-1 airflow db migrate

####################################################
# CREATE ADMIN
####################################################

echo ""
echo "=================================================="
echo "Criando usuário Admin"
echo "=================================================="

docker exec docker-airflow-webserver-1 airflow users create \
    --username airflow \
    --firstname Airflow \
    --lastname Admin \
    --role Admin \
    --email admin@email.com \
    --password airflow || true

####################################################
# CREATE SNOWFLAKE CONNECTION
####################################################

echo ""
echo "=================================================="
echo "Criando conexão Snowflake"
echo "=================================================="

docker exec docker-airflow-webserver-1 airflow connections delete snowflake_default || true

docker exec docker-airflow-webserver-1 airflow connections add snowflake_default \
    --conn-type snowflake \
    --conn-login "dw0snw0dbt" \
    --conn-password "Sabote.123.123" \
    --conn-schema "METADATA" \
    --conn-extra '{
        "account": "cvumtbb-yxb52563",
        "warehouse":"COMPUTE_WH",
        "database":"CLIENT_DATA_PLATFORM",
        "role":"TRANSFORMER_ROLE"
    }'

####################################################
# SHOW CONNECTION
####################################################

echo ""
echo "=================================================="
echo "Validando Connection"
echo "=================================================="

docker exec docker-airflow-webserver-1 \
airflow connections get snowflake_default

####################################################
# TEST SNOWFLAKE
####################################################

echo ""
echo "=================================================="
echo "Testando conexão Snowflake"
echo "=================================================="

docker exec docker-airflow-webserver-1 python - <<EOF
import snowflake.connector

conn = snowflake.connector.connect(
    user="dw0snw0dbt",
    password="Sabote.123.123",
    account="cvumtbb-yxb52563",
    warehouse="COMPUTE_WH",
    database="CLIENT_DATA_PLATFORM",
    schema="METADATA",
    role="TRANSFORMER_ROLE"
)

print("")
print("Snowflake Version:")
print(conn.cursor().execute("select current_version()").fetchone())

print("")
print("Current User:")
print(conn.cursor().execute("select current_user()").fetchone())

conn.close()
EOF

echo "✅ Snowflake OK"

####################################################
# DBT CHECK
####################################################

echo ""
echo "=================================================="
echo "Validando dbt"
echo "=================================================="

docker exec docker-airflow-webserver-1 dbt --version

####################################################
# DOCKER STATUS
####################################################

echo ""
echo "=================================================="
echo "Containers"
echo "=================================================="

docker ps

####################################################
# FINISH
####################################################

echo ""
echo "=================================================="
echo "🎉 BOOTSTRAP CONCLUÍDO"
echo "=================================================="

echo ""
echo "Airflow UI"
echo "--------------------------------------"
echo "http://localhost:8080"
echo ""
echo "Usuário : airflow"
echo "Senha   : airflow"
echo ""
echo "Snowflake Connection"
echo "--------------------------------------"
echo "snowflake_default"
echo ""
echo "Projeto pronto para executar a DAG."