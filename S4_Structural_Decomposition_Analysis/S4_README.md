# S4: MATLAB Script for Structural Decomposition Analysis

## Overview

This MATLAB script performs Structural Decomposition Analysis (SDA) to identify and quantify the drivers of changes in recreational fisheries between two time periods. SDA is a powerful technique that decomposes the total change in an economic variable into contributions from various factors, allowing researchers to understand the relative importance of different drivers of change.

## Features

- Decomposes changes in recreational fisheries into five key driving factors
- Implements a complete D&L (Dietzenbacher & Los) decomposition approach
- Quantifies the contribution of each factor to the total change
- Generates visualizations of factor contributions
- Ranks factors by their importance to identify main drivers
- Produces detailed numerical results for further analysis

## Prerequisites

- MATLAB (version R2018a or later recommended)
- Excel file with the following data for two time periods:
  - Population or economic scale indicators
  - Resource/environmental intensity by sector
  - Leontief inverse matrices (production structure)
  - Final demand structure matrices
  - Final demand source vectors

## File Structure Requirements

The script expects the following Excel sheets in the input file:

1. In `SDA_data.xlsx` (or other specified input file):
   - `Population` - Population/scale data for both periods
   - `Intensity` - Sectoral intensity data for both periods
   - `Leontief` - Leontief inverse matrices for both periods
   - `FinalDemand` - Final demand structure for both periods
   - `FinalDemandSource` - Final demand source data for both periods

## Setup and Configuration

1. Open the script in MATLAB
2. Set the `base_dir` variable to your working directory path:
   ```matlab
   base_dir = 'Your_Path_Here'; % Replace with your actual path
   ```
3. Configure the input/output file paths if needed:
   ```matlab
   data_file = fullfile(base_dir, 'SDA_data.xlsx'); % Input data file
   result_file = fullfile(base_dir, 'SDA_results.xlsx'); % Output results file
   ```
4. Ensure the Excel ranges in the script match your data format:
   ```matlab
   P0 = readmatrix(data_file, 'Sheet', 'Population', 'Range', 'B2');
   ```

## Running the Script

1. Ensure your Excel file with all required data is in place
2. Open MATLAB and navigate to the folder containing the script
3. Run the script by typing `S4_Structural_Decomposition_Analysis` in the MATLAB command window or by clicking the "Run" button in the MATLAB Editor

## Workflow

The script executes the following steps:

1. **Data Loading**: Reads all necessary data from the Excel file for both time periods
2. **Calculation of Changes**: Computes the differences between the two periods for each factor
3. **SDA Decomposition**: Uses the D&L approach to calculate the contribution of each factor
   - Intensity changes (DE)
   - Production structure changes (DL)
   - Final demand structure changes (DFS)
   - Final demand source changes (DFL)
   - Population/scale changes (DP)
4. **Results Analysis**: Aggregates results, calculates percentages, and identifies main drivers
5. **Visualization**: Creates bar charts showing the relative contribution of each factor
6. **Output Generation**: Saves numerical results to Excel and visualizations as image files

## Technical Details

### The D&L Decomposition Approach

The script uses the full D&L decomposition approach, which considers all possible first-order approximations of the total differential. For a decomposition with 5 factors, there are 5! (120) possible decomposition forms. The script calculates all forms and takes their average to obtain a unique decomposition.

The decomposition formula has the general form:
```
ΔY = f(ΔP, ΔE, ΔL, ΔFS, ΔFL)
```
where:
- ΔY is the total change
- ΔP is the change in population/scale
- ΔE is the change in resource/environmental intensity
- ΔL is the change in production structure (Leontief inverse)
- ΔFS is the change in final demand structure
- ΔFL is the change in final demand source

### Interpretation of Results

- Positive values indicate factors that contribute to an increase in the variable
- Negative values indicate factors that contribute to a decrease
- The magnitude of the values indicates the strength of the contribution
- Percentage contributions show the relative importance of each factor

## Output Files

The script generates the following outputs:

1. `SDA_results.xlsx` - Contains the detailed SDA results:
   - `SDA_Results` sheet: Numerical contribution of each factor

2. `SDA_Contributions.png` - A bar chart showing the percentage contribution of each factor to total change

## Adaptation for Other Research

The script can be adapted for other research questions by:

1. Modifying the factors considered in the decomposition
2. Changing the data sources and ranges in the Excel file
3. Adjusting the decomposition formula to reflect different relationships
4. Customizing the visualization to highlight specific factors of interest

## Troubleshooting

- **Matrix Dimension Errors**: Ensure all matrices have consistent dimensions
- **Excel Range Issues**: Verify that the specified ranges in the readmatrix commands match your data
- **NaN or Inf Results**: Check for division by zero or missing data in the input file
- **Interpretation Challenges**: For small total changes, percentage contributions may be misleading

## Citation

If you use this script in your research, please cite:

[Your Citation Format Here]

## License

[Your License Information Here]

## Contact

For questions or support, please contact [Your Contact Information] 