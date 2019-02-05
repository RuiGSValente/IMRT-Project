function [f_min, time_min, theta_min] = simulated_annealing(f, n_theta, method)
%Vector initialization 
N = zeros(1, n_theta);
%Generation of a random vector with n_theta angles
C = rand(1,n_theta)*360;
%Maximum temperature
T = 5;
T_interval = 199/200;
%Calculation of objective value of vector C
E_c = f(C);
f_min = E_c;
%Variable to save the time when the x_min is found
time_min = 0;
%Initial time
time_0 = cputime;
while(cputime <time_0+300)
        switch method
            %SA~N(0, 90^2)
            case 1
                N(:) = mod(C(:) + normrnd(0,1, n_theta, 1)*360/8, 360);        
            %ASA~N(0, 90^2)
            case 2
                N(:) = mod(C(:) + normrnd(0,1, n_theta, 1)*360/8*T, 360);        
            %SA~N(0, 90^2)
            case 3
                N(:) = mod(C(:) + normrnd(0,1, n_theta, 1)*360/4, 360);        
            %ASA~U(-90, 90)
            case 4
                N(:) = mod(C(:) + normrnd(0,1, n_theta, 1)*360/4*T, 360);        
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
    if (E_c<f_min)
        f_min = E_c;
        theta_min = C;
        time_min = cputime-time_0; 
    end
    T = T*T_interval;
end
end