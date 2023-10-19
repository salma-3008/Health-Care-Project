#1
-- Insurance companies want to know if a disease is claimed higher or lower than average.  Write a stored procedure that returns “claimed higher than average” 
-- or “claimed lower than average” when the diseaseID is passed to it. 
-- Hint: Find average number of insurance claims for all the diseases.  If the number of claims for the passed disease is higher than the average return 
-- “claimed higher than average” otherwise “claimed lower than average”.
drop procedure avg_claims;
delimiter //
create procedure avg_claims(
	in id int,
    out status_ varchar(40)
    )
begin 
declare claim decimal(10,6);
declare avg_ decimal(10,6); 
select count(claimid)/count(treatmentid) into avg_ from treatment t;
select count(claimid)/count(treatmentID) into claim from treatment t where t.diseaseID = id;
if claim > avg_ then set status_ = 'claimed_higher';
else set status_ = 'claimed_lower';
end if;
end //
delimiter ;
call avg_claims(27,@s);
select @s;

#2

drop procedure report;
delimiter //
create procedure report(in did int)
begin
select diseasename,
sum(case when gender = 'male' then 1 else 0 end) as 'number_of_male_treated',
sum(case when gender = 'female'then 1 else 0 end) as 'number_of_female_treated',
case when sum(case when gender = 'male' then 1 else 0 end) > sum(case when gender = 'female'then 1 else 0 end) then 
'Male gender' else 'female gender' end as 'more_treated_gender'
from disease join treatment t using(diseaseid) join person p 
on t.patientid = p.personid where diseaseid = did group by diseasename ;

end //
delimiter ;
call report(23);

#3
select companyName,planname,num_claims from
(select companyName,planname,count(claimid) as num_claims
from claim join insuranceplan using(uin)
join insurancecompany using(companyid)
group by planname,companyname
order by num_claims desc limit 3) most_claimed
union
select companyName,planname, num_claims from
(select companyName,planname,count(claimid) as num_claims
from claim join insuranceplan using(uin)
join insurancecompany using(companyid)
group by planname,companyname
order by num_claims limit 3) as least_claimed; # doubt

#4
with age_stats as 
(select pt.patientid,
case
when pt.dob>='2005-01-01' then
	case when gender='male' then 'YoungMale' else 'YoungFemale' end
when pt.dob<'2005-01-01' and pt.dob>='1985-01-01' then
	case when gender='male' then 'AdultMale' else 'AdultFemale' end
when pt.dob<='1985-01-01' and pt.dob>='1970-01-01' then
	case when gender='male' then 'MidAgeMale' else 'MidAgeFemale' end
when pt.dob<'1970-01-01' then
	case when gender='male' then 'ElderMale' else 'ElderFemale' end 
end as Age_category
from patient pt join person p on p.personid=pt.patientid),
category_count as 
(select diseaseName,Age_category,count(patientid) as patient_count,
rank() over (partition by diseaseName order by count(patientid) desc) as category_rank
 from age_stats ac join treatment tr using(patientid) join disease d using(diseaseid) 
group by diseaseName,Age_category)
select diseaseName,Age_category as Most_Affected_Category from category_count where category_rank=1;

#5
select companyname,productname,description,maxprice,
case when maxprice > 1000 then 'pricey'
when maxprice < 5 then 'affordable'
end as 'price_category'
from medicine where maxprice < 5 or maxprice > 1000 
order by maxprice desc;




