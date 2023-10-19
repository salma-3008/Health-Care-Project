use healthcare;
#1
select pharmacyid,pharmacyname,sum(quantity) as total_medicine,
sum(case when hospitalExclusive = 'S' then 1 else 0 end) as total_hospitalexclusive,
sum(case when hospitalExclusive = 'S' then 1 else 0 end) / sum(quantity) * 100
as hospital_exclusive_medicine_to_total_medicine 
from pharmacy join prescription using(pharmacyid) join treatment using(treatmentid) 
join contain using(prescriptionid) join medicine using(medicineid)
where year(date) = '2022'
group by pharmacyid,pharmacyname
order by hospital_exclusive_medicine_to_total_medicine desc;

#2
select state,
(sum(case when claimid is null then 1 else 0 end) / 
sum(case when claimid is not null then 1 else 0 end))*100
as percentage
from address join person p using(addressid) 
join treatment t on p.personID = t.patientID
left join claim using (claimid)
group by state
order by percentage desc;

#3
select count(distinct a.state) from address a;
select state,count(cnt) from (
select a.state , rank() over (partition by d.diseaseid order by count(t.treatmentid) desc ) as  cnt from address a
 join person p using (addressid) join 
 patient pat on pat.patientid=p.personid join treatment t using (patientid) join
 disease d using (diseaseid) group by a.state,d.diseaseid) as derived  where cnt =1 group by state;
with dcounts as (
select a.state , d.diseaseName, count(t.treatmentid) as  cnt from address a
 join person p using (addressid) join 
 patient pat on pat.patientid=p.personid join treatment t using (patientid) join
 disease d using (diseaseid) where year(t.date)=2022 group by a.state,d.diseaseid order by cnt
)
select state, max(cnt) as max_disease,min(cnt) as min_disease from dcounts group by state;

#4
with cte as(select city, count(personID) as registerd_people from address 
join person using(addressid)
group by city
having registerd_people > 10),
cte1 as(select city,count(patientid) as num_patients from patient p1 join person p 
on p.personid = p1.patientID join address using(addressid) group by city )
select cte.*, cte1.num_patients, (cte1.num_patients / cte.registerd_people) as ratio 
from cte join cte1 using(city);

#5
select companyName,num_medicines,r from(
select companyName,count(medicineid) as num_medicines,
dense_rank() over(partition by substanceName order by count(medicineid) desc) as r
from medicine where substancename = 'ranitidina'
group by companyName ) as p
where r<= 3;











