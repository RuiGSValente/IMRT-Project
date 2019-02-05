function cube(origin,X,Y,Z,theta, color)
ver = [1 1 0;
    0 1 0;
    0 1 1;
    1 1 1;
    0 0 1;
    1 0 1;
    1 0 0;
    0 0 0];

%Define cube faces
fac = [1 2 3 4;
    4 3 5 6;
    6 7 8 5;
    1 2 8 7;
    6 7 1 4;
    2 3 5 8];
%Rotation matrix
matrix_rot = [cosd(theta) 0 sind(theta); 0 1 0; -sind(theta) 0 cosd(theta)];

%Matrix to assign the vertices to their respective positions
matrix_aux = [ver(:,1)*X+origin(1) ver(:,2)*Y+origin(2) ver(:,3)*Z+origin(3)];

%Application of the rotation matrix to the vertices of the auxiliary matrix
matrix_aux = (matrix_rot*matrix_aux')';

%Bixels drawing
cube = [matrix_aux(:,1),matrix_aux(:,2),matrix_aux(:,3)];
patch('Faces',fac,'Vertices',cube,'FaceColor',color);
end
