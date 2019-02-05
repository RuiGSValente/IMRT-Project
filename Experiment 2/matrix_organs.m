%Function that gives the value 1 to the elements of matrix A that contain
%the value indicated. This is necessary to distinguish and separate the 
%different structures from matrix A
function matrix = matrix_organs(A, value)
[dim_i,dim_j, dim_z] = size(A);
matrix = zeros(dim_i, dim_j, dim_z);
for z = 1:dim_z
    for j = 1:dim_j
        for i = 1:dim_i
            if (A(i, j, z) == value)
                matrix(i, j, z) = 1;
            end
        end
    end
end
end
