function g=gd_smooth_old(varargin)
%GD_SMOOTH smooth a gd operating in the frequency domain
%
% keys :
%   'perc'    percentage of smoothing (0->1)
%   'slope'   slope of low pass (2 min -> 20 max)

% Version 1.0 - July 1998
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1998  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

g=varargin{1};

perc=0.5;
slop=6;

for i=2:2:length(varargin)
   strin=varargin{i};
   switch strin
   case 'perc'
      perc=varargin{i+1};
   case 'slope'
      slop=varargin{i+1};
   end
end

a=y_gd(g);
am=mean(a);
n=n_gd(g);

len2=2^ceil(log2(n));

a(n+1:len2)=am;
b=fft(a);

x1=-perc*slop*2;
x2=(1-perc)*slop*2;
dx=slop*2/(len2/2-1);

x=x1:dx:x2;
w=zeros(1,len2);

w(1:len2/2)=(1-erf(x))/2;

for i=2:len2/2
   w(len2+2-i)=w(i);
end

b=b.*w.';
a=ifft(b);

g=edit_gd(g,'y',a(1:n),'addcapt','smoothing on:');

