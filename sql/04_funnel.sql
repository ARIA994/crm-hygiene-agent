-- Deal count, value and average age per pipeline stage, in funnel order.

select stage,
       count(*)    as deals,
       sum(amount) as value,
       round(avg(current_date - created_at::date)) as avg_age_days
from deals
group by stage
order by case stage
  when 'New' then 1 when 'Demo Booked' then 2 when 'Demo Done' then 3
  when 'Proposal Sent' then 4 when 'Closed Won' then 5 else 6 end;
