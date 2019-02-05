function fun_x = nonlinearfunction(theta, mu, T, V, W_T, W_V, LB, UB, weight,size_A, size_B, dim_b)
%Weigthed convex combination parameter
alpha = 0.25;

%Number of angles considered
theta_n = size(theta, 2);

%Inicialization of dose matrices for tumor and vital structures
D_T_f = [];
D_V_f = [];

for t = 1:theta_n
    %Returns a matrix with the correspondence of beamlets and tumoral voxels. 
    %The beamlets along the collumns and voxels along the rows. The matrix will
    %attribute NaN for every element that have no correspondence, otherwise it 
    %will attribute a value in cm, representing the distance from the voxel 
    %(erradiated by the beamlet) to the bixel.
    D_T = matriz_bixel(T, theta(t), size_A, size_B, dim_b);
    
    %Returns the matrix of distribution of vital organ voxels, and the beamlet
    %attributed
    D_V = matriz_bixel(V, theta(t), size_A, size_B, dim_b);
    
    %Creating a vector 1xdim_bixel where each element of 
    %the vector represents the number of tumor voxels reached by a 
    %corresponding beamlet
    D_aux = any(~isnan(D_T));
    
    %Annulment of beamlets that are not open in the multi-leaf collimator to
    %simplify calculations
    D_T( :, all(~D_aux,1)) = [];
    D_V( :, all(~D_aux,1)) = [];
    
    %Mark the maximum voxel height for each bixel range. This will be importan
    %to know where the atenuation starts for each beamlet
    max_D = max([D_T; D_V]);
    
    %Size of matrix D_T
    [x_D, y_D] = size(D_T);
    
    %Loop to every element of matrices D_T and D_V. If it is a NaN value,
    %the element is ignored, otherwise the atenuation is applied. 
    for i=1:x_D
        for j=1:y_D
            if (~isnan(D_T(i, j))==1)
                D_T(i, j) = (size_A^2)/(size_B^2)/weight*exp(-mu*(max_D(j)-D_T(i, j)));
            end
            if (~isnan(D_V(i, j))==1)
                D_V(i, j) =  (size_A^2)/(size_B^2)/weight*exp(-mu*(max_D(j)-D_V(i, j)));
            end
        end
    end
    
    %Add the matrices of the different angles, so at the end of the loop 
    %it is possible to identify which voxels are not affected by the 
    %radiation
	D_T_f = [D_T_f D_T];
	D_V_f = [D_V_f D_V];
end

%Matrix that identifies which voxels are not affected by the radiation coming
%from the open bixels
D_aux_T = any(~isnan(D_T_f'));
D_aux_V = any(~isnan(D_V_f'));

%Deleting the voxels that have only NaN values in tumor matrix.  This
%happens in order to simplify the matrix used in optimization
D_T_f(all(~D_aux_T, 1)', :)= [];

%Deleting the voxels that have only NaN values in vital organ matrix. This
%happens in order to calculate the matrix used in optimization
D_V_f(all(~D_aux_V, 1)', :)= [];

%Size of the new matrix
[x_D_T, y_D] = size(D_T_f);
[x_D_V, ~] = size(D_V_f);

%Turn the NaN values presented in the matrix into zeros to include them in 
%the minimization problem
D_T_f(isnan(D_T_f))=0;
D_V_f(isnan(D_V_f))=0;

%Add two columns of zeros at the end of the array
D_T = [D_T_f zeros(x_D_T, 2)];
D_V = [D_V_f zeros(x_D_V, 2)];

%Vectors created to calculate the max and min dose of tumoral and vital
%strucures, respectively.
min_T = zeros(1, y_D+2);
min_T(y_D+1) = 1;
max_V = zeros(1, y_D+2);
max_V(y_D+2) = 1;

%Main function that needs to be minimized 
fun = W_T*(alpha*min_T+(1-alpha)/nnz(T)*sum(D_T))+W_V*(alpha*max_V+(1-alpha)/nnz(V)*sum(D_V));
fun = fun';

%Inequations to control the upper and lowers bounds defined for vital and
%tumoral doses. These inequations are also used to assign the min and max
%doses values refered in min_T and max_V
%Aineq*x <= bineq
Aineq = [D_T; -D_T; -D_V; [-D_T_f ones(x_D_T, 1) zeros(x_D_T, 1)]; [D_V_f zeros(x_D_V, 1) -ones(x_D_V, 1)]];
bineq = [ones(x_D_T, 1)*UB(1);-ones(x_D_T, 1)*LB(1); -ones(x_D_V, 1)*LB(2); zeros(x_D_T+x_D_V, 1)];

%lb<= x <= ub
lb = zeros(y_D+2, 1);

%[x, fval] = cplexlp(f,Aineq,bineq,Aeq,beq,lb,ub,x0)
[~, fval] = cplexlp(fun, Aineq, bineq, [], [], lb, [], []);
fun_x = fval;
end