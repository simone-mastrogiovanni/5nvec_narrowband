function [ix iy z]=sorted_mat(A,n)
%
%  sorts values of a matrix 
%
%    A the matrix, n the number of values

% Version 2.0 - July 2012
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

[n1 n2]=size(A);

[z ii]=sort(A(:),'descend');
ii=ii(1:n);
z=z(1:n);

iy=floor((ii-1)/n1)+1;
ix=ii-(iy-1)*n1;

for i = 1:n
    fprintf('%d: %d  %d   %f \n',i,ix(i),iy(i),z(i))
end