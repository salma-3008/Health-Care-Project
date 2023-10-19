create database healthcare;
use healthcare;

#1
with cte as (SELECT patientID ,FLOOR(DATEDIFF(CURRENT_DATE, dob) / 365) AS age
from patient) 
select count(*) as num_of_treatments,
CASE WHEN age BETWEEN 0 AND 14 THEN 'Children'
WHEN age BETWEEN 15 AND 24 THEN 'Young'
WHEN age BETWEEN 25 AND 64 THEN 'Adults'
WHEN age >= 65 THEN 'Seniors'
else 'unknown'
end as "Age_Category"
from patient JOIN treatment using (patientID) JOIN cte using(patientID)
where year(date) = 2022
group by Age_Category;

#2
SELECT diseaseName,
sum(CASE WHEN gender = 'Male' THEN 1 ELSE 0 END) AS male_count,
sum(CASE WHEN gender = 'Female' THEN 1 ELSE 0 END) AS female_count,
ROUND(sum(CASE WHEN gender = 'Male' THEN 1 ELSE 0 END) / 
sum(CASE WHEN gender = 'Female' THEN 1 ELSE 0 END), 2) AS male_to_female_ratio
from disease d
JOIN treatment t using(diseaseID) 
JOIN person p on p.personID = t.patientID group by diseaseName
ORDER BY male_to_female_ratio DESC limit 1;

#3
select gender,
sum(case when claimid is not null then 1 else 0 end)/count(treatmentid) as 
treatment_to_claim_ratio from
treatment t left JOIN person p ON P.personid = t.patientid
group by gender;

#4
select pharmacyid,sum(quantity) as num_units,sum(maxprice) as total_max_retail_price,
sum(maxprice-discount/100*maxprice) as after_discount from pharmacy
JOIN keep using(pharmacyid) join medicine using(medicineid) group by pharmacyid;

#5
with cte1 as (select pharmacyname,count(medicineid) as num_of_medicine from contain join
prescription using(prescriptionID)
join pharmacy using(pharmacyid)
group by prescriptionid)
select pharmacyname,max(num_of_medicine) as maximum, min(num_of_medicine) as minimum, 
avg(num_of_medicine) as average
from cte1 group by pharmacyname;








