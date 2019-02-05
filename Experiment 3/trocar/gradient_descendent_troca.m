function theta_ref1 = gradient_descendent(f, theta)
lambda = 10^(-4);
c1 = 0.1;
theta_ref1 = theta;
f_theta1 = f(theta_ref1);
gradient_1 = zeros(1, size(theta, 2));
for i=1:size(theta, 2)
vector_zeros = zeros(1, size(theta, 2));
vector_zeros(i) = lambda;
gradient_1(i) = (f(theta_ref1+ vector_zeros)-f_theta1)/lambda;
end
alpha = 10;
theta_ref2 =  theta_ref1 - alpha*gradient_1;
f_theta2 = f(theta_ref2);
time_0 = cputime;

while (cputime <time_0+10)
    %approximation from the finite difference method
        if (f_theta2 <= f_theta1 - c1*alpha*(gradient_1*gradient_1'))
            theta_ref1 = theta_ref2;
            f_theta1 = f_theta2;
                for i=1:size(theta, 2)
                vector_zeros = zeros(1, size(theta, 2));
                vector_zeros(i) = lambda;
                gradient_1(i) = (f(theta_ref1+ vector_zeros)-f_theta1)/lambda;
                end
            alpha = min([alpha 0.05/max(gradient_1)]);
            theta_ref2 =  theta_ref1 - alpha*gradient_1;
            f_theta2 = f(theta_ref2);
        else
            alpha = alpha/2;
            theta_ref2 =  theta_ref1 - alpha*gradient_1;
            f_theta2 = f(theta_ref2);
        end
end
end