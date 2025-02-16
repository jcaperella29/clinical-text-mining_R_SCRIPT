# clinical-text-mining_R_SCRIPT#
🏥 Medical Phenotype Text Mining & Data Harmonization 🧬

## 📜 Overview
This R script processes phenotype data by:
- Cleaning and imputing missing values
- Standardizing categorical data (e.g., diagnosis names)
- Extracting and structuring blood pressure readings
- Mapping diagnoses to ICD-10 codes
- Annotating with clinical notes
- Exporting a final cleaned dataset

It is useful for researchers analyzing patient phenotype data and harmonizing medical terms for downstream analysis.

---

## ⚙️ Installation & Dependencies

Ensure you have **R** installed. Then, install the necessary packages if not already available:

```r
install.packages(c("dplyr", "tidyr"))
 Usage
Prepare the dataset – Ensure your dataset is structured with columns like age, weight_kg, diagnosis, and blood_pressure_mmHg.

Run the script – Execute the script in RStudio or using Rscript in the terminal.

Check the output – The cleaned and annotated dataset will be saved as:

Copy
Edit
cleaned_phenotype_data.csv
Example run:

r
Copy
Edit
source("phenotype_text_mining.R")
🔍 How It Works
🏗️ Step 1: Load and Simulate Data
A sample dataset of patients is created with missing values and unstructured text fields.
🧹 Step 2: Data Cleaning
Missing Age & Weight → Imputed using median and mean values.
Missing Diagnoses → Replaced with "Unknown".
Blood Pressure Readings → Split into systolic and diastolic values.
📊 Step 3: Data Harmonization
Diagnoses are mapped to ICD-10 codes for standardization.
Example mapping:
nginx
Copy
Edit
Hypertension → I10
Diabetes → E11
Asthma → J45
🏷️ Step 4: Data Annotation
Clinical notes are added to provide context on each diagnosis.
📤 Step 5: Exporting Data
The final structured dataset is saved as cleaned_phenotype_data.csv.
📂 Output Example
patient_id	age	weight_kg	diagnosis	systolic	diastolic	diagnosis_code	clinical_note
1	34	70	Hypertension	120	80	I10	Chronic condition affecting blood pressure
2	36	85	Diabetes	140	90	E11	Chronic condition affecting blood sugar regulation
3	45	77.6	Hypertension	127	84	I10	Chronic condition affecting blood pressure
🏥 Applications
Medical Research: Standardizing patient phenotype data for ML models.
Clinical Informatics: Harmonizing diagnoses using ICD-10 mappings.
EHR Processing: Enhancing structured clinical datasets with annotations.
🔗 References
ICD-10 Codes
Human Phenotype Ontology (HPO)
