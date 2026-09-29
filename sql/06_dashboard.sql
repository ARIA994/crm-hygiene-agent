-- Everything the dashboard needs in one row. json_agg packs each result set into a single JSON value.

select
  (select count(*) from contacts) as total_contacts,
  (select count(*) from deals)    as total_deals,

  (select count(*) from deals
     where closed_at is null
       and last_activity < current_date - interval '30 days') as stale_deals,

  (select coalesce(sum(amount), 0) from deals
     where closed_at is null
       and last_activity < current_date - interval '30 days') as stale_value,

  (select count(*) from contacts
     where company is null or company = ''
        or lead_source is null or lead_source = ''
        or email is null or email = '' or email not like '%_@_%._%'
        or last_activity is null) as incomplete_contacts,

  (select count(*) from (
      select 1 from contacts
      where first_name <> '' and last_name <> '' and email_domain is not null
      group by lower(first_name), lower(last_name), email_domain
      having count(*) > 1) d) as duplicate_groups,

  (select json_agg(f) from (
      select stage, count(*) as deals, coalesce(sum(amount), 0) as value
      from deals group by stage
      order by case stage
        when 'New' then 1 when 'Demo Booked' then 2 when 'Demo Done' then 3
        when 'Proposal Sent' then 4 when 'Closed Won' then 5 else 6 end) f) as funnel,

  (select json_agg(o) from (
      select owner, count(*) as stale_deals, coalesce(sum(amount), 0) as value_at_risk
      from deals
      where closed_at is null and last_activity < current_date - interval '30 days'
      group by owner order by 3 desc) o) as stale_by_owner,

  (select json_agg(s) from (
      select week_of, stale_deals, stale_value, duplicates, open_deals
      from weekly_snapshots order by week_of desc limit 6) s) as history;
