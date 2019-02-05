function desenha_bixel(matrix, theta, size_A, size_B, height, dim_b)
[dim_i,dim_j, dim_z] = size(matrix);
dim_i_b = dim_b/size_B;
dim_j_b = dim_b/size_B;
%Number of beam angles considered
theta_n = size(theta, 2);
%Initialization of the matrices that represent the bixels that are 
%allowing the passing of bundles and respective cost of affected voxels
B = zeros(dim_i,dim_j, theta_n);


%Reference for the number of light beams considered
for t = 1:theta_n
    for z = 1:dim_z
        for j = 1:dim_j
            for i = 1:dim_i
                if (matrix(i, j, z)==1)
                %Calculation of the center of each voxel of the structure
                centro_i= (-(dim_i-1)/2 +i-1.0)*size_A;
                centro_j = (-(dim_j-1)/2 +j-1.0)*size_A;
                centro_z = (-(dim_z-1)/2 +z-1.0)*size_A;
                centro = [centro_i; centro_j; centro_z];
                matrix_rot = [cosd(-theta(t)) 0 sind(-theta(t)); 0 1 0; -sind(-theta(t)) 0 cosd(-theta(t))];                
                %Application of the rotation matrix to the voxel point
                centro = matrix_rot*centro; 
                for k =  1:dim_j_b
                    for l = 1:dim_i_b
                        %Location of the center point of each bixel considered
                        bixel_i = (-(dim_i_b-1)/2 +l-1.0)*size_B;
                        bixel_j = (-(dim_j_b-1)/2 +k-1.0)*size_B;
                        %inf and sup limits of each bixel
                        x_min = bixel_i - size_B/2;
                        x_max = bixel_i + size_B/2;
                        y_min = bixel_j - size_B/2;
                        y_max = bixel_j + size_B/2;
                        %if the center point of the voxel is contained 
                        %within the range of the light beam of the bixel 
                        %considered, then the bixel will be switched on
                        if((centro(1)>=x_min) && (centro(1)<x_max || ((centro(1)<=x_max)&&(l == dim_i_b))) && (centro(2)>=y_min) && ((centro(2)<y_max) || ((centro(2)<=y_max)&&(k==dim_j_b))))
                               B(l,k) = 1;
                        end
                    end
                end    
                end
            end
        end
    end
    %Draw the set of bixels relative to theta angle
    for j = 1:dim_j_b
        for i = 1:dim_i_b
            %Position of each bixel in relation to i and j
            origem_i = (-(dim_i_b-1)/2 +i-1.0-1/2)*size_B;
            origem_j = (-(dim_j_b-1)/2 +j-1.0-1/2)*size_B;
            origem_z = (-(dim_z-1)/2 +z-1.0-1/2)*size_B;
            %If the bixel is marked with a value of 1, it is drawn
            if( B(i, j) == 1)
                %Function that draws the bixels relative to the position of
                %the radiation source
                cube([origem_i,origem_j,origem_z+height], size_B, size_B, size_B/100,theta(t),'y');
            else
                cube([origem_i,origem_j,origem_z+height], size_B, size_B, size_B/100,theta(t),'k');
            end
        end
    end
end
end