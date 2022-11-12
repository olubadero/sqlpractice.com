-- Show first name, last name, and gender of patients who's gender is 'M'
select first_name, last_name, gender
FROM patients
WHERE gender = "M";

-- Show first name and last name of patients who does not have allergies. (null)
select first_name, last_name
FROM patients
WHERE allergies IS NULL;

-- Show first name of patients that start with the letter 'C'
select first_name
FROM patients
WHERE first_name like 'C%';

-- Show first name and last name of patients that weight within the range of 100 to 120 (inclusive)
select first_name, last_name
FROM patients
WHERE weight between 100 and 120;

SELECT
  first_name,
  last_name
FROM patients
WHERE weight >= 100 AND weight <= 120;

-- Show first name, last name, and the full province name of each patient. Example: 'Ontario' instead of 'ON'

SELECT p.first_name, p.last_name, pn.province_name
from patients AS p
JOIN province_names AS pn
USING (province_id);

-- Update the patients table for the allergies column. If the patient's allergies is null then replace it with 'NKA'
update patients
set allergies = 'NKA'
WHERE allergies IS null;

-- Show how many patients have a birth_date with 2010 as the birth year.
select count(*) AS Total_Patients
from patients
WHERE birth_date between '2010-01-01' and '2010-12-31';

SELECT COUNT(*) AS total_patients
FROM patients
WHERE YEAR(birth_date) = 2010;

SELECT count(first_name) AS total_patients
FROM patients
WHERE
  birth_date >= '2010-01-01'
  AND birth_date <= '2010-12-31';
  
-- Show the first_name, last_name, and height of the patient with the greatest height.
SELECT first_name, last_name, height
from patients
WHERE height = (select MAX(height) from patients);

SELECT
  first_name,
  last_name,
  MAX(height) AS height
FROM patients;  

-- Show all columns for patients who have one of the following patient_ids: 1,45,534,879,1000
select *
FROM patients
where patient_id IN (1,45,534,879,1000);

-- Show the total number of admissions
select count(*)
FROM admissions;

-- Show all the columns from admissions where the patient was admitted and discharged on the same day.
select *
FROM admissions
where admission_date = discharge_date;

-- Show the total number of admissions for patient_id 579.
select patient_id, count(*)
FROM admissions
where patient_id = 579
group by 1;

-- Based on the cities that our patients live in, show unique cities that are in province_id 'NS'?
select distinct CITY
FROM patients
WHERE province_id = 'NS';

SELECT city
FROM patients
GROUP BY city
HAVING province_id = 'NS';

-- Write a query to find the first_name, last name and birth date of patients who have height more than 160 and weight more than 70
select first_name, last_name, birth_date
FROM patients
WHERE height > 160 AND weight > 70;

-- Write a query to find list of patients first_name, last_name, and allergies from Hamilton where allergies are not null
select first_name, last_name, allergies
FROM patients
WHERE city = "Hamilton" AND allergies is not null;

-- Show unique birth years from patients and order them by ascending.
select distinct(year(birth_date))
FROM patients
order by birth_date;

select year(birth_date)
FROM patients
group by 1
order by birth_date;

-- Show unique first names from the patients table which only occurs once in the list.
select first_name
FROM patients
group by first_name
having count(*) = 1;

SELECT first_name
FROM (
    SELECT
      first_name,
      count(first_name) AS occurrencies
    FROM patients
    GROUP BY first_name
  )
WHERE occurrencies = 1;

-- Show patient_id and first_name from patients where their first_name start and ends with 's' and is at least 6 characters long.
select patient_id, first_name
FROM patients
WHERE first_name like 'S%S' AND LEN(first_name) >= 6;

SELECT
  patient_id,
  first_name
FROM patients
WHERE first_name LIKE 's____%s';

SELECT
  patient_id,
  first_name
FROM patients
where
  first_name like 's%'
  and first_name like '%s'
  and len(first_name) >= 6;
  
-- Show patient_id, first_name, last_name from patients whos diagnosis is 'Dementia'.
select p.patient_id, p.first_name, p.last_name
FROM admissions as a
join patients as p
USING (patient_id)
where diagnosis = 'Dementia';

SELECT
  patient_id,
  first_name,
  last_name
FROM patients
WHERE patient_id IN (
    SELECT patient_id
    FROM admissions
    WHERE diagnosis = 'Dementia'
  );
  
-- Display every patient's first_name. Order the list by the length of each name and then by alphbetically
SELECT first_name
FROM patients
ORDER BY len(first_name), first_name;

