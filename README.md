
# Breast Cancer Survival Disparities: Race and Neighborhood Income Analysis

**Author:** Kamalakanta  
**Institution:** Duke University, MS Population Health Sciences  
**Lab:** REGAL Lab (Research to Eliminate Global Cancer Disparities)  
**Date:** November 2025

---

## Project Overview

This project examines **racial and socioeconomic disparities in breast cancer survival** using SEER cancer registry data (1990-2023). The analysis demonstrates that both race and neighborhood income independently predict survival outcomes, with disparities persisting even after rigorous statistical adjustment for age and diagnosis era.

**Research Question:** Do racial disparities in breast cancer survival persist after accounting for neighborhood income levels and key confounders?

---

## Key Findings

### Primary Results (Fully Adjusted Cox Models)

After controlling for age and diagnosis era:

| Variable | Hazard Ratio | 95% CI | Interpretation |
|----------|-------------|---------|----------------|
| **Black vs White** | 1.54 | 1.51-1.56 | **54% higher mortality risk** |
| **Low Income (<$60K)** | 1.25 | 1.23-1.27 | **25% higher mortality risk** |
| **Medium Income ($60K-$90K)** | 1.09 | 1.08-1.10 | **9% higher mortality risk** |

*All p < 0.0001*

### Critical Findings

1. **Racial disparity INCREASED after age adjustment** (from 20% to 54%), revealing that Black patients face worse outcomes despite being diagnosed younger on average.

2. **Intersectionality matters:** Black patients in high-income neighborhoods had median survival of **5.7 years** vs **7.9 years** for White patients in the same neighborhoods.

3. **Disparities persist across ALL age groups:** Stratified analyses show Black-White survival gaps exist in patients under 45, 45-59, 60-74, and 75+ years.

4. **Income gradient independent of race:** Even among White patients alone, low-income neighborhoods showed significantly worse survival.

---

## Data & Methods

### Data Source
- **SEER Database:** Surveillance, Epidemiology, and End Results Program
- **Sample:** 507,574 Black and White female breast cancer patients
- **Time Period:** 1990-2023 diagnoses
- **Geographic Coverage:** SEER registries (~48% of US population)

### Variables
- **Outcome:** Overall survival (time to death from any cause)
- **Exposures:** 
  - Race/ethnicity (Black vs White)
  - Neighborhood median household income (census tract-level, inflation-adjusted to 2023)
- **Confounders:** Age at diagnosis, year of diagnosis

### Statistical Analysis
- **Survival curves:** Kaplan-Meier with log-rank tests
- **Regression:** Cox proportional hazards models
- **Software:** R version 4.5.0
- **Packages:** tidyverse, survival, survminer, broom

### Model Specifications

**Model 1 (Unadjusted):** Race + Income only  
**Model 2 (Age-adjusted):** Race + Income + Age group  
**Model 3 (Fully adjusted):** Race + Income + Age group + Diagnosis era ← **PRIMARY MODEL**

---

## Results Summary

### Descriptive Statistics

| Race-Income Group | N | Deaths | Mortality % | Median Survival (Years) |
|-------------------|-------|--------|-------------|------------------------|
| White - High Income | 212,538 | 84,646 | 39.8% | 7.9 |
| White - Medium Income | 223,499 | 97,546 | 43.6% | 8.2 |
| White - Low Income | 26,706 | 13,895 | 52.0% | 7.8 |
| Black - High Income | 17,957 | 7,625 | 42.5% | 5.7 |
| Black - Medium Income | 24,864 | 10,510 | 42.3% | 6.2 |
| Black - Low Income | 2,010 | 524 | 26.1% | 4.4 |

---

## Repository Contents
```
breast-cancer-disparities/
│
├── README.md                           # This file
│
├── code/
│   └── breast_cancer_analysis.R        # Complete R analysis script
│
├── figures/
│   ├── breast_cancer_survival_by_income.png       # KM: Income groups
│   ├── survival_by_race.png                       # KM: Race/ethnicity
│   ├── survival_race_income_combined.png          # KM: Race × Income
│   ├── survival_age6074_race_income.png          # KM: Ages 60-74 stratified
│   └── survival_race_by_age_all.png              # KM: All age groups
│
├── results/
│   ├── cox_models_comparison.csv              # All 3 Cox models
│   ├── table1_descriptive_stats.csv           # Patient characteristics
│   └── cox_model_results.csv                  # Main model (Model 3)
│
└── data/
    └── README.md                              # Data access instructions
```

---

## Clinical and Public Health Implications

1. **Persistent racial inequities:** 54% higher mortality for Black patients cannot be explained by neighborhood income, age, or diagnosis era alone.

2. **Age paradox:** Black patients are diagnosed younger but still experience worse outcomes, suggesting accelerated disease progression or differential access to optimal treatment.

3. **Neighborhood effects:** 25% mortality difference between lowest and highest income areas demonstrates that place matters for cancer survival.

4. **Intersectionality:** Combined effects of race and socioeconomic status create compounding disadvantages.

5. **Policy implications:** Interventions must address both economic barriers AND race-specific structural inequities in cancer care delivery.

---

## Limitations

1. **Ecological fallacy:** Neighborhood income is a proxy; individual-level socioeconomic data unavailable in SEER
2. **Unmeasured confounders:** No data on stage at diagnosis, tumor subtypes (pre-2010), treatment received, insurance status, or comorbidities
3. **Geographic identifiers:** County/census tract codes not available in public SEER data, preventing calculation of ICE (Index of Concentration at the Extremes) measures
4. **Generalizability:** SEER covers ~48% of US population; may not represent all regions

---

## Future Directions

1. Link to census tract-level ICE measures using restricted-access geocoded SEER data
2. Incorporate stage, receptor status (ER/PR/HER2), and treatment variables
3. Examine cause-specific survival (cancer-specific mortality)
4. Investigate healthcare access and quality of care as mediating factors
5. Analyze time trends: Are disparities narrowing or widening over decades?
6. Explore biological and treatment-related contributors to racial disparities

---

## Reproducibility

All analysis code, data cleaning steps, and visualization scripts are provided in `breast_cancer_analysis.R`. The analysis is fully reproducible given access to SEER data (available through SEER*Stat after data use agreement).

**Software Requirements:**
- R ≥ 4.0.0
- tidyverse, survival, survminer, broom packages

---

## Citation

If you use this analysis or code, please cite:
```
Kamalakanta (2025). Breast Cancer Survival Disparities: Race and Neighborhood 
Income Analysis Using SEER Data (1990-2023). GitHub repository: 
[your-github-username]/breast-cancer-disparities
```

---

## Contact

**Kamalakanta**  
MS Population Health Sciences  
Duke University  
REGAL Lab (Research to Eliminate Global Cancer Disparities)

---

## Acknowledgments

- SEER Program, National Cancer Institute
- Prof. Tomi Akinyemiju, REGAL Lab Director
- Duke University Population Health Sciences

---

**License:** MIT License (or appropriate for your use)

**Data Disclaimer:** This analysis uses SEER data. SEER data use requires agreement to specific terms. Original data files are not included in this repository.

