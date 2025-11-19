
################################################################################
# BREAST CANCER SURVIVAL DISPARITIES: RACE AND NEIGHBORHOOD INCOME ANALYSIS
# Author: Kamalakanta
# Date: November 19, 2025
# Institution: Duke University, REGAL Lab
################################################################################

# LOAD REQUIRED LIBRARIES ======================================================
library(tidyverse)
library(survival)
library(survminer)
library(broom)

# IMPORT DATA ==================================================================
# Note: Replace with your actual file path
# new_survival <- read_csv("path/to/your/seer_data.csv")

# DATA PREPARATION =============================================================

# Step 1: Filter to female breast cancer cases
breast_cancer <- new_survival %>%
  filter(grepl("Breast", `Primary Site - labeled`, ignore.case = TRUE),
         Sex == "Female")

cat("Total breast cancer cases:", nrow(breast_cancer), "\n")

# Step 2: Create income categories
breast_cancer_clean <- breast_cancer %>%
  mutate(
    income_category = case_when(
      `Median household income inflation adj to 2023` %in% 
        c("< $40,000", "$40,000 - $44,999", "$45,000 - $49,999", 
          "$50,000 - $54,999", "$55,000 - $59,999") ~ "Low Income (<$60K)",
      `Median household income inflation adj to 2023` %in% 
        c("$60,000 - $64,999", "$65,000 - $69,999", "$70,000 - $74,999",
          "$75,000 - $79,999", "$80,000 - $84,999", "$85,000 - $89,999") ~ "Medium Income ($60K-$90K)",
      `Median household income inflation adj to 2023` %in% 
        c("$90,000 - $94,999", "$95,000 - $99,999", "$100,000 - $109,999",
          "$110,000 - $119,999", "$120,000+") ~ "High Income ($90K+)",
      TRUE ~ "Unknown"
    )
  )

# Step 3: Clean survival variables
breast_cancer_clean <- breast_cancer_clean %>%
  mutate(
    surv_months_numeric = as.numeric(`Survival months`),
    surv_years = surv_months_numeric / 12,
    event = ifelse(`Vital status recode (study cutoff used)` == "Dead", 1, 0)
  )

# Step 4: Create clean race variable
breast_cancer_clean <- breast_cancer_clean %>%
  mutate(
    race_clean = case_when(
      `Race recode (White, Black, Other)` == "White" ~ "White",
      `Race recode (White, Black, Other)` == "Black" ~ "Black",
      TRUE ~ "Other"
    )
  )

# Step 5: Remove missing data
breast_final <- breast_cancer_clean %>%
  filter(!is.na(surv_months_numeric),
         income_category != "Unknown")

cat("Final analytic sample:", nrow(breast_final), "\n")

# DESCRIPTIVE STATISTICS =======================================================

# Overall distribution
table(breast_final$income_category, breast_final$event)
table(breast_final$race_clean, breast_final$income_category)

# Summary statistics by income
income_summary <- breast_final %>%
  group_by(income_category) %>%
  summarise(
    N = n(),
    Deaths = sum(event),
    Mortality_Percent = round(mean(event) * 100, 1),
    Median_Survival_Years = round(median(surv_years), 1),
    Mean_Survival_Years = round(mean(surv_years), 1)
  )
print(income_summary)

# SURVIVAL ANALYSIS - BY INCOME ================================================

# Create survival object
surv_object <- Surv(time = breast_final$surv_years, 
                     event = breast_final$event)

# Kaplan-Meier by income
km_income <- survfit(surv_object ~ income_category, 
                      data = breast_final)

# Plot
ggsurvplot(km_income,
           data = breast_final,
           pval = TRUE,
           conf.int = TRUE,
           risk.table = TRUE,
           title = "Breast Cancer Survival by Neighborhood Income",
           xlab = "Time (Years)",
           ylab = "Survival Probability",
           legend.title = "Income Category",
           palette = c("#00AFBB", "#E7B800", "#FC4E07"))

