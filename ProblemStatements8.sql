#1
select floor(datediff(now(), dob) / 365) as age, count(*) as numTreatments 
from Person p
join Patient pt on pt.patientid = p.personid
join Treatment t using (patientid)
group by age
order by numTreatments desc;

#2
select city,count(distinct pharmacyid) AS numPharmacy,count(distinct companyID) AS numInsuranceCompany,
count(distinct personID) AS numRegisteredPeople
from address 
left join pharmacy Ph using (addressid)
left join insurancecompany using (addressid)
left join person using (addressid)
group by city
order by numRegisteredPeople desc;

#3
select c.prescriptionID,
sum(quantity) as totalQuantity,case
when sum(quantity) < 20 then 'Low Quantity'
when sum(quantity) < 50 then 'Medium Quantity'
else 'High Quantity'
end as tag
from contain c
join prescription p using (prescriptionid)
join pharmacy ph using (pharmacyid)       
where pharmacyname='Ally Scripts'
group by c.prescriptionid;

#4
with avg_quantity_cte as (
select sum(quantity) as totalquantity from pharmacy p 
join prescription pr using (pharmacyid)
join treatment t using (treatmentid)
join contain c using (prescriptionid)
group by p.pharmacyID,pr.prescriptionID
)
select p.pharmacyid,pr.prescriptionid,sum(quantity) as totalquantity 
from Pharmacy p
join Prescription pr using (pharmacyid)
join Contain using (prescriptionid)
join Medicine ON Medicine.medicineID = Contain.medicineID
join Treatment t using (treatmentid)
where year(date) = 2022
group by p.pharmacyID, pr.prescriptionID
having totalQuantity > (select avg(totalquantity) from avg_quantity_cte);

#5
select diseasename, count(*) as no_of_claims
from disease
join treatment using (diseaseid)
join claim using (claimid)
where diseaseName like '%p%'
group by diseaseName;






