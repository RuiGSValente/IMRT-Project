clear; close all;
%Path to CPLEX in order to apply cplexlp function
%Should be changed according to personal path to the folders
addpath('C:\Program Files\IBM\ILOG\CPLEX_Studio128\cplex\examples\src\matlab')
addpath ('C:\Program Files\IBM\ILOG\CPLEX_Studio128\cplex\matlab\x64_win64')
savepath

%Size of voxels' edge
size_A = 1;
%Size of bixels' edge
size_B = 4;
%Overall size of MLC
dim_b = 40;
%Distance between center of human structure and MLC
height = 20;
%Matrix A representa a estrutura de voxels
A = cell2mat(struct2cell(load('matlab.mat')));
[dim_i,dim_j, dim_z] = size(A);
%number of angles considered
n_theta = 3;
%attenuation coefficient
mu = 0.01;
%weight of each voxel in Kg, considering that each voxel has 1 cm^3
weight = 1.07*10^(-3);
%Separation of the matrix of voxels representing the tumor and vital organs
T = matrix_organs(A, -1);
V = matrix_organs(A, 1);
%Weights of voxels of each set
W_T = -1;
W_V = 1;
%Lower and Upper bound: minimum and maximum dose for each voxel
LB = [50 0];
UB = [70 NaN];
%Objective function
f = @(theta) nonlinearfunction(theta, mu, T, V, W_T, W_V, LB, UB, weight, size_A, size_B, dim_b);

%SA~N(0, 45^2) -> simulated_annealing(f, n_theta, 1);
%ASA~N(0, 45^2) -> simulated_annealing(f, n_theta, 2);
%SA~N(0, 90^2) -> simulated_annealing(f, n_theta, 3);
%ASA~N(0, 90^2) -> simulated_annealing(f, n_theta, 4);
%SA~U(-90, 90) -> simulated_annealing(f, n_theta, 5);
%ASA~U(-90, 90) -> simulated_annealing(f, n_theta, 6);
%SA~U(-45, 45) -> simulated_annealing(f, n_theta, 7);
%ASA~U(-45, 45) -> simulated_annealing(f, n_theta, 8);

[result, time, theta] = simulated_annealing(f, n_theta, 4);

%Draw functions
%desenha_vortex(V, 0, size_A);
%desenha_vortex(T, 1, size_A);
%desenha_bixel(T, theta, size_A, size_B, height, dim_b);
