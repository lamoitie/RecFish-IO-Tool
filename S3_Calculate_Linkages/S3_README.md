# S3: MATLAB Script for Calculating Backward and Forward Linkages

## Overview

This MATLAB script calculates backward and forward linkages of recreational fisheries and other sectors in the economy using Input-Output (IO) analysis. It provides comprehensive measures of economic interdependence and identifies the relative importance of each sector in terms of its connections to other sectors.

## Features

- Calculates direct and indirect effects of changes in final demand
- Computes backward and forward linkages to identify key sectors
- Implements the hypothetical extraction method to estimate sectoral impacts
- Analyzes production effects on the economy when output of a sector increases
- Examines employment effects when output of a sector changes
- Evaluates supply effects using the Ghosh supply-side model
- Visualizes linkage results with bar charts
- Identifies and ranks sectors by their linkage strength

## Prerequisites

- MATLAB (version R2018a or later recommended)
- Excel file with IO data containing:
  - Demand-side IO table (for Leontief model)
  - Supply-side IO table (for Ghosh model)
  - Employment indicators for employment impact analysis

## File Structure Requirements

The script expects the following Excel sheets in the input file:

1. In `2018.xlsx` (or other specified input file):
   - `data_demand` - Demand-side transaction matrix and total output
   - `data_supply` - Supply-side transaction matrix and total input
   - `employment_index` - Employment indicators by sector

## Setup and Configuration

1. Open the script in MATLAB
2. Set the `base_dir` variable to your working directory path:
   ```matlab
   base_dir = 'Your_Path_Here'; % Replace with your actual path
   ```
3. Configure the input/output file paths if needed:
   ```matlab
   data_file = fullfile(base_dir, '2018.xlsx'); % Input data file
   result_file = data_file; % Results will be saved to the same file
   ```

## Running the Script

1. Ensure your Excel file with IO data is in place with the required sheets
2. Open MATLAB and navigate to the folder containing the script
3. Run the script by typing `S3_Calculate_Linkages` in the MATLAB command window or by clicking the "Run" button in the MATLAB Editor

## Workflow

The script executes the following steps:

1. **Data Loading**: Reads the IO tables and employment indicators from Excel
2. **Matrix Calculation**:
   - Calculates the direct requirements matrix (A) for the Leontief model
   - Computes the Leontief inverse matrix (L) = (I-A)^-1
3. **Linkage Analysis**:
   - Calculates backward linkages (demand-driven effects)
   - Calculates forward linkages (supply-driven effects)
4. **Impact Analysis**:
   - Analyzes production effects using the hypothetical extraction method
   - Examines employment impacts across sectors
   - Evaluates supply-chain effects using the Ghosh model
5. **Results Visualization**:
   - Creates bar charts of backward and forward linkages
   - Identifies and ranks sectors by linkage strength
6. **Output Storage**: Saves all results to Excel sheets

## Technical Details

### Backward and Forward Linkages

Backward and forward linkages are normalized indicators that show the relative strength of a sector's connections:

- **Backward Linkage**: Measures how much a sector depends on inputs from other sectors
  - Calculated as the normalized column sum of the Leontief inverse
  - BL_j = [Σᵢ L_ij / (Σᵢ Σⱼ L_ij / n)]

- **Forward Linkage**: Measures how much other sectors depend on inputs from this sector
  - Calculated as the normalized row sum of the Leontief inverse
  - FL_i = [Σⱼ L_ij / (Σᵢ Σⱼ L_ij / n)]

### Hypothetical Extraction Method

This method evaluates the importance of a sector by hypothetically removing it from the economy:

1. Remove the row and column corresponding to the target sector
2. Calculate the reduced Leontief inverse
3. Compute the impact on other sectors when the extracted sector's output changes

### Ghosh Supply-Side Model

The Ghosh model uses allocation coefficients (B) instead of technical coefficients (A):
- B_ij = Z_ij / X_i (allocation of output from sector i to sector j)
- Ghosh inverse = (I-B)^-1
- Measures how output changes propagate through the forward linkages

## Output Files

The script generates the following outputs in the Excel file:

1. `production_eff` sheet - Production effects from the extraction method
2. `employment_eff` sheet - Employment effects 
3. `supply_eff` sheet - Supply effects from the Ghosh model
4. `backward` sheet - Backward linkage coefficients for all sectors
5. `forward` sheet - Forward linkage coefficients for all sectors
6. `xnew` sheet - Direct and indirect effects of unit change in final demand

Additionally, a visualization file is created:
- `Linkages_Visualization.png` - Bar charts of backward and forward linkages

## Interpreting Results

- **Backward Linkage > 1**: Sector has above-average backward connections
- **Forward Linkage > 1**: Sector has above-average forward connections
- **Key Sectors**: Have both backward and forward linkages > 1
- **Production Effects**: Higher values indicate stronger impacts on other sectors
- **Employment Effects**: Higher values indicate stronger impacts on employment

## Adaptation for Other Years

The script can be adapted for other years by changing the input file:

```matlab
data_file = fullfile(base_dir, '2021.xlsx'); % For 2021 data
```

## Troubleshooting

- **Matrix Singularity**: If inverse calculation fails, check your IO table for structural issues
- **Inconsistent Results**: Ensure your data follows the same sector ordering in all sheets
- **Memory Issues**: For very large IO tables, consider sparse matrix techniques

## Citation

If you use this script in your research, please cite:

[Your Citation Format Here]

## License

[Your License Information Here]

## Contact

For questions or support, please contact [Your Contact Information] 