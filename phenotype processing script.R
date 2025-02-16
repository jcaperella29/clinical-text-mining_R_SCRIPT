# Load necessary libraries
library(dplyr) # Data manipulation
library(tidyr) # Missing data handling

# Step 1: Simulate phenotype data
phenotype_data <- data.frame(
  patient_id = c(1, 2, 3, 4, 5, 6),
  age = c(34, NA, 45, 22, 29, 50),
  weight_kg = c(70, 85, NA, 65, 78, 90),
  diagnosis = c("Hypertension", "Diabetes", "Hypertension", NA, "Asthma", "Diabetes"),
  blood_pressure_mmHg = c("120/80", "140/90", NA, "110/70", "130/85", "150/95"),
  medication = c("Lisinopril", "Metformin", "Lisinopril", "None", "Albuterol", "Metformin")
)

print("Original Data:")
print(phenotype_data)

# Step 2: Data Cleaning

# Step 2.1: Handle Missing Data - Imputation
# Replace missing age with the median
phenotype_data <- phenotype_data %>%
  mutate(age = ifelse(is.na(age), median(age, na.rm = TRUE), age))

# Replace missing weight with the mean
phenotype_data <- phenotype_data %>%
  mutate(weight_kg = ifelse(is.na(weight_kg), mean(weight_kg, na.rm = TRUE), weight_kg))

# Step 2.2: Handle Missing Categorical Data
# Replace missing diagnosis with 'Unknown'
phenotype_data <- phenotype_data %>%
  mutate(diagnosis = replace_na(diagnosis, "Unknown"))

# Step 2.3: Standardize Blood Pressure Readings
# Split the blood pressure values and calculate averages
phenotype_data <- phenotype_data %>%
  separate(blood_pressure_mmHg, into = c("systolic", "diastolic"), sep = "/") %>%
  mutate(systolic = as.numeric(systolic),
         diastolic = as.numeric(diastolic))

# Fill missing blood pressure values with means
phenotype_data <- phenotype_data %>%
  mutate(systolic = ifelse(is.na(systolic), mean(systolic, na.rm = TRUE), systolic),
         diastolic = ifelse(is.na(diastolic), mean(diastolic, na.rm = TRUE), diastolic))

print("Cleaned Data:")
print(phenotype_data)

# Step 3: Data Harmonization

# Harmonize the diagnosis column by standardizing the names to match known ontologies
# For example, we can map diagnoses to ICD-10 codes
diagnosis_mapping <- list(
  "Hypertension" = "I10",  # ICD-10 code for Hypertension
  "Diabetes" = "E11",      # ICD-10 code for Type 2 Diabetes
  "Asthma" = "J45",        # ICD-10 code for Asthma
  "Unknown" = "R69"        # ICD-10 code for Unknown and unspecified causes
)

# Apply the mapping
phenotype_data <- phenotype_data %>%
  mutate(diagnosis_code = unlist(diagnosis_mapping[diagnosis]))

print("Harmonized Data with ICD-10 codes:")
print(phenotype_data)

# Step 4: Data Annotation

# Mock annotation step - in real scenarios, you might pull from HPO or other resources
# Here we’ll annotate with dummy clinical notes
annotations <- data.frame(
  diagnosis_code = c("I10", "E11", "J45"),
  clinical_note = c("Chronic condition affecting blood pressure",
                    "Chronic condition affecting blood sugar regulation",
                    "Respiratory condition characterized by inflammation of the airways")
)

# Merge annotations into the phenotype data
phenotype_data <- left_join(phenotype_data, annotations, by = "diagnosis_code")

print("Annotated Data with Clinical Notes:")
print(phenotype_data)

# Step 5: Indexing and Export

# Export the cleaned, harmonized, and annotated data for further use
write.csv(phenotype_data, "cleaned_phenotype_data.csv", row.names = FALSE)

print("Data exported to 'cleaned_phenotype_data.csv'")
