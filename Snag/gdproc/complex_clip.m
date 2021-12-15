function cl=complex_clip(in,thr)
% puts to zero values of a complex gd with higher than thr abs values
%
%       cl=complex_clip(in,thr)
%

% Version 2.0 - April 2016
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

y=y_gd(in);
a=abs(y);
i=find(a > thr);
y(i)=0;

cl=edit_gd(in,'y',y);

fprintf('cleaned fraction: %f\n',length(i)/length(a));