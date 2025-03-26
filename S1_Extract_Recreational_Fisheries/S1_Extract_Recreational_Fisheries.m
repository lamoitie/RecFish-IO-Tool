%% S1: MATLAB Script for Extracting Recreational Fisheries from Related Sectors
% This script extracts recreational fisheries from related sectors in both input and
% output directions and then merges sectors as specified.
%
% The workflow consists of four main steps:
% 1. Extract recreational fisheries components from input direction
% 2. Extract recreational fisheries components from output direction
% 3. Merge sectors in the input direction
% 4. Merge sectors in the output direction
%
% Author: Qilei Zhao，Weiwei Fang
% Date: 2025-03-25

%% Clear workspace and command window
clear; clc;

%% Set paths and parameters
% Define base directory path (modify as needed)
base_dir = 'Your_Path_Here'; % Replace with your actual path
original_data_file = fullfile(base_dir, 'stripping progress_2018.xlsx');
input_output_file = fullfile(base_dir, 'stripping progress_2018_i.xlsx');
output_output_file = fullfile(base_dir, 'stripping progress_2018_o.xlsx');
merge_sectors_file = fullfile(base_dir, 'merge_sectors.xlsx');

% Main workflow control
run_input_stripping = true;
run_output_stripping = true;
run_input_merge = true;
run_output_merge = true;

%% STEP 1: Extract recreational fisheries components from input direction
if run_input_stripping
    disp('Step 1: Processing input direction stripping...');
    processInputStripping(base_dir, original_data_file, input_output_file);
    disp('Input direction stripping completed.');
end

%% STEP 2: Extract recreational fisheries components from output direction
if run_output_stripping
    disp('Step 2: Processing output direction stripping...');
    processOutputStripping(base_dir, original_data_file, output_output_file);
    disp('Output direction stripping completed.');
end

%% STEP 3: Merge sectors in the input direction
if run_input_merge
    disp('Step 3: Merging sectors in input direction...');
    processInputMergeSectors(base_dir, merge_sectors_file);
    disp('Input direction sector merging completed.');
end

%% STEP 4: Merge sectors in the output direction
if run_output_merge
    disp('Step 4: Merging sectors in output direction...');
    processOutputMergeSectors(base_dir, merge_sectors_file);
    disp('Output direction sector merging completed.');
end

disp('All processing completed successfully.');

%% Function for input direction stripping
function processInputStripping(base_dir, input_file, output_file)
    % Function to extract recreational fisheries data from input direction
    
    % Set working directory
    cd(base_dir);
    
    % Load the initial preparation materials from Excel for input direction
    dataTable = readtable(input_file, 'Sheet', 'step1_materials');
    
    % Define stripping coefficients for different recreational fishing activity types
    coefficients_rf = [0.00952758843289334, 0.00184355568648111, 0.000857267727083329, 0.00797744863043076, 0.000528055091969916];
    coefficients_va = 0.000363235187247446;
    
    % Define the row indices for each activity type
    rows_rf = {
        [4, 82, 134, 139, 140, 141],  % rf1
        [5, 17, 57, 93, 111, 113, 115, 117, 123, 124, 135, 151],  % rf2
        [109, 110, 136, 138],  % rf3
        [70, 76],  % rf4
        [142, 143, 147, 149]  % rf5
    };
    rows_va = [154, 155, 156, 157]; % Value added rows
    
    % Identify numeric columns to safely apply coefficients
    isNumericColumn = varfun(@isnumeric, dataTable, 'OutputFormat', 'uniform');
    
    % Calculate the stripped parts and merge into single rows for RF
    stripped_data = zeros(length(rows_rf), sum(isNumericColumn));
    for i = 1:length(rows_rf)
        numericData = dataTable{rows_rf{i}, isNumericColumn};
        stripped_data(i, :) = sum(numericData .* coefficients_rf(i), 1);
    end
    
    % Handle value added calculations without merging into a single row
    va_data = dataTable{rows_va, isNumericColumn} .* coefficients_va;
    
    % Compute remaining inputs after stripping off the recreational fishing industry
    for i = 1:length(rows_rf)
        numericData = dataTable{rows_rf{i}, isNumericColumn};
        dataTable{rows_rf{i}, isNumericColumn} = numericData * (1 - coefficients_rf(i));
    end
    dataTable{rows_va, isNumericColumn} = dataTable{rows_va, isNumericColumn} * (1 - coefficients_va);
    
    % Convert to tables
    stripped_table = array2table(stripped_data, 'VariableNames', dataTable.Properties.VariableNames(isNumericColumn));
    va_table = array2table(va_data, 'VariableNames', dataTable.Properties.VariableNames(isNumericColumn));
    
    % Write the results for the input direction to new sheets in the Excel file
    writetable(dataTable, output_file, 'Sheet', 'Input_Remaining_Data');
    writetable(stripped_table, output_file, 'Sheet', 'Input_Stripped_RF_Results');
    writetable(va_table, output_file, 'Sheet', 'Input_Stripped_VA_Results');
