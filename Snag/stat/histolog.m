function h=histologdens(a,n,range)
% HISTOLOGDENS  histogram with linearly growing bins
%           it is obtained with log the input
%
%       h=histologdens(a,n,range)
%
%   a      input data (array or gd)
%   n      number of bins
%   range  [min,max]  (if doesn't exist, the min and the max of a)
%
%   h     output gd

% Version 2.0 - January 2007
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

if isa(a,'gd')
    a=y_gd(a);
end
if ~exist('n','var')
    n=200;
end

na0=length(a);
a=a(find(a>0));
na=length(a);

if ~exist('range','var')
    range=[min(a) max(a)];
end

if na0-na > 0
    disp(sprintf(' %d non-positive data',na0-na))
end

a=log(a);
lamax=log(range(2));
lamin=log(range(1));
dx=(lamax-lamin)/(n+.00001);

x=lamin:dx:lamax;

h=histc(a,x);

x=exp(x);

h=h(1:n)./(diff(x)*na);
stairs(x,[h h(n)]), grid on
x=x(1:n)+diff(x)/2;

h=gd(h);
h=edit_gd(h,'x',x,'capt','histologdens');