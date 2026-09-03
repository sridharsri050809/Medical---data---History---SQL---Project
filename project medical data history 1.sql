use project_medical_data_history
-- Q1. Show first name, last name, and gender of patients who's gender is 'M'
SELECT first_name, last_name,
gender
from patients
where gender ='M';
-- Q2. Show first name and last name of patients who does not have allergies.
SELECT first_name, last_name
FROM patients
WHERE allergies IS NULL;
-- Q3. Show first name of patients that start with the letter 'C'
SELECT first_name
FROM patients
WHERE first_name LIKE 'C%';
-- Q4. Show first name and last name of patients that weight within the range of 100 to 120 inclusive
SELECT first_name, last_name
FROM patients
WHERE weight BETWEEN 100 AND 120;
-- Q5. Update the patients table for the allergies column. If the patient's allergies is null then replace it with 'NKA'
-- Note: Error 1142 - UPDATE permission denied for user 'dm_team4'. Query is correct but cannot be executed due to UPDATE patients
SET allergies = 'NKA'
where allergies IS NULL;
-- Q6. Show first name and last name concatenated into one column to show their full name.
SELECT CONCAT(first_name, ' ', last_name) AS full_name
FROM patients;
-- Q7. Show first name, last name, and the full province name of each patient.
SELECT p.first_name, p.last_name, pn.province_name
FROM patients p
JOIN province_names pn ON p.province_id = pn.province_id;
-- Q8. Show how many patients have a birth_date with 2010 as the birth year.
SELECT COUNT(*) AS total_patients_2010
FROM patients
WHERE YEAR(birth_date) = 2010;
-- Q9. Show the first_name, last_name, and height of the patient with the greatest height.
SELECT first_name, last_name, height
FROM patients
ORDER BY height DESC
LIMIT 1;
-- Q10. Show all columns for patients who have one of the following patient_ids: 1, 45, 534, 879, 1000
SELECT *
FROM patients
WHERE patient_id IN (1, 45, 534, 879, 1000);
-- Q11. Show the total number of admissions
SELECT COUNT(*) AS total_admissions
FROM admissions;
-- Q12. Show all the columns from admissions where the patient was admitted and discharged on the same day.
SELECT *
FROM admissions
WHERE admission_date = discharge_date;
-- Q13. Show the total number of admissions for patient_id 579.
SELECT COUNT(*) AS total_admissions
FROM admissions
WHERE patient_id = 579;
-- Q14. Based on the cities that our patients live in, show unique cities that are in province_id 'NS'
SELECT DISTINCT city
FROM patients
WHERE province_id = 'NS';
-- Q15. Write a query to find the first_name, last_name and birth_date of patients who have height more than 160 and weight more than 70
SELECT first_name, last_name, birth_date
FROM patients
WHERE height > 160 AND weight > 70;
-- Q16. Show unique birth years from patients and order them by ascending.
SELECT DISTINCT YEAR(birth_date) AS birth_year
FROM patients
ORDER BY birth_year ASC;
-- Q17. Show unique first names from the patients table which only occurs once in the list.
SELECT first_name
FROM patients
GROUP BY first_name
HAVING COUNT(first_name) = 1;
-- Q18. Show patient_id and first_name from patients where their first_name start and ends with 's' and is at least 6 characters long.
SELECT patient_id, first_name
FROM patients
WHERE first_name LIKE 's%s'
AND LENGTH(first_name) >= 6;
-- Q19. Show patient_id, first_name, last_name from patients whos diagnosis is 'Dementia'. Primary diagnosis is stored in the admissions table.
SELECT p.patient_id, p.first_name, p.last_name
FROM patients p
JOIN admissions a ON p.patient_id = a.patient_id
WHERE a.diagnosis = 'Dementia';
-- Q20. Display every patient's first_name. Order the list by the length of each name and then by alphabetically.
SELECT first_name
FROM patients
ORDER BY LENGTH(first_name), first_name;
-- Q21. Show the total amount of male patients and the total amount of female patients in the patients table. Display the two results in the same row.
SELECT
SUM(CASE WHEN gender = 'M' THEN 1 ELSE 0 END) AS male_count,
SUM(CASE WHEN gender = 'F' THEN 1 ELSE 0 END) AS female_count
FROM patients;
-- Q22. Show the total amount of male patients and the total amount of female patients in the patients table. Display the two results in the same row.
SELECT
SUM(CASE WHEN gender = 'M' THEN 1 ELSE 0 END) AS male_count,
SUM(CASE WHEN gender = 'F' THEN 1 ELSE 0 END) AS female_count
FROM patients;
-- Q23. Show patient_id, diagnosis from admissions. Find patients admitted multiple times for the same diagnosis.
SELECT patient_id, diagnosis
FROM admissions
GROUP BY patient_id, diagnosis
HAVING COUNT(*) > 1;
-- Q24. Show the city and the total number of patients in the city. Order from most to least patients and then by city name ascending.
SELECT city, COUNT(*) AS total_patients
FROM patients
GROUP BY city
ORDER BY total_patients DESC, city ASC;
-- Q25. Show first name, last name and role of every person that is either patient or doctor. The roles are either 'Patient' or 'Doctor'
SELECT first_name, last_name, 'Patient' AS role
FROM patients
UNION ALL
SELECT first_name, last_name, 'Doctor' AS role
FROM doctors;
-- Q26. Show all allergies ordered by popularity. Remove NULL values from query
SELECT allergies, COUNT(*) AS total_count
FROM patients
WHERE allergies IS NOT NULL
GROUP BY allergies
ORDER BY total_count DESC;
-- Q27. Show all patient's first_name, last_name, and birth_date who were born in the 1970s decade. Sort the list starting from the earliest birth_date.
SELECT first_name, last_name, birth_date
FROM patients
WHERE YEAR(birth_date) BETWEEN 1970 AND 1979
ORDER BY birth_date ASC;
-- Q28. Display each patient's full name in format: LASTNAME,firstname. Last name upper case, first name lower case. Order by first_name descending.
SELECT CONCAT(UPPER(last_name), ',', LOWER(first_name)) AS full_name
FROM patients
ORDER BY first_name DESC;
-- Q29. Show the province_id(s) and sum of height where the total sum of height is greater than or equal to 7000.
SELECT province_id, SUM(height) AS sum_height
FROM patients
GROUP BY province_id
HAVING SUM(height) >= 7000;
-- Q30. Show the difference between the largest weight and smallest weight for patients with the last name 'Maroni'
SELECT MAX(weight) - MIN(weight) AS weight_difference
FROM patients
WHERE last_name = 'Maroni';
-- Q31. Show all of the days of the month (1-31) and how many admission_dates occurred on that day. Sort by most admissions to least.
SELECT DAY(admission_date) AS day_number, COUNT(*) AS total_admissions
FROM admissions
GROUP BY day_number
ORDER BY total_admissions DESC;
-- Q32. Show all patients grouped into weight groups (100-109=100, 110-119=110 etc). Show total patients per group. Order descending.
SELECT FLOOR(weight / 10) * 10 AS weight_group, COUNT(*) AS total_patients
FROM patients
GROUP BY weight_group
ORDER BY weight_group DESC;
-- Q33. Show patient_id, weight, height, isObese. isObese = 1 if weight(kg)/height(m)^2 >= 30, else 0.
SELECT patient_id, weight, height,
CASE WHEN (weight / POWER(height / 100.0, 2)) >= 30
THEN 1 ELSE 0 END AS isObese
FROM patients;
-- Q34. Show patient_id, first_name, last_name, and attending doctor's specialty for patients with diagnosis 'Epilepsy' and doctor's first name 'Lisa'.
SELECT p.patient_id, p.first_name, p.last_name, d.specialty
FROM patients p
JOIN admissions a ON p.patient_id = a.patient_id
JOIN doctors d ON a.attending_doctor_id = d.doctor_id
WHERE a.diagnosis = 'Epilepsy'
AND d.first_name = 'Lisa';













