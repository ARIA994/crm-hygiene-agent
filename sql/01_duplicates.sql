-- Contacts that look like the same person: same name, same email domain, more than one record.

select lower(first_name) as first_name,
       lower(last_name)  as last_name,
       email_domain,
       count(*)                     as records,
       string_agg(hubspot_id, ', ') as ids,
       string_agg(email, ', ')      as emails,
       string_agg(distinct owner, ', ') as owners
from contacts
where first_name <> '' and last_name <> '' and email_domain is not null
group by lower(first_name), lower(last_name), email_domain
having count(*) > 1
order by count(*) desc;
