CREATE INDEX idx_trx_merchant_date
ON`development`.`merchant`.`merchant_trx`(date_transaction,transaction_date DESC);


SELECT 
    merchant_id,
    SUM(amount) AS total_amount,
    SUM(CASE WHEN transaction_type = "debit" THEN amount ELSE 0 END) AS total_debit,
    SUM(CASE WHEN transaction_type = "credit" THEN amount ELSE 0 END) AS total_credit
FROM merchant_trx
GROUP BY merchant_id;


INSERT INTO `merchant_summary_bucket` (KEY, VALUE)
SELECT 
    merchant_id,
    SUM(amount) AS total_amount,
    SUM(CASE WHEN transaction_type = "debit" THEN amount ELSE 0 END) AS total_debit,
    SUM(CASE WHEN transaction_type = "credit" THEN amount ELSE 0 END) AS total_credit
FROM merchant_trx
GROUP BY merchant_id;

CREATE INDEX idx_merchant_transaction ON `your_bucket_name`(merchant_id, transaction_type);



-- query Daily
SELECT 
    merchant_id,
    MILLIS_TO_STR(STR_TO_MILLIS(date_transaction), "1111-11-11") AS transaction_date,
    SUM(amount) AS total_amount,
    SUM(CASE WHEN transaction_type = "debit" THEN amount ELSE 0 END) AS total_debit,
    SUM(CASE WHEN transaction_type = "credit" THEN amount ELSE 0 END) AS total_credit,
     "daily" as summary_type
FROM `merchant_trx`
WHERE MILLIS_TO_STR(STR_TO_MILLIS(date_transaction), "1111-11-11") = "2024-10-09"
GROUP BY merchant_id, MILLIS_TO_STR(STR_TO_MILLIS(date_transaction), "1111-11-11")
ORDER BY transaction_date, merchant_id;

-- index daily
CREATE INDEX idx_merchant_trx_transaction_date ON `merchant_trx`(
    date_transaction, 
    merchant_id, 
    transaction_type, 
    amount
) WHERE date_transaction IS NOT NULL;

-- insert result from merchant_daily
INSERT INTO airport (KEY UUID(), VALUE _airport)
    SELECT _airport FROM airport _airport
    WHERE airportname = "Heathrow"
RETURNING *;
insert into merchant_summary (KEY trx.doc_id, VALUE trx)
SELECT trx FROM 
(SELECT 
    CONCAT(merchant_id, "_", 
           MILLIS_TO_STR(STR_TO_MILLIS(date_transaction), "1111-11-11"), "_daily") AS doc_id,
    merchant_id,
    MILLIS_TO_STR(STR_TO_MILLIS(date_transaction), "1111-11-11") AS transaction_date,
    SUM(amount) AS total_amount,
    SUM(CASE WHEN transaction_type = "debit" THEN amount ELSE 0 END) AS total_debit,
    SUM(CASE WHEN transaction_type = "credit" THEN amount ELSE 0 END) AS total_credit,
     "daily" as summary_type
FROM `merchant_trx`
WHERE MILLIS_TO_STR(STR_TO_MILLIS(date_transaction), "1111-11-11") = "2024-10-09" 
GROUP BY merchant_id, MILLIS_TO_STR(STR_TO_MILLIS(date_transaction), "1111-11-11")
ORDER BY transaction_date, merchant_id) trx ;



-- Monthly Query
SELECT 
    merchant_id,
    transaction_date,
    SUM(amount) AS total_amount,
    SUM(CASE WHEN transaction_type = "debit" THEN amount ELSE 0 END) AS total_debit,
    SUM(CASE WHEN transaction_type = "credit" THEN amount ELSE 0 END) AS total_credit,
    "monthly" AS summary_type
FROM (
    SELECT 
        merchant_id,
        MILLIS_TO_STR(
            DATE_ADD_MILLIS(
                STR_TO_MILLIS(DATE_TRUNC_STR(date_transaction, 'month')), 
                1, 'month'
            ) - 86400000,  -- Subtract one day to get the last day of the month
            "1111-11-11"  -- Output in "YYYY-MM-DD" format
        ) AS transaction_date,
        amount,
        transaction_type
    FROM `merchant_trx`
) AS subquery
WHERE transaction_date = "2024-10-31"  -- Filter for October 2024
GROUP BY merchant_id, transaction_date
ORDER BY transaction_date, merchant_id;

--index monthly
CREATE INDEX idx_merchant_trx_monthly_summary ON `merchant_trx`(
    merchant_id,
    transaction_type,
    amount,
    date_transaction
) WHERE date_transaction IS NOT NULL;


-- insert monthly
insert into merchant_summary (KEY trx.doc_id, VALUE trx)
SELECT trx FROM 
(SELECT 
    CONCAT(merchant_id, "_", 
           MILLIS_TO_STR(STR_TO_MILLIS(transaction_date), "1111-11-11"), "_monthly") AS doc_id,
    merchant_id,
    transaction_date,
    SUM(amount) AS total_amount,
    SUM(CASE WHEN transaction_type = "debit" THEN amount ELSE 0 END) AS total_debit,
    SUM(CASE WHEN transaction_type = "credit" THEN amount ELSE 0 END) AS total_credit,
    "monthly" AS summary_type
FROM (
    SELECT 
        merchant_id,
        MILLIS_TO_STR(
            DATE_ADD_MILLIS(
                STR_TO_MILLIS(DATE_TRUNC_STR(date_transaction, 'month')), 
                1, 'month'
            ) - 86400000,  -- Subtract one day to get the last day of the month
            "1111-11-11"  -- Output in "YYYY-MM-DD" format
        ) AS transaction_date,
        amount,
        transaction_type
    FROM `merchant_trx`
) AS subquery
WHERE transaction_date = "2024-10-31"  -- Filter for October 2024
GROUP BY merchant_id, transaction_date
ORDER BY transaction_date, merchant_id ) trx;


CREATE EXTERNAL TABLE  result_customer_segmentation (
cust_id  string,
name  string,
email  string,
phone_numb  string,
account_number  string,
bank_id  string,
ktp  string,
dob  string,
city  string,
address  string,
postal_code  string,
total_transaction  decimal(38,18),
income  decimal(38,18),
`cluster` bigint)
stored as parquet



CREATE INDEX idx_merchant_transaction ON development.merchant.merchant_trx (merchant_id, transaction_type);


SELECT * FROM development.merchant.merchant_trx
WHERE merchant_id = "merchant_2"
LIMIT 5 OFFSET 10;
CREATE INDEX idx_merchant_id ON development.merchant.merchant_trx    (merchant_id);

SELECT * FROM development.merchant.merchant_trx
WHERE merchant_id = "merchant_2"
AND transaction_type = "debit"
LIMIT 5 OFFSET 10;
CREATE INDEX idx_merchant_id_type ON development.merchant.merchant_trx    (merchant_id,transaction_type);

SELECT * FROM development.merchant.merchant_trx
WHERE merchant_id = "merchant_2"
AND transaction_type = "debit"
AND MILLIS_TO_STR(STR_TO_MILLIS(date_transaction), "1111-11-11") = "2024-10-25"
LIMIT 5 OFFSET 10

SELECT * FROM development.merchant.merchant_trx
WHERE merchant_id = "merchant_2"
AND MILLIS_TO_STR(STR_TO_MILLIS(date_transaction), "1111-11-11") = "2024-10-25"
LIMIT 5 OFFSET 10