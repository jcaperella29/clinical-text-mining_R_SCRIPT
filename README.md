# clinical-text-mining_R_SCRIPT#

# 🏥 Medical Phenotype Extraction from Doctor's Notes 🩺  

## 📜 Overview  
This R script extracts **structured phenotype data** from **unstructured doctor's notes**.  
It cleans, standardizes, maps diagnoses to **ICD-10 codes**, applies **one-hot encoding**,  
and exports a **ready-to-use phenotype matrix** for **machine learning & statistical analysis**.  

### 🔬 Features  
✅ Parses **doctor’s notes** into structured data using **regex & NLP**  
✅ Handles **missing values & normalizes blood pressure, weight, age**  
✅ **Maps diagnoses to ICD-10 codes** for standardization  
✅ **One-hot encodes categorical data** (diagnosis & meds) for ML  
✅ Saves **phenotype_matrix.csv** for **database integration & research**  

---

## ⚙️ Installation & Dependencies  
```r
install.packages(c("dplyr", "tidyr", "stringr"))

🚀 Usage
Prepare your raw doctor’s notes in a structured text file.
Run the script to extract structured data:
r
Copy
Edit
source("generate_phenotype_matrix.R")
Upload the phenotype_matrix.csv to your lab’s database.
📂 Output Example
sample_id	age	weight_kg	systolic	diastolic	diagnosis_Hypertension	diagnosis_Diabetes	diagnosis_Asthma	diagnosis_Cardiovascular_Disease	med_Lisinopril	med_Metformin	med_Albuterol	med_Atorvastatin
S001	56	81	140	90	1	0	0	0	1	0	0	0
🏥 Database Integration
If using SQL, run:


library(DBI)
con <- dbConnect(RSQLite::SQLite(), dbname = "lab_database.sqlite")
dbWriteTable(con, "phenotype_data", read.csv("phenotype_matrix.csv"), overwrite = TRUE)
dbDisconnect(con)
