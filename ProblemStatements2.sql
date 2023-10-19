use healthcare;
#1
with cte as(select a.city,count(pharmacyid) as num_pharmacies from pharmacy join address a using(addressid) 
group by a.city),
cte1 as (select b.city,count(prescriptionid) as num_prescriptions from prescription 
join pharmacy using(pharmacyid) join address b using(addressid) group by b.city)
select cte.city,(cte.num_pharmacies/cte1.num_prescriptions) as pharmacy_to_prescription from cte1
join cte on cte.city = cte1.city
where num_prescriptions > 100
order by pharmacy_to_prescription limit 3;


#2
with resources as(select city,diseasename,count(patientid) as maximum from address join person 
using(addressid) join patient on 
person.personid = patient.patientid join treatment using(patientid) join disease using (diseaseid)
where state = 'AL'
group by city,diseasename order by maximum desc)
select * from resources limit 2; # have to use rank

#3
with cte as (select diseaseid,planname,count(planname) as cnt from treatment 
JOIN claim USING(claimid) join insuranceplan using(uin)
group by planname,diseaseid),
cte1 as (select diseaseid, min(cnt) as mini, max(cnt) as maxi from cte group by diseaseid)
select cte.* from cte1 join cte using(diseaseid) where cnt in (cte1.mini,cte1.maxi)
order by diseaseid,cnt desc;

#4
select addressid,diseasename,count(personid) as persons from disease join treatment t using(diseaseid)  
join person p on t.patientid = p.personid join address using(addressid) group by addressid ,diseasename
having persons > 1;

#5
select state,(count(treatmentid)/count(claimid)) as treatment_to_claim_ratio
from address  join person using(addressid) join
treatment on person.personid = treatment.patientid
where date between '2021-04-01' and '2022-03-31' group by state;

