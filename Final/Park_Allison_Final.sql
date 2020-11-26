-- Allison Park
-- Data Wrangling Final Exam

SELECT * FROM hpark.IC_BP_v2

-- #1a: Renaming column BPAlerts to BPStatus 
EXEC sp_RENAME 'hpark.IC_BP_v2.BPAlerts' , 'BPStatus', 'COLUMN'
SELECT top 10 * FROM hpark.IC_BP_v2 ORDER BY NEWID()  -- printing ten random rows


-- #1b: Using casewhen statements to redefine values of the BPStatus column
ALTER TABLE hpark.IC_BP_v2  -- call to update the table to Controlled/Uncontrolled, create new colummn BPStatus1
ADD BPStatus1 AS (CASE [BPStatus]  -- when the column BPStatus is the following values
	WHEN 'Hypo1'  then 'Controlled' -- outcome for Controlled BP
	WHEN 'Normal' then 'Controlled' 
	WHEN 'Hypo2'  then 'Uncontrolled'  -- outcome for Uncontrolled BP
	WHEN 'HTN1'   then 'Uncontrolled'  
	WHEN 'HTN2'   then 'Uncontrolled'  
	WHEN 'HTN3'   then 'Uncontrolled'  
	ELSE 'Null' -- Previously null values are again null
    END) 
SELECT top 10 * FROM hpark.IC_BP_v2 ORDER BY NEWID()  -- printing ten random rows

ALTER TABLE hpark.IC_BP_v2  -- call to update the table to 0/1, create new colummn BPStatus2
ADD BPStatus2 AS (CASE [BPStatus]  -- when the column BPStatus1 is the following values
	WHEN 'Hypo1'  then '1' -- Dichotomous outcome for Controlled BP
	WHEN 'Normal' then '1' 
	WHEN 'Hypo2'  then '0'  -- Dichotomous outcome for Uncontrolled BP
	WHEN 'HTN1'   then '0'  
	WHEN 'HTN2'   then '0'  
	WHEN 'HTN3'   then '0'  
    ELSE 'Null' -- Previously null values are again null
    END) 
SELECT top 10 * FROM hpark.IC_BP_v2 ORDER BY NEWID()  -- printing ten random rows


-- #1c: Merging with Demographics table to obtain enrollment dates
select * into hpark.Demo_BP from Demographics d  -- create a new table called Demo_BP as the combined table
inner join
hpark.IC_BP_v2 i
on
i.ID = d.contactid  -- determining which columns to inner join by
SELECT top 10 ID, tri_enrollmentcompletedate FROM hpark.Demo_BP ORDER BY NEWID()  -- printing ten random rows for the ID and date

-- #1d through 1f in R


-- #2. Demographics, Conditions and TextMessages
select * into hpark.merged_DCT from Demographics a
inner join Conditions b
on a.contactid = b.tri_patientid 
left join Text c
on c.tri_contactId = a.contactid 

--  1 Row per ID by choosing on the latest date when the text was sent (if sent on multiple days)
select * into hpark.merged_DCT2 from Demographics a
inner join Conditions b
on a.contactid = b.tri_patientid 
-- using the latest (max) date
left join (select c.tri_contactId, max(c.TextSentDate) as 'latest_date' from dbo.[Text] c group by c.tri_contactId) d  
on d.tri_contactId = a.contactid 

ALTER table hpark.merged_DCT2  -- dropping repeated col
DROP COLUMN tri_contactId 

SELECT top 10 * FROM hpark.merged_DCT2 ORDER BY NEWID()  -- printing ten random rows for new dataset






