USE ROLE ACCOUNTADMIN;

CREATE OR REPLACE PROCEDURE CLIENT_DATA_PLATFORM.METADATA.SP_LOAD_INCREMENTAL_ORDERS()
RETURNS STRING
LANGUAGE SQL
EXECUTE AS CALLER
AS
$$
DECLARE
    v_updated NUMBER;
    v_inserted NUMBER;
BEGIN

    -- MERGE
    MERGE INTO CLIENT_DATA_PLATFORM.RAW.ORDERS t
    USING ERP_PROVIDER_DB.SHARE.ORDERS s
    ON t.ORDER_ID = s.ORDER_ID

    WHEN MATCHED AND s.UPDATED_AT > t.UPDATED_AT THEN
        UPDATE SET
            t.CUSTOMER_ID   = s.CUSTOMER_ID,
            t.PRODUCT_CODE  = s.PRODUCT_CODE,
            t.ORDER_DATE    = s.ORDER_DATE,
            t.QUANTITY      = s.QUANTITY,
            t.UNIT_PRICE    = s.UNIT_PRICE,
            t.TOTAL_AMOUNT  = s.TOTAL_AMOUNT,
            t.STATUS        = s.STATUS,
            t.CREATED_AT    = s.CREATED_AT,
            t.UPDATED_AT    = s.UPDATED_AT

    WHEN NOT MATCHED THEN
        INSERT (
            ORDER_ID,
            CUSTOMER_ID,
            PRODUCT_CODE,
            ORDER_DATE,
            QUANTITY,
            UNIT_PRICE,
            TOTAL_AMOUNT,
            STATUS,
            CREATED_AT,
            UPDATED_AT
        )
        VALUES (
            s.ORDER_ID,
            s.CUSTOMER_ID,
            s.PRODUCT_CODE,
            s.ORDER_DATE,
            s.QUANTITY,
            s.UNIT_PRICE,
            s.TOTAL_AMOUNT,
            s.STATUS,
            s.CREATED_AT,
            s.UPDATED_AT
        );

    -- metrics (simple but effective for interview)
    v_updated := SQLROWCOUNT;

    v_inserted := (
        SELECT COUNT(*)
        FROM CLIENT_DATA_PLATFORM.RAW.ORDERS
    );

    RETURN 'INCREMENTAL COMPLETED | MERGE AFFECTED ROWS = '
           || v_updated
           || ' | TOTAL ROWS = '
           || v_inserted;

END;
$$;