ggsave("survival_by_income.png", width = 12, height = 8, dpi = 300)

# SURVIVAL ANALYSIS - BY RACE ==================================================

km_race <- survfit(Surv(surv_years, event) ~ race_clean, 
                   data = breast_final)

ggsurvplot(km_race,
           data = breast_final,
           pval = TRUE,
           conf.int = TRUE,
           risk.table = TRUE,
           title = "Breast Cancer Survival by Race/Ethnicity",
           xlab = "Time (Years)",
           ylab = "Survival Probability",
           legend.title = "Race/Ethnicity",
           palette = c("black", "#E7B800", "#00AFBB"))

ggsave("survival_by_race.png", width = 12, height = 8, dpi = 300)

# INTERSECTIONAL ANALYSIS - RACE × INCOME ======================================

# Focus on Black vs White
breast_bw <- breast_final %>%
  filter(race_clean %in% c("Black", "White")) %>%
  mutate(
    race_income_combined = paste0(race_clean, " - ", income_category)
  )

# KM by race-income combination
km_combined <- survfit(Surv(surv_years, event) ~ race_income_combined, 
                       data = breast_bw)

ggsurvplot(km_combined,
           data = breast_bw,
           pval = TRUE,
           title = "Breast Cancer Survival: Race × Income Intersectionality",
           xlab = "Time (Years)",
           ylab = "Survival Probability",
           legend.title = "Race-Income Group",
           palette = "jco")

ggsave("survival_race_income_combined.png", width = 14, height = 8, dpi = 300)

# COX REGRESSION MODELS ========================================================

# Set reference categories
breast_bw$race_clean <- factor(breast_bw$race_clean, 
                               levels = c("White", "Black"))
breast_bw$income_category <- factor(breast_bw$income_category,
                                    levels = c("High Income ($90K+)", 
                                              "Medium Income ($60K-$90K)",
                                              "Low Income (<$60K)"))

# Model 1: Race only
cox_race <- coxph(Surv(surv_years, event) ~ race_clean, 
                  data = breast_bw)
summary(cox_race)

# Model 2: Income only
cox_income <- coxph(Surv(surv_years, event) ~ income_category, 
                    data = breast_bw)
summary(cox_income)

# Model 3: Race + Income (MAIN MODEL)
cox_both <- coxph(Surv(surv_years, event) ~ race_clean + income_category, 
                  data = breast_bw)
summary(cox_both)

# Model 4: Race × Income interaction
cox_interaction <- coxph(Surv(surv_years, event) ~ race_clean * income_category, 
                         data = breast_bw)
summary(cox_interaction)

# EXPORT RESULTS ===============================================================

# Cox model results table
results_table <- tidy(cox_both, exponentiate = TRUE, conf.int = TRUE) %>%
  mutate(
    HR = round(estimate, 3),
    Lower_CI = round(conf.low, 3),
    Upper_CI = round(conf.high, 3),
    P_value = ifelse(p.value < 0.001, "<0.001", round(p.value, 3))
  ) %>%
  select(term, HR, Lower_CI, Upper_CI, P_value)

write.csv(results_table, "cox_model_results.csv", row.names = FALSE)

# Descriptive statistics table
table1_summary <- breast_bw %>%
  group_by(race_clean, income_category) %>%
  summarise(
    N = n(),
    Deaths = sum(event),
    Mortality_Percent = round(mean(event) * 100, 1),
    Median_Survival_Years = round(median(surv_years), 1),
    .groups = "drop"
  ) %>%
  arrange(race_clean, income_category)

write.csv(table1_summary, "table1_descriptive_stats.csv", row.names = FALSE)

cat("\n✅ ANALYSIS COMPLETE!\n")
cat("Files created:\n")
cat("  - survival_by_income.png\n")
cat("  - survival_by_race.png\n")
cat("  - survival_race_income_combined.png\n")
cat("  - cox_model_results.csv\n")
cat("  - table1_descriptive_stats.csv\n")

################################################################################
# END OF SCRIPT
################################################################################

