-- Tables used by the CRM Hygiene Agent.
-- contacts and deals mirror the CRM objects; weekly_snapshots stores one row per week
-- so the report and dashboard can show week-over-week change.

create table contacts (
  hubspot_id      text primary key,
  email           text,
  email_domain    text,
  first_name      text,
  last_name       text,
  company         text,
  job_title       text,
  phone           text,
  lead_source     text,
  lifecycle_stage text,
  owner           text,
  created_at      timestamptz,
  last_activity   timestamptz,
  synced_at       timestamptz default now()
);

create table deals (
  hubspot_id    text primary key,
  name          text,
  amount        numeric,
  stage         text,
  owner         text,
  contact_id    text,
  created_at    timestamptz,
  closed_at     timestamptz,
  last_activity timestamptz,
  synced_at     timestamptz default now()
);

create table weekly_snapshots (
  week_of        date primary key,
  duplicates     int,
  no_company     int,
  no_source      int,
  never_touched  int,
  invalid_email  int,
  stale_deals    int,
  stale_value    numeric,
  open_deals     int,
  won_deals      int,
  win_rate_pct   numeric,
  created_at     timestamptz default now()
);

-- email_domain is derived once after loading contacts; the duplicate query depends on it.
update contacts set email_domain = lower(split_part(email, '@', 2)) where email like '%@%';
