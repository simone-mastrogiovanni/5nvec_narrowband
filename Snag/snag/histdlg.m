function x=histdlg(d)
%HISTDLG  interactively sets the parameters for an histogram
%
%   x  are the centers of the bins

% Version 1.0 - July 1998
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1998  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome  

promptcg={'x min','x max','number of bins'};
x1=min(real(d));
x2=max(real(d));
defacg={sprintf('%d',x1),sprintf('%d',x2),'500'};
a=inputdlg(promptcg,'Histogram parameters',1,defacg);
x1=str2num(a{1});
x2=str2num(a{2});
n=str2num(a{3});
dx=(x2-x1)/n;

x=zeros(1,n);
x(1)=x1+dx/2;

for i = 2:n
   x(i)=x(i-1)+dx;
end
