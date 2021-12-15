function y=peak_pdf_gd(sig,maxx,n,hdens)
%PEAK_PD_GDF   distribution of spectral peaks
%
%    sig    signal spectral amplitude
%    maxx   max peak amplitude
%    n      number of points
%    hdens  =1 -> square root of spectrum
%
% The spectral noise has unitary mean value
%
%   Needs the Statistical toolbox

if hdens
    ex=2;
    capt='peak pdf on hdens';
else
    ex=1;
    capt='peak pdf on spectrum';
end

dx=maxx/(n-1);
x=0:dx:maxx;
x=x.^ex;

c1=2/3;
y1=2*ncx2pdf(2*x,2,2*sig);
y=y1.*((1-exp(-x)).^2)./(1-c1.^(1+sig));

y=gd(y);
y=edit_gd(y,'dx',dx);

if hdens == 1
    y=pdf2cdf(y,0,1);
end

y=edit_gd(y,'capt',capt);