-- Show the total amount of male patients and the total amount of female patients in the patients table. Display the two results in the same row.
select sum(case when gender = "M" then 1 else 0 end) as male_count, 
		sum(case when gender = "F" then 1 else 0 end) as female_count
FROM patients;

SELECT 
  SUM(Gender = 'M') as male_count, 
  SUM(Gender = 'F') AS female_count
FROM patients;

SELECT 
  (SELECT count(*) FROM patients WHERE gender='M') AS male_count, 
  (SELECT count(*) FROM patients WHERE gender='F') AS female_count;
  
-- Show first and last name, allergies from patients which have allergies to either 'Penicillin' or 'Morphine'. Show results ordered ascending by allergies then by first_name then by last_name.
SELECT first_name, last_name, allergies
FROM patients
where allergies IN ('Penicillin', 'Morphine')
order by allergies, first_name, last_name;

SELECT first_name, last_name, allergies
FROM patients
WHERE allergies = 'Penicillin' OR allergies = 'Morphine'
ORDER BY allergies ASC, first_name ASC, last_name ASC;

-- Show patient_id, diagnosis from admissions. Find patients admitted multiple times for the same diagnosis.
WITH Visits AS(SELECT patient_id, diagnosis, LEAD(diagnosis) OVER(PARTITION BY patient_id) AS next_diagnosis 
			FROM admissions)
select patient_id, diagnosis
from visits
WHERE diagnosis = next_diagnosis;

SELECT patient_id, diagnosis
FROM admissions
GROUP BY patient_id, diagnosis
HAVING COUNT(*) > 1;

-- Show the city and the total number of patients in the city. Order from most to least patients and then by city name ascending.
select city, count(*) AS Number_of_patients
from patients
group by city
ORDER BY count(*) DESC, city;

-- Show first name, last name and role of every person that is either patient or doctor. The roles are either "Patient" or "doctor"
select first_name, last_name, "Patient" as Role from patients
union all
SELECT first_name, last_name, "Doctor" as Role from doctors;

-- Show all allergies ordered by popularity. Remove NULL values from query.
select allergies, COUNT(*) AS Popularity
from patients
where allergies is not null
group by allergies
order by COUNT(*) desc;

SELECT allergies, count(allergies) AS total_diagnosis
FROM patients
GROUP BY allergies
HAVING allergies IS NOT NULL
ORDER BY total_diagnosis DESC;

-- Show all patient's first_name, last_name, and birth_date who were born in the 1970s decade. Sort the list starting from the earliest birth_date.
select first_name, last_name, birth_date
from patients
where year(birth_date) between 1970 and 1979
order by birth_date;

SELECT first_name, last_name, birth_date
FROM patients
WHERE birth_date >= '1970-01-01' AND birth_date < '1980-01-01'
ORDER BY birth_date;

SELECT first_name, last_name, birth_date
FROM patients
WHERE year(birth_date) LIKE '197%'
ORDER BY birth_date;

-- We want to display each patient's full name in a single column. Their last_name in all upper letters must appear first, then first_name in all lower case letters. Separate the last_name and first_name with a comma. Order the list by the first_name in decending order EX: SMITH,jane
select concat(upper(last_name), "," , lower(first_name))
from patients
order by first_name desc;

SELECT
  UPPER(last_name) || ',' || LOWER(first_name) AS new_name_format
FROM patients
ORDER BY first_name DESC;

-- Show the province_id(s), sum of height; where the total sum of its patient's height is greater than or equal to 7,000.
select province_id, sum(height)
from patients
group by province_id
HAVING SUM(height) >= 7000;

-- Show the difference between the largest weight and smallest weight for patients with the last name 'Maroni'
select max(Weight) - min(weight)
from patients
WHERE last_name = 'Maroni';

-- Show all of the days of the month (1-31) and how many admission_dates occurred on that day. Sort by the day with most admissions to least admissions.
select day(admission_date), count(admission_date) AS number_of_admissions
from admissions
group by DAY(admission_date)
order by count(*) desc;

-- Show all columns for patient_id 542's most recent admission_date.
select *
from admissions
group by patient_id
having patient_id = 542 and max(admission_date);

SELECT *
FROM admissions
WHERE patient_id = 542
GROUP BY patient_id
HAVING admission_date = MAX(admission_date);

SELECT *
FROM admissions
WHERE patient_id = '542'
  AND admission_date = (
    SELECT MAX(admission_date)
    FROM admissions
    WHERE patient_id = '542'
  );
  
SELECT *
FROM admissions
WHERE patient_id = 542
ORDER BY admission_date DESC
LIMIT 1;

