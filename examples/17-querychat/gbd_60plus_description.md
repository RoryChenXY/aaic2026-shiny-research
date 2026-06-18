This dataset contains the Global Burden of Disease Data on Incidence and Prevalence of Alzheimer's Disease and other dementias (ADOD) among people aged 60 years and older worldwide in 2023.

## Variables

| Variable | Description | Example values | Data type |
|---|---|---|---|
| `iso3` | Three-letter ISO country code | `AUS`, `CHN`, `USA` | Character |
| `country` | Country name | `Australia`, `China`, `United States of America` | Character |
| `income_grp` | Country income group | `1. High income`, `4. Lower middle income` | Categorical |
| `continent` | Continent or broad geographic region | `Asia`, `Africa`, `Europe` | Categorical |
| `measure` | Type of epidemiological measure reported | `Prevalence`, `Incidence` | Categorical |
| `sex` | Sex category for the estimate | `Male`, `Female`, `Both` | Categorical |
| `metric` | Unit or scale of the estimate | `Number`, `Percent` | Categorical |
| `val` | Reported numeric estimate for the selected measure, sex, and metric | `1250000`, `4.7` | Numeric |

## Query guidance

When answering questions, use only the variables available in this dataset.

## Limitations

This dataset is suitable for descriptive exploration and dashboard filtering.

Do not:

- provide medical advice
- infer causality from these descriptive estimates
- invent variables, statistics, uncertainty intervals, time trends, or study findings not present in the dataset
- describe results as statistically significant unless significance information is explicitly provided
