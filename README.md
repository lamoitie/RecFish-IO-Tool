# Recreational Fisheries Input-Output Analysis Toolkit

This repository contains a collection of MATLAB scripts for input-output analysis of recreational fisheries, including four main modules: data extraction, table updating, linkage analysis, and structural decomposition analysis.

## Repository Structure

The repository contains the following four modules:

1. **S1_Extract_Recreational_Fisheries** - Tools for extracting recreational fisheries data from related sectors
2. **S2_Update_Balance_IO_Table** - Updating and balancing input-output tables using the RAS method
3. **S3_Calculate_Linkages** - Calculating backward and forward linkages of recreational fisheries and other sectors
4. **S4_Structural_Decomposition_Analysis** - Analyzing the drivers of changes in recreational fisheries

## Module Overview

### S1: Extracting Recreational Fisheries Data

This module is used to extract recreational fisheries-related economic activities from standard input-output tables. Main features include:

- Extracting recreational fisheries components from the input direction
- Extracting recreational fisheries components from the output direction
- Merging sectors according to predefined industry groups

[Detailed Documentation](S1_Extract_Recreational_Fisheries/S1_README.md)

### S2: Updating and Balancing Input-Output Tables

This module uses the RAS method to update and balance input-output tables, allowing base-year tables to be updated to a target year. Main features include:

- Using the RAS biproportional adjustment method to iteratively adjust coefficient matrices
- Balancing matrices to meet new row and column constraints
- Providing error tracking and convergence monitoring

[Detailed Documentation](S2_Update_Balance_IO_Table/S2_README.md)

### S3: Calculating Forward and Backward Linkages

This module calculates the economic linkages of recreational fisheries and other sectors, identifying key sectors. Main features include:

- Calculating backward linkages (demand-driven effects)
- Calculating forward linkages (supply-driven effects)
- Analyzing production effects when sector output increases
- Analyzing employment impacts
- Evaluating supply chain effects using the Ghosh model

[Detailed Documentation](S3_Calculate_Linkages/S3_README.md)

### S4: Structural Decomposition Analysis

This module identifies and quantifies the drivers of changes in recreational fisheries through structural decomposition analysis. Main features include:

- Decomposing total change into contributions from five key driving factors
- Implementing the complete D&L (Dietzenbacher & Los) decomposition approach
- Quantifying the contribution of each factor to the total change
- Generating visualizations of factor contributions

[Detailed Documentation](S4_Structural_Decomposition_Analysis/S4_README.md)

## Usage Guide

1. Clone or download this repository to your local directory
2. Ensure MATLAB is installed (R2018a or later version recommended)
3. Prepare the necessary input data according to each module's README documentation
4. Run the scripts in the order of the analysis workflow:
   - First run S1 to extract recreational fisheries data
   - Use S2 to update and balance IO tables (if needed)
   - Use S3 to calculate economic linkages
   - Use S4 for structural decomposition analysis

## Data Requirements

Each module requires Excel files with specific formats as input. For detailed data format requirements, please refer to the README documentation of each module.



## Contact

For questions or support, please contact Qilei Zhao (lamoitie@163.com)