-- 1. DATA VALIDATION

select 
	count(patient_id) as total_patients, 
	count(full_name) as total_names,
	count(acquisition_date) as total_acq_date,
	min(acquisition_date) as min_acq_date,
	max(acquisition_date) as max_acq_date,
	count(acquisition_channel) as total_acq_channel,
	count(age_band) as total_age_bands,
	min(age_band) as min_age,
	max(age_band) as max_age
from patients;

select
	count(month) as total_month_date,
	min(month) as min_month,
	max(month) as max_month,
	count(channel) as total_channel,
	count(spend_eur) as total_spend_rows,
	min(spend_eur) as min_spend,
	max(spend_eur) as max_spend
from acquisition_costs;

select
	count(patient_id) as total_patient,
	count(service_id) as total_service_id,
	count(therapist_id) as total_therapist,
	count(appointment_date) as total_date,
	min(appointment_date) as min_date,
	max(appointment_date) as max_date,
	count(status) as total_status,
	count(session_number) as total_session,
	min(session_number) as min_session,
	max(session_number) as max_session
from appointments;

-- 2. DATA CLEANING

delete from acquisition_costs 
where spend_eur is null;

select channel,
count(channel)
from acquisition_costs
group by channel;

update acquisition_costs
set channel = case
	when lower(trim(channel)) = 'referral - patient' then 'Referral - Patient'
	when lower(trim(channel)) = 'paid social' then 'Paid Social'
	when lower(trim(channel)) = 'organic search' then 'Organic Search'
	when lower(trim(channel)) = 'corporate partnership' then 'Corporate Partnership'
	when lower(trim(channel)) = 'gp referral' then 'GP Referral'
end;

update patients
set acquisition_channel = case
	when lower(trim(acquisition_channel)) = 'referral - patient' then 'Referral - Patient'
	when lower(trim(acquisition_channel)) = 'paid social' then 'Paid Social'
	when lower(trim(acquisition_channel)) = 'organic search' then 'Organic Search'
	when lower(trim(acquisition_channel)) = 'corporate partnership' then 'Corporate Partnership'
	when lower(trim(acquisition_channel)) = 'gp referral' then 'GP Referral'
end;

delete from appointments 
where session_number <= 0;

select status,
count(status)
from appointments
group by status;

update appointments
set status = case
	when lower(trim(status)) = 'cancelled' then 'Cancelled'
	when lower(trim(status)) = 'no-show' then 'No-Show'
	when lower(trim(status)) = 'attended' then 'Attended'
end;

select specialisation,
count(specialisation)
from therapists
group by specialisation;

update therapists
set specialisation = case
	when lower(trim(specialisation)) = 'trauma' then 'Trauma'
	when lower(trim(specialisation)) = 'cbt' then 'CBT'
	when lower(trim(specialisation)) = 'couples therapy' then 'Couples Therapy'
	when lower(trim(specialisation)) = 'adolescent & family' then 'Adolescent & Family'
end;

-- 3. ANALYSIS

select 
	extract(year from month::date) as year,
	channel,
	sum(spend_eur) as total_spent
from acquisition_costs
group by year, channel;

with patient_appointments as (
    select
        p.patient_id,
        p.acquisition_channel,
        a.appointment_id,
        a.status,
        a.session_number,
        pay.amount_paid
    from patients p
    join appointments a on p.patient_id = a.patient_id
    left join payments pay on a.appointment_id = pay.appointment_id
    where a.status = 'Attended'        
),
ltv as (
    select
        acquisition_channel,
        count(distinct patient_id) as total_patients,
        sum(amount_paid) as total_amount_paid,
        round(sum(amount_paid)::numeric / nullif(count(distinct patient_id), 0), 2) as ltv
    from patient_appointments
    group by acquisition_channel
),
cac as (
    select
        channel,
        sum(spend_eur) as total_spend   
    from acquisition_costs
    group by channel
)
select
    l.acquisition_channel,
    l.total_patients,
    l.total_amount_paid,
    l.ltv,
    c.total_spend,
    round(c.total_spend::numeric / nullif(l.total_patients, 0), 2) as cac, 
    round(l.ltv / (c.total_spend::numeric /l.total_patients), 2) as ltv_cac_ratio
from ltv l
join cac c on l.acquisition_channel = c.channel
order by ltv_cac_ratio desc;

with dropout as (
    select 
        session_number,
        count(distinct patient_id) as patients
    from appointments
    where status = 'Attended'
    group by session_number
)
select
    session_number,
    patients,
    round(patients::numeric / 403 * 100, 1) as pct_of_session_1
from dropout
order by session_number;

select
    p.acquisition_channel,
    count(distinct a.patient_id) as total_patients,
    round(count(a.appointment_id)::numeric / count(distinct a.patient_id), 1) as avg_sessions
from appointments a
join patients p on a.patient_id = p.patient_id
where a.status = 'Attended'
group by p.acquisition_channel
order by avg_sessions desc;




