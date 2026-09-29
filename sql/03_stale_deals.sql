-- Open deals with no activity for 30+ days, grouped by owner, with value at risk.

select owner,
       count(*)                                as stale_deals,
       sum(amount)                             as value_at_risk,
       max(current_date - last_activity::date) as longest_silence_days
from deals
where closed_at is null
  and last_activity < current_date - interval '30 days'
group by owner
order by value_at_risk desc;
