# Asymptomatic SARS-CoV-2 Infection Correction — Code Repository

This repository accompanies the manuscript:

**"Accurate estimation of the proportion of asymptomatic SARS-CoV-2 infections from population-based surveys"** 
*Tiwari et al.*

---

## 🧱 Repository Structure

| Folder | Description |
|--------|--------------|
| `data/` | Raw and derived datasets used in all analyses. |
| `scripts/` | Modular, reusable R scripts defining mathematical functions, data preprocessing, and plotting utilities. |
| `analysis/` | R Markdown notebooks for each figure in the main and supplementary texts. |
| `outputs/` | Generated figures, tables, and intermediate CSVs. |
| `renv.lock` | Snapshot of R environment for exact reproducibility. |

---

## 📊 Reproducing All Figures

1. Install dependencies:

   ```r
   install.packages(c("dplyr", "ggplot2", "purrr", "knitr", "rmarkdown"))

