# Breast Cancer Survival Disparities: Race and Neighborhood Income Analysis

**Author:** Kamalakanta  
**Institution:** Duke University, MS Population Health Sciences  
**Lab:** REGAL Lab (Research to Eliminate Global Cancer Disparities)  
**Date:** November 2025

---

## Project Overview

This project examines **racial and socioeconomic disparities in breast cancer survival** using SEER cancer registry data (1990–2023). The analysis demonstrates that both race and neighborhood income independently predict survival outcomes, with disparities persisting even after rigorous statistical adjustment for age and diagnosis era.

**Research Question:**  
Do racial disparities in breast cancer survival persist after accounting for neighborhood income levels and key confounders?  
Do these disparities widen when examining *breast-cancer–specific mortality* rather than all-cause mortality?

---

## Key Findings

### 1. **Overall Survival (All-Cause Mortality) – Fully Adjusted Cox Model**

After controlling for age and diagnosis era:

| Variable | Hazard Ratio | 95% CI | Interpretation |
|----------|-------------|---------|----------------|
| **Black vs White** | **1.54** | 1.51–1.56 | **54% higher all-cause mortality** |
| **Low Income (<$60K)** | **1.25** | 1.23–1.27 | **25% higher mortality** |
| **Medium Income ($60K–$90K)** | **1.09** | 1.08–1.10 | **9% higher mortality** |

*All p < 0.0001*

---

### 2. **Breast-Cancer–Specific Survival – Fully Adjusted Cox Model**

When focusing exclusively on deaths attributable to breast cancer:

| Variable | Hazard Ratio | 95% CI | Interpretation |
|----------|-------------|---------|----------------|
| **Black vs White** | **1.78** | 1.74–1.81 | **78% higher breast-cancer–specific mortality** |
| **Low Income (<$60K)** | **1.35** | 1.32–1.39 | **35% higher cancer-specific mortality** |
| **Medium Income ($60K–$90K)** | **1.10** | 1.09–1.11 | **10% higher cancer-specific mortality** |

**Key Insight:**  
**Racial disparities are substantially larger for breast-cancer–specific mortality than for all-cause mortality**, indicating that inequities likely arise from **diagnosis, treatment, and disease progression**, not just non-cancer comorbidities.

---

## Critical Findings

1. **Racial disparity increased after age adjustment**  
   – from 20% to 54% for all-cause mortality  
   – and to **78%** for breast-cancer–specific mortality.

2. **Black patients face worse survival despite being diagnosed younger**, indicating more aggressive disease or delays in treatment access.

3. **Breast-cancer–specific survival curves show persistent separation** between Black and White patients over 30 years—even when holding income, age group, and diagnosis era constant.

4. **Income gradient remains strong and independent:**  
   – Low-income neighborhoods show worse outcomes even within the same race group.

5. **Intersectionality matters:**  
   – Among high-income neighborhoods, median survival was **5.7 years** for Black patients vs **7.9 years** for White patients.

---

## Data & Methods

### Data Source
- **SEER Database** (Surveillance, Epidemiology, and End Results Program)
- **Sample:** 507,574 Black and White female breast cancer patients
- **Period:** Diagnosed 1990–2023
- **Coverage:** ~48% of the U.S. population

### Outcomes
- **Overall survival** (all-cause mortality)
- **Breast-cancer–specific survival**  
  – Derived from SEER cause-specific death classification  
  – Other-cause deaths censored

### Exposures
- **Race** (Black vs White)
- **Neighborhood median household income** (inflation-adjusted to 2023)

### Confounders
- Age at diagnosis  
- Diagnosis era (1990–1999, 2000–2009, 2010–2023)

### Statistical Analysis
- Kaplan–Meier curves with log-rank tests
- Cause-specific Cox proportional hazards models
- Software: R 4.5.0  
- Packages: tidyverse, survival, survminer, broom

---

## Results Summary (All-Cause Mortality)

| Race-Income Group | N | Deaths | Mortality % | Median Survival (Years) |
|-------------------|-------|--------|-------------|------------------------|
| White – High Income | 212,538 | 84,646 | 39.8% | 7.9 |
| White – Medium Income | 223,499 | 97,546 | 43.6% | 8.2 |
| White – Low Income | 26,706 | 13,895 | 52.0% | 7.8 |
| Black – High Income | 17,957 | 7,625 | 42.5% | 5.7 |
| Black – Medium Income | 24,864 | 10,510 | 42.3% | 6.2 |
| Black – Low Income | 2,010 | 524 | 26.1% | 4.4 |

---

## Repository Contents
