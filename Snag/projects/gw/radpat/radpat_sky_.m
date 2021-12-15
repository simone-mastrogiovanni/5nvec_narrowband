function [f_plus,f_per]=radpat_sky_(alpha,delta,eps,psi,azim,lat,long,...
    TH,Nalpha,Ndelta)

% radiation pattern as a function of source position for a fixed time and a
% fixed linear polarization angle

clat=cos(lat);
slat=sin(lat);
cazim=cos(azim);
sazim=sin(azim);
cospsi=cos(psi);
sinpsi=sin(psi);

f_plus(1:Nalpha,1:Ndelta)=0;
f_per(1:Nalpha,1:Ndelta)=0;  
I(1:Ndelta)=1;
j = 1:1:Nalpha;
alpha=(j-1)*2*pi/30;
k = 1:1:Ndelta;
delta=-pi/2+(k-1)*pi/30;
cdelta=cos(delta);
sdelta=sin(delta);
TERM1=cdelta.*clat;
TERM2=sdelta.*slat;
TERM3=sdelta.*clat;
TERM4=cdelta.*slat;
TERM5=cdelta.*cazim;
TERM6=cdelta.*sazim*slat;
TERM7=sdelta.*sazim*clat;
TERM8=cdelta.*sazim;
TERM9=TERM5.*slat;
TERM10=TERM3.*cazim;

CONST1=cospsi.*clat;
CONST2=sinpsi.*clat;
CONST3=sinpsi.*slat;
CONST4=cospsi*slat;

ctheta=-TERM1'*cos(alpha-TH)-TERM2'*I;
stheta=sqrt(1.-ctheta.^2);
spsi=(1./stheta).*(CONST1*I'*sin(alpha-TH)-...
   CONST2*sdelta'*cos(alpha-TH)+CONST3*cdelta'*I);
cpsi=(1./stheta).*(-CONST2*I'*sin(alpha-TH)-...
   CONST1*sdelta'*cos(alpha-TH)+CONST4*cos(delta)'*I);
sphi=(1./stheta).*(-TERM5'*sin(alpha-TH)+TERM6'*cos(alpha-TH)-...
    TERM7'*I);
cphi=-(1./stheta).*(TERM8'*sin(alpha-TH)+TERM9'*cos(alpha-TH)-...
    TERM10'*I);
c2psi=cpsi.^2-spsi.^2;
s2psi=2*spsi.*cpsi;
c2phi=cphi.^2-sphi.^2;
s2phi=2*cphi.*sphi;
%f2=.5*(ctheta.*s2phi).^2;
%f1=.5*(c2phi).^2;	
%f3=f1;
f1=c2phi.*c2psi;
f2=ctheta.*s2phi;
f3=c2phi.*s2psi;
ftheta=.5*(1.+ctheta.^2);
f2_plus_circ=.5*eps*((ftheta.*c2phi).^2+f2.^2);
f2_per_circ=f2_plus_circ;
f2_plus_lin=(1.-eps)*(ftheta.*f1-f2.*s2psi).^2;
f2_per_lin=(1.-eps)*(ftheta.*f3+f2.*c2psi).^2;
f_plus=sqrt(f2_plus_circ+f2_plus_lin);
f_per=sqrt(f2_per_circ+f2_per_lin);
%ftheta=(.5*(1.+ctheta.^2)).^2;
%f_plus=sqrt((ftheta.*f1+f2)');
%f_per=sqrt((ftheta.*f3+f2)');