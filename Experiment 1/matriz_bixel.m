function custo = matriz_bixel(organ_matrix, theta, size_A, size_B, dim_b)

%Reference to the voxel array size
[dim_i,dim_j, dim_z] = size(organ_matrix);

%Reference to bixel matrix size
dim_i_b = dim_b/size_B;
dim_j_b = dim_b/size_B;

%Matrices' initialization that represent that bixels that are allowing 
%the passing of beamlets and the respective cost of affected voxels
custo = NaN(dim_i*dim_j*dim_z, dim_i_b*dim_j_b);

    %Loop that considers all voxels from the considered structure
    for z = 1:dim_z
        for j = 1:dim_j
            for i = 1:dim_i
                if (organ_matrix(i, j, z) == 1)
                    
                %Calculation of the center of each voxel from structure
                centro_i= (-(dim_i-1)/2 +i-1)*size_A;
                centro_j = (-(dim_j-1)/2 +j-1)*size_A;
                centro_z = (-(dim_z-1)/2 +z-1)*size_A;
                centro = [centro_i; centro_j; centro_z];
                matrix_rot = [cosd(-theta) 0 sind(-theta); 0 1 0; -sind(-theta) 0 cosd(-theta)];
                
                %Application of the inverted rotation matrix to the voxel point
                centro = matrix_rot*centro; 
                
                %Cost calculation
                for k =  1:dim_j_b
                    for l = 1:dim_i_b
                        
                        %Location of the center point of each bixel considered
                        bixel_i = (-(dim_i_b-1)/2+l-1.0)*size_B;
                        bixel_j = (-(dim_j_b-1)/2+k-1.0)*size_B;
                        
                        %Inf and sup limits of each bixel
                        x_min = bixel_i - size_B/2;
                        x_max = bixel_i + size_B/2;
                        y_min = bixel_j - size_B/2;
                        y_max = bixel_j + size_B/2;
                        
                        %If the center point of the voxel is contained within 
                        %the range of the light beam of the bixel considered, 
                        %then the cost will be added
                        if((centro(1)>=x_min) && (centro(1)<x_max || ((centro(1)<=x_max)&&(l == dim_i_b))) && (centro(2)>=y_min) && ((centro(2)<y_max) || ((centro(2)<=y_max)&&(k==dim_j_b))))
                           
                            %The values of the matrix passed in the form of NaN 
                            %or of the value of the height relative to the 
                            %beamle considered
                            custo((z-1)*dim_i*dim_j + (i-1)*dim_j + j, (k-1)*dim_i_b + l) = centro(3);
                        end   
                    end
                end    
                end
            end
        end
    end
end
