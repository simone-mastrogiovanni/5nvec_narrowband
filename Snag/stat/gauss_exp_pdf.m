function f=gauss_exp_pdf(p,b,XX,dd)
% GAUSS_EXP_PDF gaussian with exponential disturbance pdf 
%
%      f=gauss_exp_pdf(p,b,XX,dd)
%
%   p      probability of disturbances (def=0.02)
%   b      exponential amplitude (def=5)
%   XX     range (def=10*b if p >0, 20 otherwise)
%   dd     resolution (def=0.01)

% Version 2.0 - January 2007
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

if ~exist('p','var')
    p=0.02;
end
if ~exist('b','var')
    b=5;
end
if ~exist('XX','var')
    if p > 0
        XX=10*b;
    else
        XX=20;
    end
end

if ~exist('dd','var')
    dd=0.01;
end

x=-XX:dd:XX;
n=length(x);
f=(1-p)*exp(-x.^2/2)/sqrt(2*pi);
ip=find(x>=0);
f(ip)=p*exp(-abs(x(ip)/b))/b+f(ip);

f=gd(f);
f=edit_gd(f,'ini',-XX,'dx',dd,'capt','gauss-laplace pdf');