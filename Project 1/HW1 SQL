--Homework 1
--Question 1
select parentcustomeridname, tri_imaginecareenrollmentstatus, tri_age AS Age, gendercode AS Gender, contactid AS ID, address1_stateorprovince AS State, TRY_CONVERT(DATETIME, tri_imaginecareenrollmentemailsentdate) as EmailSentdate, TRY_CONVERT(DATETIME, tri_enrollmentcompletedate) as Completedate into hpark.Demographics2 from dbo.Demographics

ALTER TABLE hpark.Demographics2 
ADD 
  Days AS DATEDIFF (day, EmailSentdate, Completedate)
  
select top 10 * from hpark.Demographics2
where Days is not null

--Question 2
ALTER TABLE hpark.Demographics2 
ADD EnrollmentStatus as (CASE [tri_imaginecareenrollmentstatus]
	WHEN 167410011 then 'Complete'
    WHEN 167410001 then 'Email'
    WHEN 167410004 then 'Non responder'
	WHEN 167410005 then 'Facilitated Enrollment'
    WHEN 167410002 then 'Incomplete Enrollments'
    WHEN 167410003 then 'Opted Out'
    WHEN 167410000 then 'Unprocessed'
    WHEN 167410006 then 'Second email sent'
    ELSE 'Null'
    END) 
    
--Question 3
ALTER TABLE hpark.Demographics2 
ADD GenderNew as (CASE [Gender]
	WHEN '2' then 'Female'
    WHEN '1' then 'Male'
    WHEN '167410000' then 'Other'
    ELSE 'Null'
    END) 
    
--Question 4
ALTER TABLE hpark.Demographics2 
ADD AgeGroup as (CASE
	WHEN Age between 0 and 25 then '0-25'
    WHEN Age between 26 and 50 then '26-50'
    WHEN Age between 51 and 75 then '51-75'
    ELSE '76+'
    END) 
select Age, AgeGroup from hpark.Demographics2 d 
