use healthcare;
#1
select pharmacyid,pharmacyname,
sum(case when hospitalexclusive = 'S' THEN 1 else 0 end) as num_hospital_Exclusive
from medicine join contain using(medicineid) join 
prescription using(prescriptionid) join pharmacy using(pharmacyid) join treatment t using(treatmentid) 
where year(t.date) between '2021' and '2022' group by pharmacyid,pharmacyname
order by num_hospital_Exclusive;
#2
select planname,companyid,count(treatmentID) as num_treatments from insuranceplan join claim using(uin) 
join treatment using(claimid) group by planname,companyid;
#3
select companyname,planname,count(claimID) as claimed_plans from insurancecompany join insuranceplan 
using(companyid) join claim using(uin)
group by planname,companyname;
#4
select state,count(personid) as registerd_people, count(patientid) as registerd_patients,
count(personid)/count(patientid) as people_to_patient_ratio
from address join person using(addressid)
left join patient on patient.patientid = person.personid 
group by state;
#5
select pharmacyName,sum(quantity) as total_quantity,state from contain join prescription 
using(prescriptionid) join treatment t using(treatmentid) join patient using(patientid) 
join pharmacy using(pharmacyid) join address using(addressid) join medicine using(medicineid)
where taxcriteria = 'I' and year(t.date) = '2021'
group by pharmacyName,state;