end

%% Function for output direction stripping
function processOutputStripping(base_dir, input_file, output_file)
    % Function to extract recreational fisheries data from output direction
    
    % Set working directory
    cd(base_dir);
    
    % Load the initial preparation materials from Excel for output direction
    dataTable = readtable(input_file, 'Sheet', 'step2_materials');
    
    % Define stripping coefficients for different recreational fishing activity types
    coefficients_rf = [0.00952758843289334, 0.00184355568648111, 0.000857267727083329, 0.00797744863043076, 0.000528055091969916];
    coefficients_fu = 0.000353148555698657;
    coefficient_i = 1.79678836377347E-07;
    
    % Define the column indices for each activity type
    column_rf = {
        [4, 82, 134, 139, 140, 141],  % rf1
        [5, 17, 57, 93, 111, 113, 115, 117, 123, 124, 135, 151],  % rf2
        [109, 110, 136, 138],  % rf3
        [70, 76],  % rf4
        [142, 143, 147, 149]  % rf5
    };
    column_fu = [154, 155, 156, 157, 158, 159]; % final use columns
    column_i = 160; % import column
    
    % Identify numeric rows to safely apply coefficients (all rows in this case)
    isNumericColumn = [1:162]; % Represents all row positions
    
    % Calculate the stripped parts and merge into single columns for RF
    stripped_data = zeros(length(isNumericColumn), length(column_rf));
    for i = 1:length(column_rf)
        numericData = dataTable{isNumericColumn, column_rf{i}};
        stripped_data(:, i) = sum(numericData .* coefficients_rf(i), 2); % Sum along rows
    end
    
    % Handle final use and import calculations
    fu_data = dataTable{isNumericColumn, column_fu} .* coefficients_fu;
    i_data = dataTable{isNumericColumn, column_i} .* coefficient_i;
    
    % Compute remaining outputs after stripping off the recreational fishing industry
    for i = 1:length(column_rf)
        numericData = dataTable{isNumericColumn, column_rf{i}};
        dataTable{isNumericColumn, column_rf{i}} = numericData * (1 - coefficients_rf(i));
    end
    dataTable{isNumericColumn, column_fu} = dataTable{isNumericColumn, column_fu} * (1 - coefficients_fu);
    dataTable{isNumericColumn, column_i} = dataTable{isNumericColumn, column_i} * (1 - coefficient_i);
    
    % Convert to tables
    stripped_table = array2table(stripped_data);
    fu_table = array2table(fu_data);
    i_table = array2table(i_data);
    
    % Write the results for the output direction to new sheets in the Excel file
    writetable(dataTable, output_file, 'Sheet', 'Output_Remaining_Data');
    writetable(stripped_table, output_file, 'Sheet', 'Output_Stripped_RF_Results');
    writetable(fu_table, output_file, 'Sheet', 'Output_Stripped_fu_Results');
    writetable(i_table, output_file, 'Sheet', 'Output_Stripped_i_Results');
