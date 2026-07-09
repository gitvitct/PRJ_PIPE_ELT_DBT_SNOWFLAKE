CREATE OR REPLACE PROCEDURE CLIENT_DATA_PLATFORM.METADATA.SP_GENERATE_TASKS()
RETURNS STRING
LANGUAGE SQL
EXECUTE AS OWNER
AS
$$
DECLARE

    v_sql STRING;

    c1 CURSOR FOR
        SELECT *
        FROM CLIENT_DATA_PLATFORM.METADATA.TABLE_CONFIG
        WHERE ACTIVE = TRUE
        ORDER BY LOAD_ORDER;

BEGIN

    FOR rec IN c1 DO

        v_sql :=
        'CREATE OR REPLACE TASK CLIENT_DATA_PLATFORM.METADATA.TASK_' || rec.TARGET_TABLE || '
        WAREHOUSE = COMPUTE_WH
        SCHEDULE = ''USING CRON 0 */8 * * * UTC''
        AS

        MERGE INTO ' ||

        rec.TARGET_DATABASE || '.' ||
        rec.TARGET_SCHEMA || '.' ||
        rec.TARGET_TABLE ||

        ' T

        USING ' ||

        rec.SOURCE_DATABASE || '.' ||
        rec.SOURCE_SCHEMA || '.' ||
        rec.SOURCE_TABLE ||

        ' S

        ON T.' || rec.PRIMARY_KEY ||
        ' = S.' || rec.PRIMARY_KEY ||

        '

        WHEN MATCHED
        AND S.' || rec.INCREMENTAL_COLUMN ||
        ' > T.' || rec.INCREMENTAL_COLUMN ||

        '

        THEN UPDATE ALL BY NAME

        WHEN NOT MATCHED

        THEN INSERT ALL BY NAME';

        EXECUTE IMMEDIATE v_sql;

    END FOR;

    RETURN 'Tasks generated';

END;
$$;
