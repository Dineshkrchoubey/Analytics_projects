use dkcsandbox;
select * from marketing_data limit 5;
-- Taking a look at the data 
describe marketing_data;
--  checking data in each columns
select count(ID),count(distinct ID) from marketing_data; -- checking for duplicate values
select count(ID) from marketing_data where ID is null;   -- checking for null values
select Education, count(Education) from marketing_data -- checking all categories and their count present in education column 
group by Education WITH ROLLUP; -- and with the help of rollup checking for null values.
select Marital_Status, count(Marital_Status) from marketing_data
group by Marital_Status WITH ROLLUP; -- Marital status feild has many categories which does not make any sense 
-- cleaning Marital_Status column 
set sql_safe_updates=0; 
-- creating copy of original table (VERSION CONTROL)
create table marketing_data_v1 
select *, (case when Marital_status='Absurd' then 'Single'
		    when Marital_status='Alone' then 'Single'
            when Marital_status='Single' then 'Single'
            when Marital_status='YOLO' then 'Single'
            when Marital_status='Together' then 'Married'
			when Marital_status='Married' then 'Married'
            when Marital_status='Divorced' then 'Divorced'
            when Marital_status='Widow' then 'Widow'
            end) as Marital_Status_new
            from marketing_data;
select * from marketing_data_v1;
select Marital_Status_new, count(Marital_Status_new) from marketing_data_v1
group by Marital_Status_new WITH ROLLUP;
-- dropping old marital status column 
alter table marketing_data_v1 drop column Marital_Status;
select * from marketing_data_v1;
-- checking income column
select count(Income) from marketing_data_v1 where Income is null; -- no null values
select count(Income) from marketing_data_v1 where Income =0;-- 24 zero values going to drop them
delete from marketing_data_v1 where Income=0;
select count(*) from marketing_data_v1 where Income=0;-- all customers with 0 income are dropped
select min(Income),avg(Income),max(Income) from marketing_data_v1;
-- minimum income= 1730, avg income=52247.25 and, maximum income= 666666
select Education,min(Income),avg(Income),max(Income) from marketing_data_v1
group by Education;
/* INSIGHTS	
Education  MinIncome AvgIncome	MaxIncome
Graduation	1730	52720.3737	666666
PhD			4023	56145.3139	162397
Master		6560	52917.5342	157733
Basic		7500	20306.2593	34445
2n Cycle	7500	47633.1900	96547
*/
select Marital_Status_new,min(Income),avg(Income),max(Income) from marketing_data_v1
group by Marital_Status_new;
/*INSIGHTS
M.Status  MinIncome AvgIncome	MaxIncome
Single		3502	51028.8117	113734
Married		2447	52334.2643	666666
Divorced	1730	52834.2284	153924
Widow		22123	56481.5526	85620 
*/
-- checking kidhome column
select Kidhome,count(Kidhome) from marketing_data_v1 group by Kidhome;
-- Maxmimum customers (1283) have no kids at home
-- 887 customers has 1 kid and 46 customers has 2 kids at home
-- checking teenhome column
select Teenhome,count(Teenhome) from marketing_data_v1 group by Teenhome;
-- Maxmimum customers (1147) have no teens at home
-- 1018 customers has 1 teen and 51 customers has 2 teens at home
select count(ID) from marketing_data_v1 where Kidhome>0 and Teenhome=0;
-- total 514 customers having only kids 
select count(ID) from marketing_data_v1 where Kidhome=0 and Teenhome>0;
-- total 650 customers having only teen 
select count(ID) from marketing_data_v1 where Kidhome>0 and Teenhome>0;
-- total 419 customers are there who are having both kids and teens in their household
select count(ID) from marketing_data_v1 where Kidhome=0 and Teenhome=0;
-- total 633 customers are there who are having no kids and teens in their household
select * from marketing_data_v1;
create table marketing_data_v2 -- new copied table created
select *,(case when AcceptedCmp1=1 then 'Yes'
			else 'No' end) as AcceptedCmp1_new,
            (case when AcceptedCmp2=1 then 'Yes'
			else 'No' end) as AcceptedCmp2_new,
            (case when AcceptedCmp3=1 then 'Yes'
			else 'No' end) as AcceptedCmp3_new,
            (case when AcceptedCmp4 then 'Yes'
			else 'No' end) as AcceptedCmp4_new,
            (case when AcceptedCmp5=1 then 'Yes'
			else 'No' end) as AcceptedCmp5_new,
            (case when Response=1 then 'Yes'
			else 'No' end) as AcceptedCmp6_new
		    from marketing_data_v1 ;
-- Dropping old campaigns columns
alter table marketing_data_v2 drop column AcceptedCmp1,drop column AcceptedCmp2,drop column AcceptedCmp3,
drop column AcceptedCmp4,drop column AcceptedCmp5,drop column Response;
select * from marketing_data_v2;
-- Checking count of yes and no in all marketing campaigns
select AcceptedCmp1_new,count(AcceptedCmp1_new)from marketing_data_v2 group by AcceptedCmp1_new;
select AcceptedCmp2_new,count(AcceptedCmp2_new)from marketing_data_v2 group by AcceptedCmp2_new;
select AcceptedCmp3_new,count(AcceptedCmp3_new)from marketing_data_v2 group by AcceptedCmp3_new;
select AcceptedCmp4_new,count(AcceptedCmp4_new)from marketing_data_v2 group by AcceptedCmp4_new;
select AcceptedCmp5_new,count(AcceptedCmp5_new)from marketing_data_v2 group by AcceptedCmp5_new;
select AcceptedCmp6_new,count(AcceptedCmp6_new)from marketing_data_v2 group by AcceptedCmp6_new;
-- Checking complain column
select Complain, count(Complain) from marketing_data_v2 group by Complain;
-- changing zeroes and ones to yes and no
create table marketing_data_v3 -- new copied table created
select *,(case when Complain=1 then 'Yes'
			else 'No' end) as Complain_new from marketing_data_v2;
alter table marketing_data_v3 drop column Complain; -- Droping old complain column
/* we have two columns like Z_Revenue and Z_CostContact 
they both have same value for all records and these columns are not useful 
so i am going to drop them */
alter table marketing_data_v3 drop column Z_Revenue, drop column Z_CostContact;
select * from marketing_data_v3;
-- all the data cleaning has been done and more analysis will be done in python 
-- exporting csv for further processing and eda.
-- export done using table export wizard.
 

