function [result, time, theta_min] = simulated_annealing(f, n_theta, method)
%Vector initialization 
N = zeros(1, n_theta);
%Generation of a random vector with n_theta angles
C = rand(1,n_theta)*360;
%Maximum temperature
%T = 5;
%T_int = 199/200;
T_max = 5;
T_min = 0;
T_interval = 0.005;
%Calculation of objective value of vector C
E_c = f(C);
%f_min = E_c;
%time_min = 0;
%time_0 = cputime;
for T=T_max:-T_interval:T_min
%while(cputime <time_0+300)
%    time_1=cputime;
%    while(cputime<time_1+20)
            %Gaussian distribution mu = 0 // sigma = 1
            %SA~N(0, 45^2)
            if method == 1
            N(:) = mod(C(:) + normrnd(0,1, n_theta, 1)*360/8, 360);        
            end
            %ASA~N(0, 45^2)
            if method == 2
            N(:) = mod(C(:) + normrnd(0,1, n_theta, 1)*360/8*T, 360);        
            end
            %SA~N(0, 90^2)
            if method == 3
            N(:) = mod(C(:) + normrnd(0,1, n_theta, 1)*360/4, 360);        
            end
            %ASA~N(0, 90^2)
            if method == 4
            N(:) = mod(C(:) + normrnd(0,1, n_theta, 1)*360/4*T, 360);        
            end
            %Uniform distribution
            %SA~U(-90, +90)
            if method == 5
            N(:) = mod(C(:) + (rand(n_theta,1)*360/2-90), 360);
            end
            %ASA~U(-90, +90)
            if method == 6
            N(:) = mod(C(:) + (rand(n_theta,1)*360/2-90)*T, 360);
            end
            %SA~U(-45, +45)
            if method == 7
            N(:) = mod(C(:) + rand(n_theta,1)*360/4-45, 360);
            end
            %ASA~U(-45, +45)
            if method == 8
            N(:) = mod(C(:) + (rand(n_theta,1)*360/4-45)*T, 360);
            end
        E_n = f(N);
        delta_E = E_c - E_n;
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
%         if (E_c<f_min)
%         f_min = E_c;
%         theta_min = C;
%         time_min = cputime-time_0; 
%         end
%        T = T*T_int;
%    end
%     C = gradient_descendent(f, C);
%     if (f(C)<f_min)
%     f_min = f(C);
%     theta_min = C;
%     end
end

% C = gradient_descendent(f, theta_min);
% if (f(C)<f_min)
% f_min = f(C);
% theta_min = C;
% end
% f_min
time = time_min;
result = f_min;
%result = E_c;
end