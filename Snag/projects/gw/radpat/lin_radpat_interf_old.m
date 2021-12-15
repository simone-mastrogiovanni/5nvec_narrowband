function f=lin_radpat_interf_old(source,antenna,tsid)
%LIN_RADPAT_INTERF  interferometric detector linear response to a source
%                      (only linear polarization)
%
%   antenna:     antenna structure
%           .lat    longitude (deg)
%           .long   latitude (deg)
%           .azim   azimuth (deg) (detector x-arm, from south to west)
%           .incl   inclination (deg) (to be implemented)
%
%   source      source structure
%           .a      right ascension (degree)
%           .d:     declination (degree)
%           .psi    linear polarization angle
%           .eps    percentage of linear polarization
%
%   tsid       sidereal time (hour)
%

% July 2003, C. Palomba
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

alpha=source.a/180.*pi;
delta=source.d/180.*pi;
eps=source.eps;
psi=source.psi/180.*pi;
azim=antenna.azim/180.*pi;
lat=antenna.lat/180.*pi;
long=antenna.long/180.*pi;
TH=tsid/12*pi;
Nstep=1;

clat=cos(lat);
slat=sin(lat);
cazim=cos(azim);
sazim=sin(azim);
cospsi=cos(psi);
sinpsi=sin(psi);

ndim=length(source.a);
I(1:ndim)=1;

cdelta=cos(delta);
sdelta=sin(delta);
term1=cdelta.*clat;
term2=sdelta.*slat;
term3=sdelta.*clat;
term4=cdelta.*slat;
term5=-cdelta.*sazim;
term6=-cdelta.*cazim*slat;
term7=-sdelta.*cazim*clat;
term8=-cdelta.*cazim;
term9=term5.*slat;
term10=-term3.*sazim;
term11=cospsi.*clat;
term12=sinpsi.*clat;
term13=sinpsi.*slat;
term14=cospsi*slat;

ctheta=-term1'*cos(alpha-TH)-term2'*I;
psi1=atan2(term11*I'*sin(alpha-TH)-term12*sdelta'*cos(alpha-TH)+...
    term13*cdelta'*I,-term12*I'*sin(alpha-TH)-...
   term11*sdelta'*cos(alpha-TH)+term14*cdelta'*I);
phi1=-atan2(-term5'*sin(alpha-TH)+term6'*cos(alpha-TH)-term7'*I,...
    term8'*sin(alpha-TH)+term9'*cos(alpha-TH)-term10'*I);
c2psi=cos(2*psi1);
s2psi=sin(2*psi1);
c2phi=cos(2*phi1);
s2phi=sin(2*phi1);

f1=c2phi.*c2psi;
f2=ctheta.*s2phi;
f3=c2phi.*s2psi;
ftheta=.5*(1.+ctheta.^2);
f2_lin=(ftheta.*f1-f2.*s2psi);
f=f2_lin;