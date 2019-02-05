function [result, time, theta] = simulated_annealing(f, n_theta, method)
%Vector initialization 
N = zeros(1, n_theta);
%Generation of a random vector with n_theta angles
C = rand(1,n_theta)*360;
%Maximum temperature
T_max = 5;
T_min = 0;
T_interval = 0.005;
%Calculation of objective value of vector C
E_c = f(C);
time_0 = cputime;
for T=T_max:-T_interval:T_min
        switch method
        %Gaussian distribution mu = 0 // sigma = 1
            %SA~N(0, 45^2)
            case 1
                N(:) = mod(C(:) + normrnd(0,1, n_theta, 1)*360/8, 360);        
            %ASA~N(0, 45^2)
            case 2
                N(:) = mod(C(:) + normrnd(0,1, n_theta, 1)*360/8*T, 360);        
            %SA~N(0, 90^2)
            case 3
                N(:) = mod(C(:) + normrnd(0,1, n_theta, 1)*360/4, 360);        
            %ASA~N(0, 90^2)
            case 4
                N(:) = mod(C(:) + normrnd(0,1, n_theta, 1)*360/4*T, 360);        
        %Uniform distribution
            %SA~U(-90, +90)
            case 5
                N(:) = mod(C(:) + (rand(n_theta,1)*360/2-90), 360);
            %ASA~U(-90, +90)
            case 6
                N(:) = mod(C(:) + (rand(n_theta,1)*360/2-90)*T, 360);
            %SA~U(-45, +45)
            case 7
                N(:) = mod(C(:) + rand(n_theta,1)*360/4-45, 360);   
            %ASA~U(-45, +45)
            case 8
                N(:) = mod(C(:) + (rand(n_theta,1)*360/4-45)*T, 360);
        end
    E_n = f(N);
    delta_E = E_c - E_n;
    %If the new vector achieved has a better objective value, then the new
    %vector assumes itself as the reference vector
    if (delta_E > 0)
        C_aux = N;
        C = C_aux;
        E_c = E_n;
    %This feature prevents the method from becoming stuck 
    %at a local minimum that is worse than the global one.
    elseif(exp(-sqrt(-delta_E)/T)>rand(1,1))
        C_aux = N;
        C = C_aux;
        E_c = E_n;
    end
end
%Runtime
time = cputime-time_0;
result = E_c;
theta = C;
end