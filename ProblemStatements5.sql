use healthcare;
#1
select personname,count(treatmentID) as num_treatments,
FLOOR(DATEDIFF(CURRENT_DATE, dob) / 365) AS age
from person p join treatment t on
p.personid = t.patientID join patient using(patientid) group by personname,dob 
having num_treatments > 1
order by age desc;

#2
select diseaseid,
sum(case when gender = 'male' then 1 else 0 end) as sum_male,
sum(case when gender = 'female' then 1 else 0 end ) as sum_female,
sum(case when gender = 'male' then 1 else 0 end)/sum(case when gender = 'female' then 1 else 0 end )
as male_to_female_Ratio
from disease join treatment t using(diseaseid) join patient using(patientid) 
join person on person.personid = patient.patientID 
where year(t.date) = '2021'
group by diseaseid;
#3
-- Kelly, from the Fortis Hospital management, has requested a report that shows for each disease, the top 3 cities that had the most
-- number treatment for that disease.
with cte as(select diseaseid,city,count(treatmentID) as num_treatments,
dense_rank() over(partition by diseaseid order by count(treatmentID) DESC) AS r
from treatment t
join person p on p.personID = t.patientID join address using(addressid) 
group by diseaseid,city)
select * from cte where r in (1,2,3) order by r desc; 

#4
select diseaseid,pharmacyid,
sum(case when year(t.date) = '2021' then 1 else 0 end) as in_2021,
sum(case when year(t.date) = '2022' then 1 else 0 end) as in_2022
from prescription join treatment t using(treatmentid) 
where year(t.date) between '2021' and '2022' 
group by pharmacyid,diseaseid;

#5
select companyName,state,count(claimid) as num_claims from address join insurancecompany 
using(addressid) join person p using(addressid) join patient t on p.personID = t.patientID 
join treatment using(patientid)
group by state,companyName
order by num_claims desc;

