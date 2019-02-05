function theta_ref1 = steepest_descendent(f, theta, time_limit)
%parameter for finite difference method
lambda = 10^(-4);
%parameter of sufficient descent condition
c1 = 0.1;
%theta inputed
theta_ref1 = theta;
%Objective value of theta inputed
f_theta1 = f(theta_ref1);
%initizalition of vector representing the partial derivatives
gradient_1 = zeros(1, size(theta, 2));
%Finite difference method
for i=1:size(theta, 2)
vector_zeros = zeros(1, size(theta, 2));
vector_zeros(i) = lambda;
gradient_1(i) = (f(theta_ref1+ vector_zeros)-f_theta1)/lambda;
end
alpha = 10;
%Application of SD method
theta_ref2 =  theta_ref1 - alpha*gradient_1;
f_theta2 = f(theta_ref2);
time_0 = cputime;
%Execute the SD method for time_limit seconds
while (cputime <time_0+time_limit)
    %Approximation from the finite difference method
        if (f_theta2 <= f_theta1 - c1*alpha*(gradient_1*gradient_1'))
            theta_ref1 = theta_ref2;
            f_theta1 = f_theta2;
            %Calculation of the Finite difference method for the new angle
                for i=1:size(theta, 2)
                vector_zeros = zeros(1, size(theta, 2));
                vector_zeros(i) = lambda;
                gradient_1(i) = (f(theta_ref1+ vector_zeros)-f_theta1)/lambda;
                end
            %Calculation of new theta_ref2;
            theta_ref2 =  theta_ref1 - alpha*gradient_1;
            f_theta2 = f(theta_ref2);
        else
            %Reduction of parameter alpha when f_theta2>f_theta_1
            alpha = alpha/2;
            %Calculation of theta_ref2 with anew value for alpha
            theta_ref2 =  theta_ref1 - alpha*gradient_1;
            f_theta2 = f(theta_ref2);
        end
end
end