end

%% Function for input direction sector merging
function processInputMergeSectors(base_dir, merge_sectors_file)
    % Function to merge sectors in the input direction
    
    % Set working directory
    cd(base_dir);
    
    % Load the data for input direction sector merging
    dataTable = readtable(merge_sectors_file, 'Sheet', 'original');
    
    % Define the row indices for each industry group to be merged
    rows_industry = {
        [1:5],        % Agriculture, forestry and fishing
        [6:11],       % Mining
        [12:99],      % Manufacturing
        [100:102],    % Electricity, gas, water supply
        [103:108],    % Construction
        [109,110],    % Wholesale and retail trade
        [111:122],    % Transportation, storage and postal services
        [123,124],    % Accommodation and food services
        [125:129],    % Information, communication and IT services
        [130:132],    % Financial services
        [133],        % Real estate
        [134,135],    % Business services
        [136:138],    % Scientific research and technical services
        [139:141],    % Water, environmental and public facility management
        [142,143],    % Residential and other services
        [144],        % Education
        [145,146],    % Healthcare and social work
        [147:151],    % Culture, sports and entertainment
        [152,153]     % Public administration and social organizations
    };
    
    % Identify numeric columns to safely apply operations
    isNumericColumn = varfun(@isnumeric, dataTable, 'OutputFormat', 'uniform');
    
    % Merge rows into single row for each industry group
    industry_data = zeros(length(rows_industry), sum(isNumericColumn));
    for i = 1:length(rows_industry)
        numericData = dataTable{rows_industry{i}, isNumericColumn};
        industry_data(i, :) = sum(numericData, 1);
    end
    
    % Convert to table
    industry_table = array2table(industry_data, 'VariableNames', dataTable.Properties.VariableNames(isNumericColumn));
    
    % Write the results to Excel
    writetable(industry_table, merge_sectors_file, 'Sheet', 'Input_Merge_Results');
end

%% Function for output direction sector merging
function processOutputMergeSectors(base_dir, merge_sectors_file)
    % Function to merge sectors in the output direction
    
    % Set working directory
    cd(base_dir);
    
    % Load the data for output direction sector merging
    dataTable = readtable(merge_sectors_file, 'Sheet', 'second');
    
    % Define the column indices for each industry group to be merged
    column_industry = {
        [1:5],        % Agriculture, forestry and fishing
        [6:11],       % Mining
        [12:99],      % Manufacturing
        [100:102],    % Electricity, gas, water supply
        [103:108],    % Construction
        [109,110],    % Wholesale and retail trade
        [111:122],    % Transportation, storage and postal services
        [123,124],    % Accommodation and food services
        [125:129],    % Information, communication and IT services
        [130:132],    % Financial services
        [133],        % Real estate
        [134,135],    % Business services
        [136:138],    % Scientific research and technical services
        [139:141],    % Water, environmental and public facility management
        [142,143],    % Residential and other services
        [144],        % Education
        [145,146],    % Healthcare and social work
        [147:151],    % Culture, sports and entertainment
        [152,153]     % Public administration and social organizations
    };
    
    % Identify numeric rows (all rows in this case)
    isNumericColumn = [1:29]; % Represents all row positions
    
    % Merge columns into single column for each industry group
    industry_data = zeros(length(isNumericColumn), length(column_industry));
    for i = 1:length(column_industry)
        numericData = dataTable{isNumericColumn, column_industry{i}+1}; % +1 adjustment for data offset
        industry_data(:, i) = sum(numericData, 2);
    end
    
    % Convert to table
    industry_table = array2table(industry_data);
    
    % Write the results to Excel
    writetable(industry_table, merge_sectors_file, 'Sheet', 'Output_Merge_Results');
end 
