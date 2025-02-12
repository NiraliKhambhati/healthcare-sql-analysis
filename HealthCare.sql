-- 1. INITIAL QUERIES
-- Dataset 
USE healthcare_data;

-- Display all records
SELECT *
FROM healthcare_records
LIMIT 100;

-- Check the Structure
DESCRIBE healthcare_records;

-- 2. DATA CLEANING 
-- Standardizing Capitalization
Update healthcare_records
SET Name = concat(
       UPPER(SUBSTRING(SUBSTRING_INDEX(Name, ' ', 1), 1, 1)),
       LOWER(SUBSTRING(SUBSTRING_INDEX(Name, ' ', 1), 2)),
       ' ',
       UPPER(SUBSTRING(SUBSTRING_INDEX(Name, ' ', -1), 1, 1)),
       LOWER(SUBSTRING(SUBSTRING_INDEX(Name, ' ', -1), 2))
);

-- Verifying Changes    
SELECT *
FROM healthcare_records
LIMIT 100;
	
-- 3. DATA QUALITY CHECKS
-- Identifying missing data in critical columns
SELECT
     COUNT(*) as total_rows,
     SUM(CASE WHEN Name IS NULL THEN 1 ELSE 0 END) AS missing_names,
     SUM(CASE WHEN Age IS NULL THEN 1 ELSE 0 END) AS missing_ages,
     SUM(CASE WHEN Gender IS NULL THEN 1 ELSE 0 END) AS missing_genders
FROM healthcare_records;

-- Examining Date Range of Records
SELECT 
      MIN(Date_of_Admission) as first_admission,
      MAX(Date_of_Admission) as last_admission
FROM healthcare_records;

/* The dataset spans admissions from May 8, 2019, to May 7, 2024. 
This indicates a five-year period of healthcare records, making it suitable for analyzing trends in patient admissions, treatments, or other healthcare-related metrics over time.*/

-- Checking for Duplicates
SELECT *
FROM healthcare_records
WHERE (Name, Age, Gender, Blood_Type, Medical_Condition, Date_of_Admission, Doctor) IN (
    SELECT Name, Age, Gender, Blood_Type, Medical_Condition, Date_of_Admission, Doctor
    FROM healthcare_records
    GROUP BY Name, Age, Gender, Blood_Type, Medical_Condition, Date_of_Admission, Doctor
    HAVING COUNT(*) > 1
);
    
-- 4. BASIC STATISTICS
SELECT
	COUNT(*) as total_records,
    MIN(Age) as min_age,
    MAX(Age) as max_age,
    ROUND(AVG(Age),2) as average_age,
    MIN(Billing_Amount) as min_billing,
    MAX(Billing_Amount) as max_billing,
    ROUND(AVG(Billing_Amount),2) as average_billing
FROM healthcare_records;

/* The dataset contains 55,500 records. 
The age of individuals ranges from 13 to 89 years, with an average age of 51.54 years. 
Billing amounts range from -2008.49 to 52,764.28, with an average billing amount of 25,539.32. 
The negative billing amount indicates possible refunds or adjustments. */

-- 6.CATEGORICAL DATA ANALYSIS
-- Analyze Gender Distribution
SELECT 
	Gender, 
    COUNT(*) as Count
FROM healthcare_records
GROUP BY Gender;

-- Analyze distribution by Blood Count
SELECT 
      Blood_Type,
      COUNT(*) AS bloodtype_count
FROM healthcare_records
GROUP BY Blood_Type;

-- Analyze Distributio by Medical Condition
SELECT 
	Medical_Condition,
    COUNT(*) as MedicalCondition_count
FROM healthcare_records
GROUP BY Medical_Condition;

-- 7. TREND ANALYSIS AND DEMOGRAPHIC ANALYSIS
-- How has the number of admissions changed over time?
SELECT 
     YEAR(Date_of_Admission) as Year,
     MONTH(Date_of_Admission) as Month,
     COUNT(*) AS Total_Admission
FROM healthcare_records
GROUP BY Year, Month
ORDER BY Year, Month;

/* The data shows steady monthly admissions (850–1,000) from May 2019 to May 2024, with slight seasonal fluctuations (e.g., higher in July-August, lower in February). 
Admissions stabilize yearly, except for May 2024 (213), indicating incomplete data. */

-- Are there seasonal patterns in admissions due to specific medical conditions?
SELECT 
	month(Date_of_Admission) as month,
    Medical_Condition,
    COUNT(*) as admission_count
FROM healthcare_records
GROUP BY month, Medical_Condition
ORDER BY Medical_Condition, month;

/* Arthritis: Admissions peak in July and August (853) and are lower in April and September.
 Asthma: Higher admissions occur in January, June, and August, with a drop in November and February.
 Cancer: Admissions are highest in August and October, with dips in February and April.
 Diabetes: Admissions peak in June and July and decline in February and December.
 Hypertension: Higher admissions occur in October and May, with a drop in February and September.
 Obesity: Peaks in December and March, with lower admissions in February and April. */

