# S2: MATLAB Script for Updating and Balancing IO Table

## Overview

This MATLAB script implements the RAS method for updating and balancing Input-Output (IO) tables. It takes an initial IO coefficient matrix (from a base year) and adjusts it to match target row and column sums for a new year, maintaining the structural characteristics of the economic system while ensuring accounting balance.

## Features

- Implements the iterative RAS biproportional adjustment method
- Balances IO coefficient matrices to meet new year constraints
- Provides error tracking and convergence monitoring
- Generates a balanced coefficient matrix for further economic analysis
- Visualizes convergence performance with error plots

## Prerequisites

- MATLAB (version R2018a or later recommended)
- Excel file with IO data with the following contents:
  - Base year intermediate flow matrix
  - Base year total output
  - Target year final demand
  - Target year value added
  - Target year total output

## File Structure Requirements

The script expects the following Excel sheet:

1. In `data_2019.xlsx` (or other specified input file):
   - `RAS` sheet containing all required matrices and vectors

## Setup and Configuration

1. Open the script in MATLAB
2. Set the `base_dir` variable to your working directory path:
   ```matlab
   base_dir = 'Your_Path_Here'; % Replace with your actual path
   ```
3. Configure the input/output file paths if needed:
   ```matlab
   data_file = fullfile(base_dir, 'data_2019.xlsx'); % Input data file
   result_file = fullfile(base_dir, 'result_2019.xlsx'); % Output result file
   ```
4. Adjust the error tolerance if needed:
   ```matlab
   error_tolerance = 0.0027;
   ```

## Running the Script

1. Ensure your Excel file with IO data is in place
2. Open MATLAB and navigate to the folder containing the script
3. Run the script by typing `S2_Update_Balance_IO_Table` in the MATLAB command window or by clicking the "Run" button in the MATLAB Editor

## Workflow

The script executes the following steps:

1. **Data Loading**: Reads the IO data from the specified Excel file
2. **Initialization**: Calculates the initial coefficient matrix and sets up target constraints
3. **RAS Iteration**:
   - Row scaling (r-adjustment): Adjusts rows to match target row sums
   - Column scaling (s-adjustment): Adjusts columns to match target column sums
   - Error calculation: Computes convergence error
   - Convergence check: Determines if the solution is acceptable
4. **Output**: Saves the final balanced coefficient matrix to an Excel file and generates a convergence plot

## Technical Details

### The RAS Method

The RAS method is a biproportional adjustment technique that iteratively scales rows and columns of a matrix to match predefined row and column sums. The process consists of:

1. Starting with an initial coefficient matrix A₀ and target year output X₁
2. Multiplying to get intermediate flows: Z₁⁰ = A₀ * diag(X₁)
3. Row scaling: Z₁ʳ = r * Z₁⁰, where r is calculated to match target row sums
4. Column scaling: Z₁ʳˢ = Z₁ʳ * s, where s is calculated to match target column sums
5. Repeating steps 3-4 until convergence
6. Converting back to coefficient form: A₁ = Z₁ * diag(X₁)⁻¹

### Error Calculation

The convergence error is calculated as:
```
error = Σᵢ [ (u₁ᵀᵢ - u₁ᵢ)² / X₁ᵢ² + (v₁ᵀᵢ - v₁ᵢ)² / X₁ᵢ² ]
```
where:
- u₁ᵀᵢ and v₁ᵀᵢ are the current row and column sums
- u₁ᵢ and v₁ᵢ are the target row and column sums
- X₁ᵢ is the target year output

## Output Files

The script generates two output files:

1. `result_2019.xlsx` - Contains the final balanced coefficient matrix:
   - `A_matrix` sheet: The balanced direct requirements matrix

2. `RAS_convergence.png` - A plot showing the convergence error at each iteration

## Adaptation for Other Years

The script can be adapted for other years by changing the input file and parameters:

1. Create a new data file following the same structure as `data_2019.xlsx`
2. Update the file paths in the script:
   ```matlab
   data_file = fullfile(base_dir, 'data_2021.xlsx'); % For 2021 data
   result_file = fullfile(base_dir, 'result_2021.xlsx'); % For 2021 results
   ```

## Troubleshooting

- **Convergence Issues**: If the algorithm doesn't converge, try increasing the error tolerance or the maximum number of iterations
- **Data Format Problems**: Ensure the Excel file has the correct structure and all required data
- **NaN or Inf Values**: Check for division by zero, especially in the scaling factors

## Citation

If you use this script in your research, please cite:

[Your Citation Format Here]

## License

[Your License Information Here]

## Contact

For questions or support, please contact [Your Contact Information] 