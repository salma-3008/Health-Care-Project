use healthcare;
#1
select medicineid, productType, productName,
case when producttype = '1' and taxcriteria = 'I' then 'Generic'
when producttype = '2' and taxcriteria = 'I' then 'Patent'
when producttype = '3' and taxcriteria = 'I' then 'Reference'
when producttype = '4' and taxcriteria = 'II' then 'Similar'
when producttype = '5' and taxcriteria = 'II' then 'New'
when producttype = '6' and taxcriteria = 'II' then 'Specific'
when producttype = '7' and taxcriteria = 'III' then 'Biological'
when producttype = '8' and taxcriteria = 'III' then 'Dinamized'
end as producttype
from medicine;

#2
select prescriptionid,sum(quantity) as totalQuantity,
case when sum(quantity) <= 20 then 'low quantity'
when sum(quantity) > 20 and sum(quantity) <= 49 then 'medium quantity'
when sum(quantity) >= 50 then 'high quantity'
end as 'Tag'
from prescription join contain using(prescriptionid)
group by prescriptionid;

#3
select medicineid, discount,sum(quantity) as total_quantity,
case when sum(quantity) > 7500 and discount = 0 then 'HIGH QUANTITY WITH LOW DISCOUNT'
when sum(quantity) < 1000 and discount >= 30 then 'LOW QUANTITY WITH HIGH DISCOUNT'
end as total_count
from keep join pharmacy using(pharmacyid) 
where pharmacyname = 'Spot Rx'
group by medicineid,discount;

#4
select * from (
SELECT
    m1.medicineID,
    m1.companyName,
    m1.productName,
    m1.maxPrice,
    CASE
        WHEN m1.maxPrice > 2 * avg_maxprice THEN "Costly"
        WHEN m1.maxPrice < 0.5 * avg_maxprice THEN "Affordable"
    END AS priceCategory
FROM
    medicine m1
join keep k using(medicineid)
join pharmacy p using (pharmacyid)

 JOIN
 (SELECT AVG(maxprice) AS avg_maxprice FROM medicine) as avgTable
 where p.pharmacyName="HealthDirect" and m1.hospitalexclusive="S"
)as derived
    
    where priceCategory is not null
    ;

#5
#Write a SQL query to list all the patient name, gender, dob, and their category.
select personname,gender,dob,
case when dob > '2005-01-01' and gender = 'Male' then 'YoungMale'
when dob > '2005-01-01' and gender = 'Female' then 'YoungFemale'
when (dob between '2005-01-01' and '1985-01-01') and gender = 'Male' then 'AultMale'
when (dob between '2005-01-01' and '1985-01-01') and gender = 'Female' then 'AdultFemale'
when (dob between '1985-01-01' and '1970-01-01') and gender = 'Male' then 'MidAgeMale'
when (dob between '1985-01-01' and '1970-01-01') and gender = 'Female' then 'MidAgeFemale'
when dob < '1970-01-01' and gender = 'Male' then 'Eldermale'
when dob < '2005-01-01' and gender = 'Female' then 'ElderFemale'
else 'none'
end as 'category'
from person p join patient p1 on p.personid = p1.patientid;













