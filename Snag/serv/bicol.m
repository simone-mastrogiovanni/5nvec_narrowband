function tcol=bicol(k,n)
%BICOL  color toning from 2 colors
%
%   n      total number of toning
%   k      asked number

% Version 2.0 - October 2005
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1998  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

n1=floor(n/2);
n2=n-n1;
green=(0:(n1-1))/(n1-1);
red=1-green;
red(n1+1:n)=0;
blue(1:n1)=0;
blue(n1+1:n)=(0:(n2-1))/(n2-1);
green(n1+1:n)=1-blue(n1+1:n);

tcol=[1 0 0]*red(k)+[0 1 0]*green(k)+[0 0 1]*blue(k);

% tcol=tcol/sum(tcol);
     