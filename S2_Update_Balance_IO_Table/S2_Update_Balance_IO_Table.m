%% S2: MATLAB Script for Updating and Balancing IO Table
% This script updates and balances the Input-Output table using the RAS method.
% The RAS method iteratively adjusts a base year IO coefficient matrix to match
% new row and column sum constraints for a target year.
%
% Author: Qilei Zhao, Weiwei Fang
% Date: 2024-03-25

%% Clear workspace and command window
clear; clc;

%% Set paths and parameters
% Define base directory path (modify as needed)
base_dir = 'Your_Path_Here'; % Replace with your actual path
data_file = fullfile(base_dir, 'data_2019.xlsx'); % Input data file
result_file = fullfile(base_dir, 'result_2019.xlsx'); % Output result file

% Error tolerance for RAS convergence
error_tolerance = 0.0027;

%% Main process
disp('Starting RAS procedure for IO table balancing...');
[A1, Rerr] = performRAS(data_file);

% Export the final balanced coefficient matrix
writematrix(A1, result_file, 'Sheet', 'A_matrix');
disp('RAS procedure completed. Balanced matrix saved to results file.');

% Plot convergence error
figure;
plot(Rerr);
title('RAS Convergence Error');
xlabel('Iteration');
ylabel('Error');
grid on;
saveas(gcf, fullfile(base_dir, 'RAS_convergence.png'));

%% RAS Algorithm Implementation
function [A1, Rerr] = performRAS(data_file)
    % Function to perform the RAS balancing procedure
    % Inputs:
    %   data_file - Excel file containing the IO data
    % Outputs:
    %   A1 - Final balanced coefficient matrix
    %   Rerr - Array of errors at each iteration
    
    % Load data from Excel
    dataTable = readtable(data_file, 'Sheet', 'RAS');
    
    % Extract the initial intermediate flow matrix
    Z0 = dataTable{1:24, 1:24};
    
    % Extract total output for base year
    X0 = dataTable{26, 1:24};
    
    % Calculate initial coefficient matrix A0 = Z0/X0
    [m, n] = size(Z0);
    A0 = zeros(m, n);
    for i = 1:m
        for j = 1:n
            A0(i, j) = Z0(i, j) / X0(j);
        end
    end
    
    % Target year constraints
    Y1 = dataTable{29, 1:24}; % Final demand
    Va1 = dataTable{28, 1:24}; % Value added
    X1 = dataTable{27, 1:24}; % Target total output
    
    % Calculate target row and column sums
    u1 = X1 - Y1;  % Target row sums (intermediate input totals)
    v1 = X1 - Va1; % Target column sums (intermediate output totals)
    
    % Initialize the matrix for first iteration (A0 * X1)
    A0X1 = zeros(m, n);
    for i = 1:m
        for j = 1:n
            A0X1(i, j) = A0(i, j) * X1(j);
        end
    end
    
    % Initialize error tracking
    Rerr = zeros(300, 1);
    
    % RAS iterative procedure
    for k = 1:300
        disp(['Iteration ', num2str(k)]);
        
        % Step 1: Row scaling (r-adjustment)
        ui = sum(A0X1, 2);  % Current row sums
        ri = u1 ./ ui;      % Row scaling factors
        
        % Apply row scaling
        for i = 1:m
            for j = 1:n
                vi_s(i, j) = ri(i) * A0X1(i, j);
            end
        end
        
        % Step 2: Column scaling (s-adjustment)
        vi = sum(vi_s, 1);  % Current column sums
        sj = v1 ./ vi;      % Column scaling factors
        
        % Apply column scaling
        for i = 1:m
            for j = 1:n
                A0X1i(i, j) = ri(i) * A0X1(i, j) * sj(j);
            end
        end
        
        % Update matrix for next iteration
        A0X1 = A0X1i;
        
        % Calculate new row and column sums for comparison
        u1T = sum(A0X1, 2);
        v1T = sum(A0X1, 1);
        
        % Display comparison of target and current sums
        disp('Row sum comparison (Current vs Target):');
        disp([u1T, u1']);
        disp('Column sum comparison (Current vs Target):');
        disp([v1T', v1']);
        
        % Calculate error for convergence check
        err = 0;
        for i = 1:m
            err = err + (u1T(i) - u1(i))^2 / X1(i)^2 + (v1T(i) - v1(i))^2 / X1(i)^2;
        end
        Rerr(k) = err;
        
        % Check convergence
        if err <= error_tolerance
            disp(['Convergence achieved at iteration ', num2str(k), ' with error = ', num2str(err), ' < ', num2str(error_tolerance)]);
            disp('Final balanced coefficient matrix:');
            A1 = A0X1 * diag(1 ./ X1);  % Convert back to coefficient form
            disp(A1);
            break;
        else
            disp(['Current error = ', num2str(err)]);
        end
    end
    
    % If loop completed without convergence
    if k == 300
        disp('Warning: Maximum iterations reached without convergence');
        A1 = A0X1 * diag(1 ./ X1);  % Return the last matrix anyway
    end
end 