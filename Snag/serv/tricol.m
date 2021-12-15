function tcol=tricol(k,n)
%TRICOL  color toning from 3 colors
%
%   n      total number of toning
%   k      asked number

% Version 2.0 - October 2005
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1998  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

n1=n-1;
% n11=round(3*n1/8);
% n12=round(5*n1/8);
% n21=round(3*n1/8);
% n22=round(6*n1/8);
% n31=round(4*n1/8);
% n32=round(6*n1/8);
n11=3*n1/8;
n12=5*n1/8;
n21=3*n1/8;
n22=5.5*n1/8;
n31=4*n1/8;
n32=5.5*n1/8;

i1=0;i2=0;i3=0;

if k <=n11
    i1=1;
end
if k > n11 & k < n12
    i1=1-(k-n11)/(n12-n11);
end

if k <n21
    i2=(k-1)/(n21-1);
end
if k >= n21 & k < n22
    i2=1;
end
if k > n22 & k < n1
    i2=1-(k-n22)/(n1-n22);%k,n21,n1,n22
end

if k >=n32
    i3=1;
end
if k > n31 & k < n32
    i3=(k-n31)/(n32-n31);
end

if k == 1
    i1=0.8;
end
if k > n1
    i1=0;i2=0;i3=0;
end
if k == n1
    i3=0.8;
end

tcol=[i1 i2 i3];