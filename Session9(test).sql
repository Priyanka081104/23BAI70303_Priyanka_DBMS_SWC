--Question:Average Review Ratings

SELECT EXTRACT(MONTH FROM submit_date) as mth,product_id, ROUND(AVG(stars), 2)
FROM reviews
GROUP BY mth, product_id 
ORDER BY mth, product_id

--Question:Y-on-Y Growth Rate

with cte as (
SELECT extract(year from transaction_date) as year,product_id,spend as curr_year_spend,
lag(spend) over(partition by product_id order by transaction_date) as prev_year_spend
from user_transactions
)
select *,round(100.0*(curr_year_spend-prev_year_spend)/prev_year_spend,2) as yoy_rate
from cte;


--Question:Median Google Search Frequency

WITH bound AS(
SELECT *,
SUM(num_users) OVER(ORDER BY searches) - num_users as lower_bound,
SUM(num_users) OVER(ORDER BY searches) as upper_bound,
SUM(num_users) OVER()/2 as mid
FROM search_frequency)
SELECT ROUND(sum(searches)*1.0/count(1),1)
FROM bound
WHERE mid BETWEEN lower_bound AND upper_bound;