-- Show patient_id, attending_doctor_id, and diagnosis for admissions that match one of the two criteria:
-- 1. patient_id is an odd number and attending_doctor_id is either 1, 5, or 19.
-- 2. attending_doctor_id contains a 2 and the length of patient_id is 3 characters.

SELECT patient_id, attending_doctor_id, diagnosis
FROM admissions
WHERE patient_id%2 = 1 AND attending_doctor_id in (1, 5, 19) 	
		or attending_doctor_id LIKE '%2%' AND LEN(patient_id) = 3;
        
-- Show first_name, last_name, and the total number of admissions attended for each doctor. Every admission has been attended by a doctor.
SELECT first_name, last_name, count(*) total_admissions
FROM admissions AS a
join doctors as d
ON a.attending_doctor_id = d.doctor_id
group by 1, 2;

SELECT first_name, last_name, count(*)
from doctors p, admissions a
where a.attending_doctor_id = p.doctor_id
group by p.doctor_id;

-- For each physicain, display their id, full name, and the first and last admission date they attended.
SELECT doctor_id, concat(first_name, ' ', last_name) as full_name, 
		MAX(admission_date) AS Latest_admission_date, MIN(admission_date) as first_admission_date
FROM admissions AS a
join doctors as d
ON a.attending_doctor_id = d.doctor_id
group by doctor_id;

-- Display the total amount of patients for each province. Order by descending.
SELECT pn.province_name, count(*) as number_of_patients
FROM patients AS p
join province_names as pn
USING (province_id)
group by 1
order by 2 desc;

-- For every admission, display the patient's full name, their admission diagnosis, and their doctor's full name who diagnosed their problem.
SELECT concat(p.first_name, ' ', p.last_name) As patients_full_name, a.diagnosis, 
		concat(d.first_name, ' ', d.last_name) As doctors_full_name
FROM patients AS p
join admissions as a 
USING (patient_id)
join doctors as d 
on a.attending_doctor_id = d.doctor_id;

-- Show all of the patients grouped into weight groups. Show the total amount of patients in each weight group.
-- Order the list by the weight group decending.
-- For example, if they weight 100 to 109 they are placed in the 100 weight group, 110-119 = 110 weight group, etc.
SELECT count(*) as number_of_patients, (weight/10) *10 as weight_grouping
FROM patients
group by 2
order by 2 desc;

-- Show patient_id, weight, height, isObese from the patients table.
-- Display isObese as a boolean 0 or 1.
-- Obese is defined as weight(kg)/(height(m)2) >= 30.
-- weight is in units kg. height is in units cm.

SELECT patient_id, weight, height, case when weight/(power(height/100.0, 2)) >= 30 then 1 else 0 end as isObese
FROM patients;


SELECT patient_id, weight, height, case when weight/(power(height/100.0, 2)) >= 30 then 1 else 0 end as isObese
FROM patients;

-- Show patient_id, first_name, last_name, and attending doctor's specialty.
-- Show only the patients who has a diagnosis as 'Epilepsy' and the doctor's first name is 'Lisa'
-- Check patients, admissions, and doctors tables for required information.
SELECT p.patient_id, p.first_name, p.last_name, d.specialty
FROM patients AS p
join admissions as a 
USING (patient_id)
join doctors as d 
on a.attending_doctor_id = d.doctor_id
where a.diagnosis = 'Epilepsy' and d.first_name = 'Lisa';

with patient_table as (
    SELECT
      patients.patient_id,
      patients.first_name,
      patients.last_name,
      admissions.attending_doctor_id
    FROM patients
      JOIN admissions ON patients.patient_id = admissions.patient_id
    where
      admissions.diagnosis = 'Epilepsy'
  )
select
  patient_table.patient_id,
  patient_table.first_name,
  patient_table.last_name,
  doctors.specialty
from patient_table
  JOIN doctors ON patient_table.attending_doctor_id = doctors.doctor_id
WHERE doctors.first_name = 'Lisa';

SELECT
  a.patient_id,
  a.first_name,
  a.last_name,
  b.specialty
FROM
  patients a,
  doctors b,
  admissions c
WHERE
  a.patient_id = c.patient_id
  AND c.attending_doctor_id = b.doctor_id
  AND c.diagnosis = 'Epilepsy'
  AND b.first_name = 'Lisa';
  
-- All patients who have gone through admissions, can see their medical documents on our site. Those patients are given a temporary password after their first admission. Show the patient_id and temp_password.
-- The password must be the following, in order:
-- 1. patient_id
-- 2. the numerical length of patient's last_name
-- 3. year of patient's birth_date
SELECT distinct patient_id, concat(patient_id, len(last_name), year(birth_date)) as temp_password 
FROM patients AS p
join admissions as a 
USING (patient_id);

