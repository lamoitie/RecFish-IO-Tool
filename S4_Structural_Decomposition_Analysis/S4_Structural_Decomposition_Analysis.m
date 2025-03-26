%% S4: MATLAB Script for Structural Decomposition Analysis
% This script performs Structural Decomposition Analysis (SDA) to identify
% and quantify the drivers of change in recreational fisheries between two time periods.
% SDA decomposes the total change into contributions from different factors:
% 1. Population/scale changes
% 2. Per capita demand changes
% 3. Resource/environmental intensity changes
% 4. Production structure changes (Leontief inverse)
% 5. Final demand structure changes
%
% Author: Qilei Zhao, Weiwei Fang
% Date: 2024-03-25

%% Clear workspace and command window
clear; clc;

%% Set paths and parameters
% Define base directory path (modify as needed)
base_dir = 'Your_Path_Here'; % Replace with your actual path
data_file = fullfile(base_dir, 'SDA_data.xlsx'); % Input data file
result_file = fullfile(base_dir, 'SDA_results.xlsx'); % Output results file

% Load necessary input data from Excel
disp('Loading data for SDA analysis...');
% Load data for time period 0 (base year)
P0 = readmatrix(data_file, 'Sheet', 'Population', 'Range', 'B2');  % Population in base year
Et0 = readmatrix(data_file, 'Sheet', 'Intensity', 'Range', 'B2:B25'); % Sectoral intensity in base year
L18 = readmatrix(data_file, 'Sheet', 'Leontief', 'Range', 'B2:Y25'); % Leontief inverse for base year
FSt0 = readmatrix(data_file, 'Sheet', 'FinalDemand', 'Range', 'B2:K25'); % Final demand structure in base year
FL0 = readmatrix(data_file, 'Sheet', 'FinalDemandSource', 'Range', 'B2:B11'); % Final demand source in base year

% Load data for time period 1 (target year)
P1 = readmatrix(data_file, 'Sheet', 'Population', 'Range', 'C2');  % Population in target year
Et1 = readmatrix(data_file, 'Sheet', 'Intensity', 'Range', 'C2:C25'); % Sectoral intensity in target year
L20 = readmatrix(data_file, 'Sheet', 'Leontief', 'Range', 'AA2:AX25'); % Leontief inverse for target year
FSt1 = readmatrix(data_file, 'Sheet', 'FinalDemand', 'Range', 'L2:U25'); % Final demand structure in target year
FL1 = readmatrix(data_file, 'Sheet', 'FinalDemandSource', 'Range', 'C2:C11'); % Final demand source in target year

%% Initialize output matrix for SDA results
data = zeros(120, 1);  % 120 = 5 factors * 9 categories per factor * jj iterations

