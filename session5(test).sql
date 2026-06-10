--Question1 
SELECT 
7 AS month,
COUNT(DISTINCT curr.user_id) AS monthly_active_users
FROM user_actions curr
JOIN user_actions prev
ON curr.user_id = prev.user_id
WHERE 
EXTRACT(MONTH FROM curr.event_date) = 7
AND EXTRACT(YEAR FROM curr.event_date) = 2022
AND EXTRACT(MONTH FROM prev.event_date) = 6
AND EXTRACT(YEAR FROM prev.event_date) = 2022
AND curr.event_type IN ('sign-in', 'like', 'comment')
AND prev.event_type IN ('sign-in', 'like', 'comment');

--Question2
WITH cte AS (
SELECT *,
LAG(transaction_timestamp) OVER (
PARTITION BY merchant_id,
credit_card_id,
amount
ORDER BY transaction_timestamp
) AS prev_time
FROM transactions
)

SELECT COUNT(*) AS payment_count
FROM cte
WHERE transaction_timestamp - prev_time <= INTERVAL '10 minutes';
