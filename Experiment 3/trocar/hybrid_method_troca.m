function [result, theta] = hybrid_method(f, n_theta)
C = zeros(n_theta, 1);
N = C;
%Uniform distribution
C = rand(1,n_theta)*360;
T_max = 2;
T_min = 0;
T_interval = 0.05;
E_c = f(C);
for T = T_max:-T_interval:T_min 
    for i = 1:n_theta
        %Uniform distribution
        %N(i) = mod(C(i) + rand(1,1)*360/4*T, 360);
        %Gaussian distribution mu = 0 // sigma = 1
        N(i) = mod(C(i) + normrnd(0,1)*360/4, 360);
    end
    E_n = f(N);
    delta_E = E_c - E_n;
    if (delta_E > 0)
        C_aux = N;
        C = C_aux;
        E_c = E_n;
        %C = gradient_descendent(f, C_aux);
    %This feature prevents the method from becoming stuck 
    %at a local minimum that is worse than the global one.
    elseif(exp(delta_E/T)>rand(1,1))
        C_aux = N;
        C = C_aux;
        E_c = E_n;
        %C = gradient_descendent(f, C_aux);
    end
end
%C = gradient_descendent(f, C);
%C = simulated_annealing(f, C);
theta = C;
result = E_c;
end