%% S3: MATLAB Script for Calculating Backward and Forward Linkages
% This script calculates backward and forward linkages of recreational fisheries
% and other sectors in the economy using Input-Output analysis. It also computes:
% 1. Production effects - impact on all sectors when output of a sector increases
% 2. Employment effects - impact on employment when output of a sector increases
% 3. Supply effects - impact on sectors when supply from a sector increases
%
% Author: Qilei Zhao, Weiwei Fang
% Date: 2024-03-25

%% Clear workspace and command window
clear; clc;

%% Set paths and parameters
% Define base directory path (modify as needed)
base_dir = 'Your_Path_Here'; % Replace with your actual path
data_file = fullfile(base_dir, '2018.xlsx'); % Input data file
result_file = data_file; % Results will be saved to the same file

%% Load data
disp('Loading data from input file...');

% Load demand-side data for Leontief model
dataTable = readtable(data_file, 'Sheet', 'data_demand');
dataTable = table2array(dataTable);

% Load supply-side data for Ghosh model
dataTableR = readtable(data_file, 'Sheet', 'data_supply');
dataTableR = table2array(dataTableR);

% Load employment indicators
employment_index = readtable(data_file, 'Sheet', 'employment_index');
employment_index = table2array(employment_index);

%% Calculate direct requirements matrix (A)
disp('Calculating direct requirements matrix...');

% Extract transaction matrix and total industry output
A = dataTable(1:24, :);
cols = dataTable(25, :);

% Normalize columns to calculate technical coefficients
for n = 1:size(A, 2)
    A(:, n) = A(:, n) ./ cols(1, n);
end

%% Calculate Leontief inverse matrix (L)
disp('Calculating Leontief inverse matrix...');

% Calculate I-A matrix
B = eye(size(A, 1)) - A;

% Calculate Leontief inverse: L = (I-A)^-1
Binv = inv(B);
disp('Leontief inverse matrix:');
disp(Binv);

%% Calculate direct and indirect effects of unit change in final demand
disp('Calculating effects of unit change in final demand...');

% Number of sectors related to recreational fisheries
production_size = 5;

% Initialize matrices for five sectors (columns 20-24)
f_new = zeros(24, production_size);

% Set unit change in final demand for each recreational fishery sector
for i = 1:production_size
    f_new(size(A, 1) - production_size + i, i) = 1;
end

% Calculate total (direct + indirect) effects using Leontief inverse
X_new = zeros(24, production_size);
for i = 1:production_size
    X_new(:, i) = Binv * f_new(:, i);
end

%% Calculate backward and forward linkages
disp('Calculating backward and forward linkages...');

% Calculate the average value in the Leontief inverse
bsum = sum(sum(Binv)) / size(Binv, 1);

% Backward linkages (normalized column sums)
backward = sum(Binv, 1)' ./ bsum;

% Forward linkages (normalized row sums)
forward = sum(Binv, 2) ./ bsum;

%% Calculate production effects using extraction method
disp('Calculating production effects using extraction method...');

production_eff = zeros(size(A, 1) - 1, production_size);

for i = 1:production_size
    % Identify row/column to remove
    row_to_remove = size(A, 1) - production_size + i;
    
    % Remove the row and column corresponding to the target sector
    Ae = A([1:row_to_remove-1, row_to_remove+1:end], :);
    
    % Extract column of coefficients for removed sector
    arf = Ae(:, row_to_remove);
    
    % Remove column of the sector from A matrix
    Ae = Ae(:, [1:row_to_remove-1, row_to_remove+1:end]);
    
    % Calculate impact on other sectors when target sector output increases by 1 unit
    % delta_xe = (I-Ae)^-1 * arf * 1
    delta_xe = inv((eye(size(Ae, 1)) - Ae)) * arf * 1;
    
    % Store results
    production_eff(:, i) = delta_xe;
end

%% Calculate employment effects
disp('Calculating employment effects...');

employment_eff = zeros(size(A, 1) - 1, production_size);

