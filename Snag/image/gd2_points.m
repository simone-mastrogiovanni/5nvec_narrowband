function out=gd2_points(g2,iclog,tits)
% plots points for a gd2
%
%  out=gd2_points(g2)
%

% Version 2.0 - September 2014 
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

if ~exist('iclog','var')
    iclog=0;
end
if ~exist('tits','var')
    tits={' ' ' ' ' '};
end

A=y_gd2(g2);
x1=x_gd2(g2);
x2=x2_gd2(g2);
[m1,m2]=size(A);
Y=zeros(m1*m2,3);
k=1;

for i = 1:m1
    Y(k:k+m2-1,1)=x1(i);
    Y(k:k+m2-1,2)=x2(1:m2);
    Y(k:k+m2-1,3)=A(i,:);
    k=k+m2;
end
 
outc=color_points(Y,iclog,tits);

out.Y=Y;
out.scale=outc.scale;