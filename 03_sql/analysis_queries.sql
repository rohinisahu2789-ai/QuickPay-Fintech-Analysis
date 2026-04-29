

-- Business Question: Count transactions by status
SELECT
  status,
  COUNT(*) AS transaction_count
FROM txns
GROUP BY status
ORDER BY transaction_count DESC;

-- Business Question: Calculate total captured GMV by merchant
SELECT
  merchant_name,
  SUM(amount_usd) AS total_captured_gmv
FROM txns
WHERE status = 'Captured'
GROUP BY merchant_name
ORDER BY total_captured_gmv DESC;

-- Business Question: Show top 10 merchants by captured GMV
SELECT
  merchant_name,
  SUM(amount_usd) AS total_captured_gmv
FROM txns
WHERE status = 'Captured'
GROUP BY merchant_name
ORDER BY total_captured_gmv DESC
LIMIT 10;

-- Business Question: Show daily GMV and successful transaction count
SELECT
  transaction_date,
  SUM(amount_usd) AS daily_gmv,
  COUNT(*) AS successful_transactions_count
FROM txns
WHERE status = 'Captured'
GROUP BY transaction_date
ORDER BY transaction_date;

-- Business Question: Find merchants with chargeback ratio above 1%
WITH MerchantTransactions AS (
  SELECT
    merchant_name,
    COUNT(*) AS total_transactions,
    SUM(CASE WHEN status = 'Chargeback' THEN 1 ELSE 0 END) AS chargeback_transactions
  FROM txns
  GROUP BY merchant_name
)
SELECT
  merchant_name,
  (CAST(chargeback_transactions AS REAL) * 100 / total_transactions) AS chargeback_ratio
FROM MerchantTransactions
WHERE (CAST(chargeback_transactions AS REAL) * 100 / total_transactions) > 1;

-- Business Question: Find regions with average risk score above 50 and more than 20 transactions
SELECT
  gateway_region,
  AVG(risk_score) AS average_risk_score,
  COUNT(*) AS total_transactions
FROM txns
GROUP BY gateway_region
HAVING AVG(risk_score) > 50 AND COUNT(*) > 20;

-- Business Question: Find users with 3 or more failed or chargeback transactions on the same day
SELECT
  user_id,
  transaction_date,
  COUNT(*) AS problematic_transactions_count
FROM txns
WHERE status IN ('Failed', 'Chargeback')
GROUP BY user_id, transaction_date
HAVING COUNT(*) >= 3;

-- Business Question: Show chargeback count, unique affected users, and chargeback amount by merchant
SELECT
  merchant_name,
  COUNT(*) AS chargeback_count,
  COUNT(DISTINCT user_id) AS unique_affected_users,
  SUM(amount_usd) AS total_chargeback_amount
FROM txns
WHERE status = 'Chargeback'
GROUP BY merchant_name
ORDER BY total_chargeback_amount DESC;
