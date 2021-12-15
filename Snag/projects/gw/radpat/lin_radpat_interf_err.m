function f=lin_radpat_interf(source,antenna,tsid)
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

% New version May 2009, C. Palomba
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

alpha=source.a/180.*pi;
del=source.d/180.*pi;
%eps=source.eps;
psi=source.psi/180.*pi;
a=antenna.azim/180.*pi;
lam=antenna.lat/180.*pi;
long=antenna.long/180.*pi;
TH=tsid/12*pi;

a0=-(3/16)*(1+cos(2*del))*(1+cos(2*lam))*cos(2*a);
a1c=-(1/4)*sin(2*del)*sin(2*lam)*cos(2*a);
a1s=(1/2)*sin(2*del)*cos(lam)*sin(2*a);
a2c=-(1/16)*(3-cos(2*del))*(3-cos(2*lam))*cos(2*a);
a2s=(1/4)*(3-cos(2*del))*sin(lam)*sin(2*a);

b1c=-cos(del)*cos(lam)*sin(2*a);
b1s=-(1/2)*cos(del)*sin(2*lam)*cos(2*a);
b2c=-sin(del)*sin(lam)*sin(2*a);
b2s=-(1/4)*sin(del)*(3-cos(2*lam))*cos(2*a);

f1=a0+a1c*cos(alpha-TH)+a1s*sin(alpha-TH)+a2c*cos(2*alpha-2*TH)+a2s*sin(2*alpha-2*TH);
f2=b1c*cos(alpha-TH)+b1s*sin(alpha-TH)+b2c*cos(2*alpha-2*TH)+b2s*sin(2*alpha-2*TH);
f=f1*cos(2*psi)+f2*sin(2*psi);

