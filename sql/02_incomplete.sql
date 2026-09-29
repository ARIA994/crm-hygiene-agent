-- One count per data-quality problem. Feeds the weekly report and the snapshot table.

select 'No company' as problem, count(*) as records
from contacts where company is null or company = ''
union all
select 'No lead source', count(*)
from contacts where lead_source is null or lead_source = ''
union all
select 'Invalid or missing email', count(*)
from contacts where email is null or email = '' or email not like '%_@_%._%'
union all
select 'Never touched', count(*)
from contacts where last_activity is null
order by records desc;
