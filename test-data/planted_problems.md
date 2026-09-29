# Mock data: planted problems (answer key)

Do not publish this file with the repo until the queries are written. It is the answer key
for the CRM hygiene queries.

## contacts.csv (32 rows)

| # | Problem | Rows | What the query should find |
|---|---|---|---|
| 1 | Duplicate email, different case | C1001 vs C2001 | LISA.HARTMANN@... equals lisa.hartmann@... |
| 2 | Same person, second email at same domain | C1001 vs C2002 | same name + same email domain |
| 3 | Same person, company name written differently | C1002 vs C2003 | "Forto" vs "Forto GmbH" |
| 4 | Missing company | C2101, C2102, C2103 | company is empty |
| 5 | Missing name | C2103 | first_name and last_name empty |
| 6 | Missing lead source | C2104, C2105, C2102 | lead_source is empty (attribution gap) |
| 7 | Invalid email | C2106 (max@@test), C2107 (no-email-here), C2108 (empty) | fails a basic email pattern |
| 8 | Never touched since creation | C2109, C2110, C2111 | last_activity is empty, created 70+ days ago |
| 9 | Free email address on a B2B contact | C2101 (gmail), C2102 (web.de) | email domain in free-provider list |

Owner concentration: several neglected contacts belong to Ben Fischer.

## deals.csv (22 rows)

| # | Problem | Rows | What the query should find |
|---|---|---|---|
| 10 | Stale open deals (no activity 30+ days) | D3101-D3106, D3110 | 7 deals, 258,000 EUR total |
| 11 | Owner concentration in stale deals | D3101-D3104, D3110 | 5 of 7 belong to Ben Fischer |
| 12 | Deal with amount 0 | D3107 | forecast is wrong without it |
| 13 | Deal with no owner | D3108 | nobody is responsible |
| 14 | Orphan deal | D3109 (contact_id C9999) | contact_id has no matching contact |
| 15 | Open deal older than 6 months | D3110 | created 195 days ago, still open |

## Expected funnel (stage counts)

New 3 | Demo Booked 7 | Demo Done 4 | Proposal Sent 4 | Closed Won 2 | Closed Lost 2

Closed Won = 2 of 22 deals. Won value 56,000 EUR, lost value 23,000 EUR.

## Numbers the weekly report should produce

- 3 duplicate groups (Lisa x3 counts as one group, Timo x2 as another)
- 3 contacts without a company, 3 with an invalid or missing email
- 3 contacts never touched, all created more than 70 days ago
- 7 stale open deals worth 258,000 EUR, 5 of them one owner's
- 1 deal without an amount, 1 without an owner, 1 orphan
