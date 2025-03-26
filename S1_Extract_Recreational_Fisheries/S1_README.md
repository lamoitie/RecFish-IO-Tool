# S1: MATLAB Script for Extracting Recreational Fisheries from Related Sectors

## Overview

This MATLAB script combines four separate processes into a single workflow for extracting recreational fisheries data from related economic sectors in an Input-Output (IO) table. The script handles both input and output directions and includes sector merging functionality.

## Features

- Extracts recreational fisheries components from input direction (purchases by recreational fisheries)
- Extracts recreational fisheries components from output direction (sales of recreational fisheries)
- Merges sectors in the input direction according to predefined industry groups
- Merges sectors in the output direction according to predefined industry groups
- Produces multiple output files with detailed results

## Prerequisites

- MATLAB (version R2018a or later recommended)
- Excel files with input-output data:
  - `stripping progress_2018.xlsx` - Original IO table data
  - `merge_sectors.xlsx` - Template for sector merging (will be created if it doesn't exist)

## File Structure Requirements

The script expects the following Excel sheets:

1. In `stripping progress_2018.xlsx`:
   - `step1_materials` - Input direction data
   - `step2_materials` - Output direction data

2. In `merge_sectors.xlsx`:
   - `original` - Data for input direction merging
   - `second` - Data for output direction merging

## Setup and Configuration

1. Open the script in MATLAB
2. Set the `base_dir` variable to your working directory path:
   ```matlab
   base_dir = 'Your_Path_Here'; % Replace with your actual path
   ```
3. Configure the input/output file paths if needed:
   ```matlab
   original_data_file = fullfile(base_dir, 'stripping progress_2018.xlsx');
   input_output_file = fullfile(base_dir, 'stripping progress_2018_i.xlsx');
   output_output_file = fullfile(base_dir, 'stripping progress_2018_o.xlsx');
   merge_sectors_file = fullfile(base_dir, 'merge_sectors.xlsx');
   ```
4. Control which parts of the workflow to run using the boolean flags:
   ```matlab
   run_input_stripping = true;
   run_output_stripping = true;
   run_input_merge = true;
   run_output_merge = true;
   ```

## Running the Script

1. Ensure all prerequisite files are in place
2. Open MATLAB and navigate to the folder containing the script
3. Run the script by typing `S1_Extract_Recreational_Fisheries` in the MATLAB command window or by clicking the "Run" button in the MATLAB Editor

## Workflow

The script executes the following steps in order:

1. **Input Stripping**: Extracts recreational fisheries components from related sectors in the input direction
   - Uses predefined coefficients to determine how much of each sector's input is attributable to recreational fisheries
   - Creates a new Excel file with three sheets: remaining data, extracted RF data, and value-added data

2. **Output Stripping**: Extracts recreational fisheries components from related sectors in the output direction
   - Similar to input stripping but focuses on the output/sales of sectors
   - Creates a new Excel file with four sheets: remaining data, extracted RF data, final use data, and import data

3. **Input Merging**: Consolidates sectors in the input direction according to industry classifications
   - Combines detailed sectors into broader industry groups
   - Writes results to the merge_sectors.xlsx file

4. **Output Merging**: Consolidates sectors in the output direction according to industry classifications
   - Similar to input merging but for output/sales data
   - Writes results to the merge_sectors.xlsx file

## Output Files

The script generates several output files:

1. `stripping progress_2018_i.xlsx` - Results from input direction stripping:
   - `Input_Remaining_Data` - Original data after removing RF components
   - `Input_Stripped_RF_Results` - Extracted RF components
   - `Input_Stripped_VA_Results` - Value-added components for RF

2. `stripping progress_2018_o.xlsx` - Results from output direction stripping:
   - `Output_Remaining_Data` - Original data after removing RF components
   - `Output_Stripped_RF_Results` - Extracted RF components
   - `Output_Stripped_fu_Results` - Final use components for RF
   - `Output_Stripped_i_Results` - Import components for RF

3. Updates to `merge_sectors.xlsx`:
   - `Input_Merge_Results` - Merged sectors in input direction
   - `Output_Merge_Results` - Merged sectors in output direction

## Modifying the Script

### Changing Stripping Coefficients

To adjust how much of each sector is attributed to recreational fisheries, modify the coefficient arrays:

```matlab
% For input direction
coefficients_rf = [0.00952758843289334, 0.00184355568648111, 0.000857267727083329, 0.00797744863043076, 0.000528055091969916];
coefficients_va = 0.000363235187247446;

% For output direction
coefficients_rf = [0.00952758843289334, 0.00184355568648111, 0.000857267727083329, 0.00797744863043076, 0.000528055091969916];
coefficients_fu = 0.000353148555698657;
coefficient_i = 1.79678836377347E-07;
```

### Changing Sector Groupings

To modify which sectors are merged together, update the sector index arrays:

```matlab
% For input merging
rows_industry = {
    [1:5],        % Agriculture, forestry and fishing
    [6:11],       % Mining
    % ... other sector groups
};

% For output merging
column_industry = {
    [1:5],        % Agriculture, forestry and fishing
    [6:11],       % Mining
    % ... other sector groups
};
```

## Troubleshooting

- **File Not Found Errors**: Ensure all required files exist in the specified directory and have the correct sheet names
- **Data Format Issues**: Make sure your Excel files contain properly formatted numerical data
- **Memory Errors**: If working with very large IO tables, consider increasing MATLAB's memory allocation

## Citation

If you use this script in your research, please cite:

[Your Citation Format Here]

## License

[Your License Information Here]

## Contact

For questions or support, please contact [Your Contact Information] 