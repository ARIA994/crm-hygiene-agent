-- Writes this week numbers into weekly_snapshots. Contains n8n expressions, not plain SQL.

insert into weekly_snapshots
  (week_of, duplicates, no_company, no_source, never_touched, invalid_email,
   stale_deals, stale_value, open_deals, won_deals, win_rate_pct)
values
  ('{{ $json.week_of }}',
   {{ $json.duplicates.groups }},
   {{ $json.incomplete.detail.find(r => r.problem === 'No company')?.records || 0 }},
   {{ $json.incomplete.detail.find(r => r.problem === 'No lead source')?.records || 0 }},
   {{ $json.incomplete.detail.find(r => r.problem === 'Never touched')?.records || 0 }},
   {{ $json.incomplete.detail.find(r => r.problem === 'Invalid or missing email')?.records || 0 }},
   {{ $json.stale.count }},
   {{ $json.stale.value }},
   {{ $json.funnel.open_deals }},
   {{ $json.funnel.won }},
   {{ $json.funnel.win_rate_pct }})
on conflict (week_of) do update set
  duplicates    = excluded.duplicates,
  no_company    = excluded.no_company,
  no_source     = excluded.no_source,
  never_touched = excluded.never_touched,
  invalid_email = excluded.invalid_email,
  stale_deals   = excluded.stale_deals,
  stale_value   = excluded.stale_value,
  open_deals    = excluded.open_deals,
  won_deals     = excluded.won_deals,
  win_rate_pct  = excluded.win_rate_pct;
