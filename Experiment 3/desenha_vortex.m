function desenha_vortex(matrix, tumor, size_m)
[dim_i,dim_j, dim_z] = size(matrix);
%Draw the set of voxels
for z = 1:dim_z
    for j = 1:dim_j
        for i = 1:dim_i
            %Search of the vertex relative to the voxels that are going to be constructed.
            %Starts at the extreme of the negative set
            origem_i = (-(dim_i-1)/2 +i-1.0-1/2)*size_m;
            origem_j = (-(dim_j-1)/2 +j-1.0-1/2)*size_m;
            origem_z = (-(dim_z-1)/2 +z-1.0-1/2)*size_m;
            if((matrix(i, j, z) == 1) && (tumor == 1))
                cube([origem_i,origem_j,origem_z], size_m, size_m, size_m, 0,'r');
            %In case of voxels that represent tumor organs, the program 
            %will draw them in red, otherwise will draw them in green
            elseif ((matrix(i, j, z) == 1) && (tumor ~= 1))
                cube([origem_i,origem_j,origem_z], size_m, size_m, size_m, 0,'b');
            end
        end
   end
end

end