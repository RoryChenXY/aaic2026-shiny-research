# AAIC 2026 Shiny Research Workshop

This repository contains materials for the **AAIC 2026 ISTAART Immersives Workshop**:
**“Shiny Your Research: Interactive Dashboards in R.”**

It includes slides, example Shiny apps, exercises, solution files, and supporting datasets for dementia research use cases.

## Repository structure

- `/slides` – Workshop slides (Quarto source and rendered HTML)
- `/examples` – Live coding examples, hands-on exercises, and solutions
- `/data` – Data preparation scripts and datasets used in examples
- `/setup` – Environment setup script for required R packages
- `/resources` – Workshop planning and supporting documents
- `/images` – Image assets used in materials
- `/docs` – Additional documentation assets

## Prerequisites

- R
- RStudio
- Basic familiarity with R

## Setup

1. Open the repository as an RStudio project.
2. Run `/setup/setup.R` to install required packages.
3. (Optional, for LLM demos) Add your API key to `.Renviron` using `usethis::edit_r_environ()`.

> Do not commit API keys or other secrets to this repository.

## Running examples

Most workshop examples are standalone Shiny scripts in `/examples`.
Open any `.R` file in RStudio and click **Run App** (or run it in the console).

Example files include:

- `examples/01-helloworld.R`
- `examples/02-helloname.R`
- `examples/03-helloshiny.R`
- `examples/11-modhistogram/app.R`
- `examples/17-querychat/17-querychat.R`

## License

This project is distributed under the terms of the [LICENSE](./LICENSE) file.
