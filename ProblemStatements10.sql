use healthcare;
#1
drop procedure performance;
delimiter //
create procedure performance(in cid int)
begin
select companyid,planname,count(treatmentID) as num_treatments,diseasename from insuranceplan join claim 
using(uin) join treatment using (claimid) join disease using(diseaseid) 
where companyID = cid
group by companyID,planname,diseasename order by num_treatments desc;
end //
delimiter ;
call performance(6951);

#2
drop procedure popular;
delimiter //
create procedure popular(in dname varchar(20))
begin
with cte as (select pharmacyname, dense_rank() over(order by count(*) desc) as drn 
from disease join treatment using(diseaseid) join 
prescription using(treatmentid) 
join pharmacy using(pharmacyid) where diseasename = dname and year(date) = 2021 
group by pharmacyName) ,

cte2 as (select pharmacyname, dense_rank() over(order by count(*) desc) as dn
from disease join treatment using(diseaseid) join 
prescription using(treatmentid) 
join pharmacy using(pharmacyid) where diseasename = dname and year(date) = '2022' 
group by pharmacyName)
select * from cte join cte2 using(pharmacyname) order by dn, drn asc ;
end //
delimiter ;
call popular('Asthma');

#3
drop procedure RecommendState;
delimiter //
create procedure RecommendState(in id varchar(20))
begin 
with cte1 as(
select a.state, count(*) as num_insurance_companies from address a join insuranceCompany ic 
using (addressid) group by a.state),
cte2 as (
select a.state, count(*) as num_patients from address a join person p using(addressid)
join patient pat on p.personID =pat.patientid group by a.state),
cte3 as ( select state,round(cte2.num_patients/cte1.num_insurance_companies,4) as insurance_patient_ratio
 from cte1 join cte2 using(state) group by state )
 select *,id as state,case
 when insurance_patient_ratio<avg_insurance_patient_ratio then "Recommended"
 else "Not Recommended"
 end as Recommendation
 from (
 select (select num_patients from cte2 where state=id) as num_patients,
 (select num_insurance_companies from cte1 where state=id) as num_insurance_companies,
 
 (select insurance_patient_ratio from cte3 where state=id) as insurance_patient_ratio,
 round(avg(insurance_patient_ratio),4) as avg_insurance_patient_ratio 
 
 from cte3) as derived ;
 end //
 delimiter ;
 call RecommendState('ma')
 
 #4
 create table if not exists PlacesAdded(
 placeID int auto_increment primary key ,
 placeName varchar(50) unique,
 placeType varchar(10) not null,
 timeAdded datetime not null);
 
 delimiter //
 create trigger for_PlacesAdded
 after insert on address for each row
 begin
	insert into PlacesAdded(placeName,placeType,timeAdded) values(new.city,'city',now());
    insert into PlacesAdded(placeName,placeType,timeAdded) values(new.state,'state',now());
 end//
 delimiter ;
 insert into address values(123,"yyyyyy-yy","demo city","demo state",12345);
select * from PlacesAdded;
set sql_safe_updates=0;
delete from address where city="demo city";

#5
create table if not exists Keep_Log(
id int auto_increment primary key,
medicineID int not null,
quantity int not null);

delimiter //
create trigger update_log
after update on keep for each row
begin
if old.quantity <> new.quantity then
	insert into Keep_Log(medicineID,quantity) values(new.medicineID,new.quantity-old.quantity);
end if;
end //
delimiter ;
 
 
 
 
 
 
 
 
 