-- How does the prevalence of specific medical conditions vary across different age groups and genders?
SELECT
      Medical_Condition,
      CASE  
		WHEN Age between 0 and 18 THEN '0-18'
        WHEN Age between 19 and 35 THEN '19-35'
		WHEN Age between 36 and 55 THEN '36-55'
        WHEN Age between 56 and 75 THEN '56-75'
        ELSE '76+'
	END AS Age_Group,
    COUNT(*) AS Patient_Count
FROM healthcare_records
GROUP BY Medical_Condition, Age_Group
ORDER BY Medical_Condition, Age_Group;

/* Age-Specific Prevalence: Conditions like arthritis, diabetes, cancer, and hypertension are more common in older age groups, 
while asthma and obesity are spread across adult age ranges.
Younger (<18): These groups have minimal cases, indicating that these conditions are more adult-specific. */

-- How Age and Other Demographics interact with gender and medical condition
SELECT 
     Gender,
     Medical_Condition,
     AVG(Age) AS Average_Age,
     COUNT(*) AS Cases
FROM healthcare_records
GROUP BY Gender, Medical_Condition
ORDER BY Medical_Condition, Average_Age;

-- The average age for all conditions is around 51-52 years, suggesting that these chronic conditions primarily affect middle-aged individuals.
-- Chronic conditions affect both genders at similar ages, with minor variations.
-- Hypertension in females appears later than in males, while other conditions show minimal age-based gender differences.

-- What are the most common medications prescribed for each medical condition?
SELECT 
     Medical_Condition, 
     Medication,
     Prescription_Count
FROM (
	  SELECT
          Medication, 
          Medical_Condition, 
          COUNT(*) as Prescription_Count,
          RANK() OVER (PARTITION BY Medical_Condition ORDER BY COUNT(*) DESC) AS med_rank
      FROM healthcare_records
      GROUP BY Medical_Condition, Medication
) as ranked_medications
WHERE med_rank <= 3
ORDER BY Medical_Condition, med_rank;

-- Pain relievers (Ibuprofen, Paracetamol, Aspirin) are widely prescribed across multiple conditions.
-- Lipitor is commonly prescribed for cancer and diabetes, suggesting cardiovascular risk management.
-- Penicillin is frequently prescribed for diabetes and obesity, possibly for infection control.

-- 9.FINANCIAL AND INSURANCE ANALYSIS
-- What is the average billing amount by medical condition or by hospital?
SELECT 
      Medical_Condition, 
      ROUND(AVG(Billing_Amount), 2) as Avg_Billing
FROM healthcare_records
GROUP BY Medical_Condition
ORDER BY Avg_Billing DESC, Medical_Condition;

/* The average billing amount varies slightly across medical conditions, 
-- with obesity having the highest average billing ($25,805.97) and cancer the lowest ($25,161.79).*/

-- Is there a relationship between insurance provider and type of admission (urgent, elective, emergency)?
SELECT 
      Insurance_Provider, 
      Admission_Type, 
      COUNT(*) as total_patients
FROM healthcare_records
GROUP BY Insurance_Provider, Admission_Type
ORDER BY Insurance_Provider, Admission_Type;

-- The data suggests that there is a fairly consistent distribution of admission types (elective, emergency, urgent) across different insurance providers, with each provider having a comparable number of admissions for each category.
-- For example, Aetna has a slightly higher number of elective admissions (3754) compared to emergency (3675) and urgent (3484), a pattern that is similarly reflected in other providers like Cigna and UnitedHealthcare, albeit with some variations in exact numbers. This indicates that the type of insurance coverage does not significantly influence the type of hospital admission, as all major providers cover a balanced mix of admission types.

-- 10. HOSPITAL AND DOCTOR ANALYSIS
-- Which hospitals have the highest number of admissions?
SELECT 
     Hospital, 
     COUNT(*) as Total_Patients
FROM healthcare_records
GROUP BY Hospital
ORDER BY Total_Patients DESC;

/* The rest of the list, like Group Smith, LLC Johnson, and PLC Williams each with 30 admissions, 
and others following closely, indicates a high level of healthcare activity and could be indicative of regional healthcare hubs or specialized centers depending on the services they offer.*/

-- Which doctors handle the most cases of a specific condition?
SELECT 
     Doctor, 
     Medical_Condition, 
	 COUNT(*) AS Total_patients
FROM (
    SELECT Doctor, Medical_Condition, COUNT(*) AS Total_patients,
           ROW_NUMBER() OVER (PARTITION BY Medical_Condition ORDER BY COUNT(*) DESC) AS rn
    FROM healthcare_records
    GROUP BY Doctor, Medical_Condition
) AS subquery
WHERE rn <= 3;

/* Arthritis: Top 3 doctors treating the most patients, with John Smith treating the most (8 patients).
Asthma, Cancer, Diabetes, Hypertension, and Obesity: Similarly, top practitioners in each of these conditions are listed, with the counts of patients they've treated. */