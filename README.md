# 🏥 Healthcare Data Analysis

## 📜 Table of Contents
- Project Overview
- Dataset Description
- SQL Database Structure
- Key Insights
- Visualizations
- How to Use
- Future Scope
- Contributors
- License

## 📌 Project Overview
This project analyzes patient records, medical conditions, hospital admissions, and billing trends to gain valuable insights into the healthcare system. Using SQL for database management and Python for data analysis, we explore patterns in hospital admissions, medical expenses, and treatment trends.

## 📂 Dataset Description
The dataset (healthcare_dataset.csv) contains 55,500 patient records with details on:
- Demographics: Name, Age, Gender, Blood Type
- Medical Data: Diagnosis, Medications, Test Results
- Hospital Information: Hospital Name, Assigned Doctor, Admission & Discharge Dates
- Billing & Insurance: Insurance Provider, Billing Amount, Room Number, Admission Type

## 🗄️ SQL Database Structure
The SQL database (HealthCare.sql) consists of structured patient records with queries for:
- Data Retrieval (SELECT * FROM healthcare_records;)
- Data Cleaning (Standardizing names, handling missing values)
- Data Validation (Checking negative billing amounts, verifying admission dates)
- Analytical Queries (Identifying costliest medical conditions, most common diagnoses)

## 📊 Key Insights
- 🚑 Emergency vs. Elective Admissions: Majority of patients are admitted as urgent or emergency cases, indicating high hospital demand.
- 💰 Medical Billing Trends: The highest recorded bill is ~$52,764, while some records show incorrect negative billing values that require correction.
- 🏥 Hospital Performance: Certain hospitals have significantly higher admission rates, while others specialize in specific medical conditions.
- 📈 Common Diagnoses: Obesity, Diabetes, and Cancer are among the most frequently diagnosed conditions.
- 💊 Medication Trends: Some medications (e.g., Paracetamol, Ibuprofen) are prescribed across multiple conditions, highlighting general vs. specialized treatment patterns.
- 📊 Insurance Insights: Medicare & Aetna are the most commonly used insurance providers, affecting hospital reimbursement strategies.
- 🔍 Blood Type Distribution: Some blood groups (e.g., O+ and A+) appear more frequently in patient records.

## 📎 How to Use

🖥️ Clone the repository:
git clone https://github.com/NiraliKhambhati/Healthcare-Data-Analysis.git

## 📦 Install dependencies:
pip install mysql-connector-python

## 📊 Run the SQL Queries:
USE healthcare_data;
SELECT * FROM healthcare_records LIMIT 100;

## 📌 Future Scope

🔹 Expand dataset to include hospital operational costs and staff efficiency metrics.
🔹 Develop automated SQL scripts for data cleaning and transformation.
🔹 Integrate Electronic Health Records (EHR) for deeper analysis.

## 👥 Contributors
Nirali Khambhati - Project Lead & Data Analyst

## 📝 License
This project is licensed under the MIT License - see the LICENSE file for details.

## 📧 For Queries: Reach out via GitHub Issues or email!
## 🎯 Author: Nirali Khambhati
