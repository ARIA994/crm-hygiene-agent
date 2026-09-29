-- Deals with no owner, no amount, a missing contact, or open longer than 6 months.

select hubspot_id, name, stage,
       coalesce(nullif(owner, ''), '(no owner)') as owner,
       concat_ws(', ',
         case when owner is null or owner = ''  then 'no owner'  end,
         case when amount is null or amount = 0 then 'no amount' end,
         case when contact_id not in (select hubspot_id from contacts) then 'orphan' end,
         case when closed_at is null and created_at < current_date - interval '180 days'
              then 'open 6+ months' end
       ) as problems
from deals
where owner = '' or owner is null or amount = 0 or amount is null
   or contact_id not in (select hubspot_id from contacts)
   or (closed_at is null and created_at < current_date - interval '180 days');
