# AAIC 2026 Shiny Research Workshop

This repository contains materials for the **AAIC 2026 ISTAART Immersives Workshop**:
**“Shiny Your Research: Interactive Dashboards in R.”**

It includes slides, example Shiny apps, exercises, solution files, and supporting datasets for dementia research use cases.

## Before the workshop
1. Install R: Download and install the latest version of R: https://cran.r-project.org/  
2. Install R Studio: Download and install the latest version of RStudio Desktop: https://posit.co/download/rstudio-desktop/ 
3. Install R packages: Run `/setup/setup.R` to install required packages.
4. Download or clone this repository 
5. Reach out if you have any issues
6. Slides:  <https://rorychenxy.github.io/aaic2026-shiny-research/aaic-shiny-research.html>
7. Create a shinyapps.io account, refer to <https://shiny.posit.co/r/articles/share/shinyapps/>


## Repository structure (relevant to participants)

- [/data](/data) – Data preparation scripts and datasets used in examples
- [/examples](/examples) – Live coding examples, hands-on exercises, and solutions
- [/examples/exercises](/examples/exercises) - Hands-on exercises for user to complete
- [/examples/solutions](/examples/solutions) - Solutions for hands-on exercises
- [setup.R](/setup/setup.R) – Environment setup script for required R packages
- [/resources](/resources) - Resources for post-workshop 

## Data Acknowledgement

This workshop uses data from:
- the Global Burden of Disease Study, accessed through the Institute for Health Metrics and Evaluation (IHME) GBD Results Tool. <https://www.healthdata.org/data-tools-practices/interactive-visuals/gbd-results>
- `ad_data` from the {modeldata} package: <https://modeldata.tidymodels.org/reference/ad_data.html>
- `OASIS_long_tbl_df` from the {NeuroDataSets} package: <https://www.rdocumentation.org/packages/NeuroDataSets/versions/0.3.0/topics/OASIS_long_tbl_df>
- `countries50` from the {rnaturalearthdata} package: <https://ropensci.r-universe.dev/rnaturalearthdata/doc/manual.html#countries>

All data are used for non-commercial educational purposes.

## Funding Acknowledgement
This workshop is supported by grants from the National Institute on Aging/ National Institute of Health (NIA/NIH) [1RF1AG057531-01] and an AAIC 2026 Conference Fellowship. 

## License

This project is distributed under the terms of the MIT licence; please refer to the [LICENSE](./LICENSE) file.
