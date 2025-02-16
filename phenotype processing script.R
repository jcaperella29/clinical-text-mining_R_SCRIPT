
# Load necessary libraries
library(dplyr)   # Data manipulation
library(tidyr)   # Data cleaning
library(stringr) # Regex & text processing

# Example raw doctor's notes as unstructured text
raw_notes <- c(
  "Patient ID: 001 | Age: 56 | Weight: 81kg | BP: 140/90 | Diagnosis: Hypertension | Medications: Lisinopril 10mg daily",
  "Patient ID: 002 | Age: 45 | Weight: 75kg | BP: 130/85 | Diagnosis: Diabetes | Medications: Metformin 500mg twice daily",
  "Patient ID: 003 | Age: 39 | Weight: 69kg | BP: 120/80 | Diagnosis: Asthma | Medications: Albuterol as needed",
  "Patient ID: 004 | Age: 60 | Weight: 90kg | BP: 145/95 | Diagnosis: Cardiovascular Disease | Medications: Atorvastatin 20mg daily",
  "Patient ID: 005 | Age: 50 | Weight: 85kg | BP: 135/85 | Diagnosis: None | Medications: None"
)

# Function to extract structured data from raw notes
extract_phenotype_data <- function(notes) {
  
  # Define regex patterns
  id_pattern <- "Patient ID:\\s*(\\d+)"
  age_pattern <- "Age:\\s*(\\d+)"
  weight_pattern <- "Weight:\\s*(\\d+)kg"
  bp_pattern <- "BP:\\s*(\\d+)/(\\d+)"
  diagnosis_pattern <- "Diagnosis:\\s*([a-zA-Z ]+)"
  med_pattern <- "Medications:\\s*([a-zA-Z0-9 ]+)"
  
  # Extract data using regex
  data <- data.frame(
    sample_id = str_extract(notes, id_pattern) %>% str_replace("Patient ID: ", "S"),
    age = as.numeric(str_extract(notes, age_pattern) %>% str_replace("Age: ", "")),
    weight_kg = as.numeric(str_extract(notes, weight_pattern) %>% str_replace("Weight: ", "")),
    systolic = as.numeric(str_extract(notes, bp_pattern) %>% str_extract("\\d+")),
    diastolic = as.numeric(str_extract(notes, bp_pattern) %>% str_extract("/\\d+") %>% str_replace("/", "")),
    diagnosis = str_extract(notes, diagnosis_pattern) %>% str_replace("Diagnosis: ", ""),
    medication = str_extract(notes, med_pattern) %>% str_replace("Medications: ", "")
  )
  
  # Handle missing values
  data <- data %>%
    mutate(
      age = ifelse(is.na(age), median(age, na.rm = TRUE), age),
      weight_kg = ifelse(is.na(weight_kg), mean(weight_kg, na.rm = TRUE), weight_kg),
      diagnosis = ifelse(diagnosis == "None", "Unknown", diagnosis),
      medication = ifelse(medication == "None", "Unknown", medication)
    )
  
  # Map diagnoses to ICD-10 codes
  diagnosis_mapping <- list(
    "Hypertension" = "I10",
    "Diabetes" = "E11",
    "Asthma" = "J45",
    "Cardiovascular Disease" = "I25",
    "Unknown" = "R69"
  )
  
  data$diagnosis_code <- unlist(diagnosis_mapping[data$diagnosis])
  
  # One-hot encoding for diagnosis
  unique_diagnoses <- unique(data$diagnosis)
  for (d in unique_diagnoses) {
    col_name <- paste0("diagnosis_", str_replace_all(d, " ", "_"))
    data[[col_name]] <- ifelse(data$diagnosis == d, 1, 0)
  }
  
  # One-hot encoding for medication
  unique_meds <- unique(data$medication)
  for (m in unique_meds) {
    col_name <- paste0("med_", str_replace_all(m, " ", "_"))
    data[[col_name]] <- ifelse(data$medication == m, 1, 0)
  }
  
  # Drop original categorical columns (optional)
  data <- data %>% select(-diagnosis, -medication)
  
  # Save to CSV
  write.csv(data, "phenotype_matrix.csv", row.names = FALSE)
  
  print("Phenotype matrix extracted and saved as 'phenotype_matrix.csv'.")
  
  return(data)
}

# Run the function
structured_data <- extract_phenotype_data(raw_notes)

# Preview data
head(structured_data)
