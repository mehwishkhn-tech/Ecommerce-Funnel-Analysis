Select * from ecommerce_funnel limit 5;

--Q1. How many users reached each stage of the funnel?
Select sum(home),
sum(search),
sum(payment),
sum(confirmation) from ecommerce_funnel ;
--Q2. What is the overall conversion rate from home page to confirmation?
Select round(sum(confirmation) * 100.0 /sum(home),2) as overall_conversion_rate
from ecommerce_funnel;
--Q3. Which gender has a higher conversion rate?
Select sex,round(sum(confirmation) * 100.0 /sum(home),2) as conversion_rate
from ecommerce_funnel
group by sex;
--Q4. Which device (Desktop or Mobile) performs better in terms of conversion?
Select device,round(sum(confirmation) * 100.0 /sum(home),2) as conversion_rate
from ecommerce_funnel
group by device;
--Q5. Which month had the highest number of confirmations?
Select extract(month from date) as month,sum(confirmation) as number_of_confirmations
from ecommerce_funnel
group by month 
order by number_of_confirmations desc;
--Q6. What is the drop-off rate between each funnel stage?
SELECT 
    ROUND((1 - SUM(search)::NUMERIC / SUM(home)) * 100, 2) AS home_to_search_dropoff,
    ROUND((1 - SUM(payment)::NUMERIC / SUM(search)) * 100, 2) AS search_to_payment_dropoff,
    ROUND((1 - SUM(confirmation)::NUMERIC / SUM(payment)) * 100, 2) AS payment_to_confirmation_dropoff
FROM ecommerce_funnel;
--Q7. How many female mobile users completed a purchase?
Select count(*) from ecommerce_funnel 
where sex='Female'
and device='Mobile'
and confirmation= 1;
--Q8. Which gender had more users reach the search page?
Select sex,sum(search) 
from ecommerce_funnel
group by sex;




