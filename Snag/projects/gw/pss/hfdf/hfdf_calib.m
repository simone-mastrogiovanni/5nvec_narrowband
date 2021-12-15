function h=hfdf_calib(calib,fr,N,kcal)
% "Conventional" calibration of an Hough map
%
%   h=hfdf_calib(calib,fr,N,kcal)
%
%  calib   Hough calibration data-base structure or run string ('VSR2' or 'VSR4')
%           (IN LIGO MEAN EQUIVALENT UNITS)
%  fr      frequency (single or one for each amplitude)
%  N       Hough amplitude
%  kcal    which calibration (def 2)
%
%  h       wave amplitude (in our standard)
%

% Version 2.0 - February 2014
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

n=length(N);
if length(fr) == 1
    fr(1:n)=fr;
end
h=N*0;

wsp=calib.wsp;
ywsp=y_gd(wsp);
ywsp=[ywsp; ywsp(length(ywsp))];
inif=ini_gd(wsp);
df=dx_gd(wsp);
nwientot=calib.nwientot;
nwientot=[nwientot nwientot(length(nwientot))];

if ~exist('kcal','var')
    kcal=2;
end

dat=calib.dat(kcal);

frin=dat.frin;
frfi=dat.frfi;
m0=dat.An;
pend=dat.retta(1);
yint=dat.retta(2);
xint=-dat.retta(2)/dat.retta(1);

i1=round((frin-inif)/df)+1;
i2=round((frfi-inif)/df);

wsp0=mean(ywsp(i1:i2));
nwien0=mean(nwientot(i1:i2));

for i = 1:n
    ii=round((fr(i)-inif)/df)+1;
    wsp1=ywsp(ii);
    nwien1=nwientot(ii);
    m=m0*nwien1/nwien0;
    DA=N(i)-m;
    DA0=DA*m0/m;
    h2=DA0*pend+yint;
    if h2 > 0
        h(i)=sqrt(h2*wsp1/wsp0);
    else
        h(i)=0;
    end
end

h=h/1.28;  % ATTENTION ! In this way we have "our" H