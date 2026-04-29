
# Spreadsheet Answers

## Cleaning Steps
- Standardized merchant names, date formats, status values, risk scores, and gateway regions in the `txns` DataFrame.
- Enriched `txns` with `merchant_id` and `default_region` from `merchants`.
- Converted all transaction `raw_amount` to `amount_usd` using exchange rates.
- Created `high_value_flag` and `high_risk_flag` columns.

## Standardization Rules
- **Merchant Names**: Converted to lowercase and stripped whitespace.
- **Date Formats**: Converted to `datetime` objects.
- **Status Values**: Mapped various status strings (e.g., 'succeeded', 'failed e05 timeout') to standardized values ('Captured', 'Failed', 'Chargeback').
- **Risk Scores**: Converted to numeric, with invalid values coerced to `NaN`.
- **Gateway Regions**: Converted to uppercase and stripped whitespace.
- **Currency Conversion**: All transaction amounts converted to USD using provided `exchange_rates`.

## Lookup and Enrichment Logic
- **Merchant Details**: `txns` DataFrame was merged with `merchants` DataFrame on `merchant_name` to add `merchant_id` and `default_region`.
- **Exchange Rates**: `txns` DataFrame was merged with `exchange_rates` on `transaction_date` and `currency` to facilitate conversion of `raw_amount` to `amount_usd`.

## Final Answers

Total raw rows: 30
Total cleaned rows: 30
Invalid or missing rows handled: 0
Top region by GMV: APAC
Number of high value transactions: 10
Number of high risk transactions: 9
Top merchant by captured GMV: alpha mart


## Formula Samples
- **Amount USD**: `amount_usd = raw_amount / exchange_rate` (where `exchange_rate` is `local_currency_per_usd`)
- **High Value Flag**: `txns.loc[(txns['default_region'] == 'APAC') & (txns['amount_usd'] > 5000), 'high_value_flag'] = 1` (similar logic for EU and US with different thresholds)
- **High Risk Flag**: `txns.loc[(txns['risk_score'] >= 70) | (txns['status'] == 'Chargeback'), 'high_risk_flag'] = 1`
- **Reconciliation Health Score**: `(matched_count / total_internal_ledger_count) * 100`