%% Perform SDA for each final demand category
for jj = 1:1  % Note: Original code suggests this could loop through multiple categories, currently set to 1
    disp(['Performing SDA for category ', num2str(jj)]);
    
    % Population change (could represent per capita GDP or other scale factor)
    DP = P1 - P0;

    % Resource/environmental intensity change
    E0 = Et0;
    E1 = Et1;
    DE = E1 - E0;

    % Production structure change (Leontief inverse)
    L0 = L18;
    L1 = L20;
    DL = L1 - L0;

    % Final demand structure change
    FS0 = diag(FSt0(:, jj));
    FS1 = diag(FSt1(:, jj));
    DFS = FS1 - FS0;
    
    % Final demand source change
    DFL = FL1 - FL0;
    
    % Calculate contributions using the D&L decomposition approach
    % This uses the full averaging approach with all possible first-order approximations
    
    % Contribution from intensity changes (DE)
    QE = (1/120) * (
        24*P0*DE*L0*FS0*FL0 + 6*P0*DE*L0*FS0*FL1 + 6*P0*DE*L0*FS1*FL0 + 
        6*P0*DE*L1*FS0*FL0 + 6*P1*DE*L0*FS0*FL0 + 4*P0*DE*L0*FS1*FL1 + 
        4*P0*DE*L1*FS0*FL1 + 4*P1*DE*L0*FS0*FL1 + 4*P1*DE*L0*FS1*FL0 + 
        4*P1*DE*L1*FS0*FL0 + 4*P0*DE*L1*FS1*FL0 + 6*P0*DE*L1*FS1*FL1 + 
        6*P1*DE*L0*FS1*FL1 + 6*P1*DE*L1*FS0*FL1 + 6*P1*DE*L1*FS1*FL0 + 
        24*P1*DE*L1*FS1*FL1
    );
    
    % Contribution from production structure changes (DL)
    QL = (1/120) * (
        24*P0*E0*DL*FS0*FL0 + 6*P0*E0*DL*FS0*FL1 + 6*P0*E0*DL*FS1*FL0 + 
        6*P0*E1*DL*FS0*FL0 + 6*P1*E0*DL*FS0*FL0 + 4*P0*E0*DL*FS1*FL1 + 
        4*P0*E1*DL*FS0*FL1 + 4*P1*E0*DL*FS0*FL1 + 4*P1*E0*DL*FS1*FL0 + 
        4*P1*E1*DL*FS0*FL0 + 4*P0*E1*DL*FS1*FL0 + 6*P0*E1*DL*FS1*FL1 + 
        6*P1*E0*DL*FS1*FL1 + 6*P1*E1*DL*FS0*FL1 + 6*P1*E1*DL*FS1*FL0 + 
        24*P1*E1*DL*FS1*FL1
    );
    
    % Contribution from final demand structure changes (DFS)
    QFS = (1/120) * (
        24*P0*E0*L0*DFS*FL0 + 6*P0*E0*L0*DFS*FL1 + 6*P0*E0*L1*DFS*FL0 + 
        6*P0*E1*L0*DFS*FL0 + 6*P1*E0*L0*DFS*FL0 + 4*P0*E0*L1*DFS*FL1 + 
        4*P0*E1*L0*DFS*FL1 + 4*P1*E0*L0*DFS*FL1 + 4*P1*E0*L1*DFS*FL0 + 
        4*P1*E1*L0*DFS*FL0 + 4*P0*E1*L1*DFS*FL0 + 6*P0*E1*L1*DFS*FL1 + 
        6*P1*E0*L1*DFS*FL1 + 6*P1*E1*L0*DFS*FL1 + 6*P1*E1*L1*DFS*FL0 + 
        24*P1*E1*L1*DFS*FL1
    );
    
    % Contribution from final demand source changes (DFL)
    QFL = (1/120) * (
        24*P0*E0*L0*FS0*DFL + 6*P0*E0*L0*FS1*DFL + 6*P0*E0*L1*FS0*DFL + 
        6*P0*E1*L0*FS0*DFL + 6*P1*E0*L0*FS0*DFL + 4*P0*E0*L1*FS1*DFL + 
        4*P0*E1*L0*FS1*DFL + 4*P1*E0*L0*FS1*DFL + 4*P1*E0*L1*FS0*DFL + 
        4*P1*E1*L0*FS0*DFL + 4*P0*E1*L1*FS0*DFL + 6*P0*E1*L1*FS1*DFL + 
        6*P1*E0*L1*FS1*DFL + 6*P1*E1*L0*FS1*DFL + 6*P1*E1*L1*FS0*DFL + 
        24*P1*E1*L1*FS1*DFL
    );
    
    % Contribution from population/scale changes (DP)
    QP = (1/120) * (
        24*DP*E0*L0*FS0*FL0 + 6*DP*E0*L0*FS0*FL1 + 6*DP*E0*L0*FS1*FL0 + 
        6*DP*E0*L1*FS0*FL0 + 6*DP*E1*L0*FS0*FL0 + 4*DP*E0*L0*FS1*FL1 + 
        4*DP*E0*L1*FS0*FL1 + 4*DP*E1*L0*FS0*FL1 + 4*DP*E1*L0*FS1*FL0 + 
        4*DP*E1*L1*FS0*FL0 + 4*DP*E0*L1*FS1*FL0 + 6*DP*E0*L1*FS1*FL1 + 
        6*DP*E1*L0*FS1*FL1 + 6*DP*E1*L1*FS0*FL1 + 6*DP*E1*L1*FS1*FL0 + 
        24*DP*E1*L1*FS1*FL1
    );
    
    % Combine all contributions
    Q = [QE; QL; QFS; QFL; QP];
    
    % Store results
    data((jj-1)*5*9+1:jj*9*5, 1) = Q;
end

%% Save and visualize results
% Write results to Excel
writematrix(data, result_file, 'Sheet', 'SDA_Results');
disp('SDA results saved to Excel file.');

% Create a visualization of the contributions
factor_names = {'Intensity', 'Production Structure', 'Final Demand Structure', 'Final Demand Source', 'Population/Scale'};
factor_data = zeros(5, 1);

for i = 1:5
    factor_data(i) = sum(data((i-1)*9+1:i*9));
end

% Calculate percentage contributions
total_change = sum(factor_data);
factor_percent = factor_data / total_change * 100;

% Create a bar chart
figure;
bar(factor_percent);
set(gca, 'XTickLabel', factor_names);
title('Contribution of Each Factor to Total Change (%)');
ylabel('Percentage Contribution');
grid on;
xtickangle(45);

% Add percentage labels on bars
for i = 1:5
    text(i, factor_percent(i)+1, [num2str(factor_percent(i), '%.1f') '%'], ...
        'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');
end

% Save the figure
saveas(gcf, fullfile(base_dir, 'SDA_Contributions.png'));
disp('Visualization saved.');

%% Display summary of results
disp('Summary of SDA Results:');
disp('-----------------------');
disp('Contribution of each factor to total change:');

for i = 1:5
    disp([factor_names{i}, ': ', num2str(factor_percent(i)), '% (', num2str(factor_data(i)), ')']);
end

disp(['Total change: ', num2str(total_change)]);

% Identify the main drivers of change
[~, idx] = sort(abs(factor_data), 'descend');
disp('Main drivers of change (in order of importance):');
for i = 1:5
    disp([num2str(i), '. ', factor_names{idx(i)}, ' (', num2str(factor_percent(idx(i))), '%)']);
end 