for i = 1:production_size
    % Identify row/column to remove
    row_to_remove = size(A, 1) - production_size + i;
    
    % Remove the row and column corresponding to the target sector
    Ae = A([1:row_to_remove-1, row_to_remove+1:end], :);
    
    % Extract column of coefficients for removed sector
    arf = Ae(:, row_to_remove);
    
    % Remove column of the sector from A matrix
    Ae = Ae(:, [1:row_to_remove-1, row_to_remove+1:end]);
    
    % Extract employment index without the target sector
    Ie = employment_index([1:row_to_remove-1, row_to_remove+1:end], :);
    Ie = Ie(:, [1:row_to_remove-1, row_to_remove+1:end]);
    
    % Calculate employment impact
    delta_xe = Ie * inv((eye(size(Ae, 1)) - Ae)) * arf * 1;
    
    % Store results
    employment_eff(:, i) = delta_xe;
end

%% Calculate supply effects using Ghosh model
disp('Calculating supply effects...');

% Extract supply-side data
R = dataTableR(:, 1:24);
rows = dataTableR(:, 25);

% Normalize rows to calculate allocation coefficients
for n = 1:size(R, 1)
    R(n, :) = R(n, :) ./ rows(n, 1);
end

% Calculate supply effects
supply_eff = zeros(size(A, 1) - 1, production_size);

for i = 1:production_size
    % Identify row/column to remove
    row_to_remove = size(A, 1) - production_size + i;
    
    % Remove the row and column corresponding to the target sector from R
    Re = R(:, [1:row_to_remove-1, row_to_remove+1:end]);
    
    % Extract row of coefficients for removed sector
    Rrf = Re(row_to_remove, :);
    
    % Remove row of the sector from R matrix
    Re = Re([1:row_to_remove-1, row_to_remove+1:end], :);
    
    % Calculate supply impact using Ghosh inverse
    delta_xe = Rrf * 1 * inv((eye(size(Re, 1)) - Re));
    
    % Store results
    supply_eff(:, i) = delta_xe';
end

%% Save results to Excel
disp('Saving results to Excel file...');

% Convert result matrices to tables
production_eff_table = array2table(production_eff);
employment_eff_table = array2table(employment_eff);
supply_eff_table = array2table(supply_eff);
backward_table = array2table(backward);
forward_table = array2table(forward);
X_new_table = array2table(X_new, 'VariableNames', {'X_new1', 'X_new2', 'X_new3', 'X_new4', 'X_new5'});

% Write tables to Excel sheets
writetable(production_eff_table, result_file, 'Sheet', 'production_eff');
writetable(employment_eff_table, result_file, 'Sheet', 'employment_eff');
writetable(supply_eff_table, result_file, 'Sheet', 'supply_eff');
writetable(backward_table, result_file, 'Sheet', 'backward');
writetable(forward_table, result_file, 'Sheet', 'forward');
writetable(X_new_table, result_file, 'Sheet', 'xnew');

disp('Analysis completed successfully.');

%% Create visualization for linkages
figure;
subplot(2, 1, 1);
bar(backward);
title('Backward Linkages by Sector');
xlabel('Sector');
ylabel('Linkage Strength');
grid on;

subplot(2, 1, 2);
bar(forward);
title('Forward Linkages by Sector');
xlabel('Sector');
ylabel('Linkage Strength');
grid on;

saveas(gcf, fullfile(base_dir, 'Linkages_Visualization.png'));
disp('Visualization saved.');

%% Display summary of results
disp('Summary of Results:');
disp('-----------------');

disp('Top 5 sectors with strongest backward linkages:');
[sorted_backward, idx_back] = sort(backward, 'descend');
for i = 1:5
    disp(['Rank ', num2str(i), ': Sector ', num2str(idx_back(i)), ' with strength ', num2str(sorted_backward(i))]);
end

disp('Top 5 sectors with strongest forward linkages:');
[sorted_forward, idx_forw] = sort(forward, 'descend');
for i = 1:5
    disp(['Rank ', num2str(i), ': Sector ', num2str(idx_forw(i)), ' with strength ', num2str(sorted_forward(i))]);
end 