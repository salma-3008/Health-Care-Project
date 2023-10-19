#1
drop procedure requirement;
delimiter //
create procedure requirement(in id int)
begin
select pharmacyName,phone,quantity,medicineid from pharmacy join keep using(pharmacyid)
where medicineid = id;
end //
delimiter ;
call requirement(4778);

#2
drop function if exists average_cost;
delimiter //
create function average_cost( id int, did varchar(20))
returns decimal(10,2)
deterministic
begin 
declare avg_cost decimal(10,2);
select round(avg(m.maxprice*c.quantity),2)  from prescription  join 
treatment t using(treatmentid) 
join contain c using(prescriptionid) join medicine m using(medicineid)  
where pharmacyID = id and year(date) = did group by pharmacyid into avg_cost;
return avg_cost;
end //
delimiter ;
select average_cost(1008,'2022' )as average_cost;
#3
drop function if exists most;
delimiter //
create function most( sid varchar(20), id varchar(20))
returns varchar(20)
deterministic
begin 
declare dname varchar(30);
select count(treatmentid) as num_treatments,diseaseName into dname from disease join treatment 
using(diseaseid) join patient p
using(patientid) join person p1 on p.patientID = p1.personID join address using(addressid) 
where state = sid and year(date) = id group by state;
return dname;
end //
delimiter ;
select most('ok','2021') as ratio;

#4
drop function countTreatment;
delimiter //
create function countTreatment(city varchar(255) ,yer char(4), dname varchar(255) )
returns int
deterministic
begin
declare cnt int;
select count(t.treatmentid)  from disease d join treatment t using (diseaseid)
join person p on t.patientid = p.personID join address a 
using(addressid) where year(t.date)=yer and a.city=city and d.diseaseName=dname group by d.diseaseid
into cnt;
return cnt;
end //
delimiter ;
select countTreatment('alameda',2022,"Alzheimer's disease") as cntTreatment;

#5
drop function avgBalCompany;
delimiter //
create function avgBalCompany(iname varchar(255) )
returns decimal(10,2)
deterministic
begin
declare avgbal decimal(10,2);
select  round(avg(c.balance),2) as avg_balance from insuranceCompany ic join insurancePlan ip using (companyid)
join claim c using(uin) join treatment t using( claimid) where year(t.date)=2022 and
ic.companyName=iname into avgbal;
return avgbal;
end //
delimiter ;
select avgBalCompany('Niva Bupa Health Insurance Co. Ltd.') as avg_balance;
 


