# PAN Number Validation Using SQL & Python

![SQL](https://img.shields.io/badge/SQL-MySQL-blue) 
![Python](https://img.shields.io/badge/Python-3.x-green) 
![Pandas](https://img.shields.io/badge/Library-Pandas-orange)

## 📌 Project Objective
The goal of this project is to clean and validate a dataset containing the **Permanent Account Numbers (PAN)** of Indian nationals.Using a combination of **Python** for data engineering and **SQL** for complex validation logic, the project ensures each entry adheres to official formats and specific business constraints.

---

## 🛠️ Tech Stack
* **Database:** MySQL (Validation logic, UDFs, and CTEs)
* **Programming:** Python (Data ingestion and preprocessing)
* **Libraries:** Pandas, SQLAlchemy, MySQL-Connector

---

## 📋 Validation Logic & Constraints
As per the problem statement, a PAN is considered **Valid** only if it meets the following strict criteria:

### 1. Structure
**Length:** Exactly 10 characters long.
**Format:** `AAAAA1234A` (5 Alphabets, 4 Digits, 1 Alphabet).

### 2. Custom Business Rules
* **No Adjacent Duplicates:** Consecutive characters (alphabets or digits) cannot be the same. For example, `AABCD` is invalid, but `AXBCD` is valid.
* **No Sequences:** The first 5 characters and the middle 4 digits cannot form a perfect incremental sequence. For example, `ABCDE` or `1234` are invalid.

---

## 🚀 Workflow

### Phase 1: Data Ingestion (Python)
I used a Python script (`pan_data_sharing.ipynb`) to automate the transfer of raw data from a CSV/Excel file into a MySQL database.
* **Security:** Used `urllib.parse` to safely handle database credentials.
* **Automation:** Utilized `SQLAlchemy` to push the DataFrame to the `pan_card` database.

### Phase 2: Data Cleaning (SQL)
Before validation, the data underwent a cleaning process:
**Trimming:** Removed leading and trailing spaces.
**Case Normalization:** Converted all PANs to uppercase.
**Deduplication:** Filtered out duplicate records to ensure data integrity.
**Null Handling:** Identified and removed empty or null entries.

### Phase 3: Validation Engine (SQL)
I developed two **User Defined Functions (UDFs)** to handle the complex validation requirements:
1.  **`check_adjacent(p_str)`**: A loop-based function that detects if any two characters side-by-side are identical.
2.  **`check_sequence(p_str)`**: A function using ASCII value comparisons to determine if a string forms an incremental sequence.

Finally, a **Common Table Expression (CTE)** combines these UDFs with **Regular Expressions (REGEXP)** to categorize each record as "Valid" or "Invalid".

---

## 📊 Summary Report
The final output provides a summary including:
* Total records processed
* Total Valid PANs 
*Total Invalid PANs
* Total missing or incomplete records 

---

## 📂 Repository Structure
* `PAN Number Validation - Problem Statement.pdf`: Detailed project requirements.
* `pan_data_sharing.ipynb`: Python notebook for data migration.
* `PAN_No_Validation.sql`: SQL script containing UDFs, cleaning, and validation logic.

---

## 👤 Author
**Harshit Raj** *Computer Science Student & Aspiring Data Analyst* [LinkedIn](https://www.linkedin.com/in/harshit-raj-7480hrt) | [GitHub](https://github.com/HRTvictor)