-- Each admission costs $50 for patients without insurance, and $10 for patients with insurance. All patients with an even patient_id have insurance.
-- Give each patient a 'Yes' if they have insurance, and a 'No' if they don't have insurance. Add up the admission_total cost for each has_insurance group.
SELECT case when patient_id%2 = 0 then 'Yes' else 'No' end as Insurance_Status,
		SUM(case when patient_id%2 = 0 then 10 else 50 end) as Total_cost_after_admission
FROM admissions
group by 1;

select 'No' as has_insurance, count(*) * 50 as cost
from admissions where patient_id % 2 = 1 group by has_insurance
union
select 'Yes' as has_insurance, count(*) * 10 as cost
from admissions where patient_id % 2 = 0 group by has_insurance;

select has_insurance,sum(admission_cost) as admission_total
from
(
   select patient_id,
   case when patient_id % 2 = 0 then 'Yes' else 'No' end as has_insurance,
   case when patient_id % 2 = 0 then 10 else 50 end as admission_cost
   from admissions
)
group by has_insurance;

SELECT
  has_insurance,
  CASE
    WHEN has_insurance = 'Yes' THEN COUNT(has_insurance) * 10
    ELSE count(has_insurance) * 50
  END AS cost_after_insurance
FROM (
    SELECT
      CASE
        WHEN patient_id % 2 = 0 THEN 'Yes'
        ELSE 'No'
      END AS has_insurance
    FROM admissions
  )
GROUP BY has_insurance;


-- Show the provinces that has more patients identified as 'M' than 'F'. Must only show full province_name
WITH Counts as (SELECT pn.province_name, p.gender, count(p.gender) as female_count, 
		lead(count(p.gender)) over(partition by pn.province_name) as male_count
		FROM patients AS p
		join province_names as pn 
		USING (province_id)
		group by 1, 2)
select province_name
from Counts
where male_count > female_count;

SELECT pr.province_name
FROM patients AS pa
  JOIN province_names AS pr ON pa.province_id = pr.province_id
GROUP BY pr.province_name
HAVING
  COUNT( CASE WHEN gender = 'M' THEN 1 END) > COUNT( CASE WHEN gender = 'F' THEN 1 END);

SELECT province_name
FROM (
    SELECT
      province_name,
      SUM(gender = 'M') AS n_male,
      SUM(gender = 'F') AS n_female
    FROM patients pa
      JOIN province_names pr ON pa.province_id = pr.province_id
    GROUP BY province_name
  )
WHERE n_male > n_female;

SELECT pr.province_name
FROM patients AS pa
  JOIN province_names AS pr ON pa.province_id = pr.province_id
GROUP BY pr.province_name
HAVING
  SUM(gender = 'M') > SUM(gender = 'F');
  
-- We are looking for a specific patient. Pull all columns for the patient who matches the following criteria:
-- First_name contains an 'r' after the first two letters.
-- Identifies their gender as 'F'
-- Born in February, May, or December
-- Their weight would be between 60kg and 80kg
-- Their patient_id is an odd number
-- They are from the city 'Kingston'  
SELECT *
FROM patients
WHERE first_name LIKE '__r%' 
		and gender = 'F' 
		and month(birth_date) in (2, 5, 12) 
		and weight between 60 and 80
        and patient_id % 2 = 1
        and city = 'Kingston';
        
-- Show the percent of patients that have 'M' as their gender. Round the answer to the nearest hundreth number and in percent form.
SELECT CONCAT(
    ROUND(
      (
        SELECT COUNT(*)
        FROM patients
        WHERE gender = 'M'
      ) / CAST(COUNT(*) as float),
      4
    ) * 100,
    '%'
  ) as percent_of_male_patients
FROM patients;

-- For each day display the total amount of admissions on that day. Display the amount changed from the previous date.
with cte as (select admission_date, count(*) as num_of_admission, 
             lag(count(*)) over() as previous_count
	from admissions
	group by admission_date)
select admission_date, num_of_admission,  num_of_admission - previous_count  
from cte;


SELECT
 admission_date,
 count(admission_date) as admission_day,
 count(admission_date) - LAG(count(admission_date)) OVER(ORDER BY admission_date) AS admission_count_change 
FROM admissions
 group by admission_date;

WITH admission_counts_table AS (
  SELECT admission_date, COUNT(patient_id) AS admission_count
  FROM admissions
  GROUP BY admission_date
  ORDER BY admission_date DESC
)
select
  admission_date, 
  admission_count, 
  admission_count - LAG(admission_count) OVER(ORDER BY admission_date) AS admission_count_change 
from admission_counts_table;











	



