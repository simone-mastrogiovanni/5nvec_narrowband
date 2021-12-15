function g=gen_sid_resp(sour,ant,n)
%GEN_SID_RESP   sidereal response to gw for general detector
%
%   sour,ant  source and antenna structure
%     n       number of sidereal time points

% Version 2.0 - December 2003
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Cristiano Palomba & Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

tsid=(0:(1/n):(1-1/n))*24;
t=tsid*pi/12;

alpha=sour.a*pi/180;

talpha=sour.a*pi/180-t;
ctalpha=cos(talpha);
stalpha=sin(talpha);
ctalpha2=cos(2*talpha);
stalpha2=sin(2*talpha);
delta=sour.d*pi/180;
cdelta=cos(delta);
sdelta=sin(delta);
cdelta2=cos(2*delta);
sdelta2=sin(2*delta);
psi=sour.psi*pi/180;
cpsi=cos(psi);
spsi=sin(psi);
cpsi2=cos(2*psi);
spsi2=sin(2*psi);

lambda=ant.lat*pi/180;
clambda=cos(lambda);
slambda=sin(lambda);
clambda2=cos(2*lambda);
slambda2=sin(2*lambda);
azim=ant.azim*pi/180;
cazim=cos(azim);
sazim=sin(azim);
cazim2=cos(2*azim);
sazim2=sin(2*azim);

M33=spsi2*((1/2+1/2*clambda2)*sin(2*alpha-2*t)*sdelta-...
        slambda2*cdelta*sin(alpha-t))+...
        cpsi2*((3/4-1/4*cdelta2)*clambda^2*cos(2*alpha-2*t)-...
        1/2*slambda2*cos(alpha-t)*sdelta2+(1/2*clambda^2-...
        clambda2)*cdelta^2);
    
M23=spsi2*(cos(alpha-t)*(-sazim)*cdelta*slambda-...
        cos(-2*t+2*alpha)*(-sazim)*sdelta*clambda-...
        1/2*sin(-2*t+2*alpha)*(-cazim)*sdelta*slambda2-...
        sin(alpha-t)*(-cazim)*cdelta*clambda2)+...
        cpsi2*((3/4-1/4*cdelta2)*clambda*(-sazim)*...
        sin(-2*t+2*alpha)+(-3/8+1/8*cdelta2)*slambda2*(-cazim)*...
        cos(-2*t+2*alpha)-1/2*sin(alpha-t)*sdelta2*(-sazim)*slambda-...
        1/2*cos(alpha-t)*sdelta2*(-cazim)*clambda2+...
        (3/8+3/8*cdelta2)*slambda2*(-cazim));
    
M22=spsi2*((-3/4*(-cos(2*azim))+1/4*(-cos(2*azim))*clambda2-1/4-...
        1/4*clambda2)*sdelta*sin(-2*t+2*alpha)+cos(alpha-t)*...
        cdelta*clambda*sin(2*azim)+sin(alpha-t)*cdelta*...
        slambda2*(-cazim)^2+cos(-2*t+2*alpha)*sdelta*slambda*...
        sin(2*azim))+...
        cpsi2*((-3/4+1/4*cdelta2)*slambda*...
        sin(2*azim)*sin(-2*t+2*alpha)+(3/4-1/4*cdelta2)*...
        (-(1/2+1/2*clambda2)*(-cazim)^2+cazim2)*cos(-2*t+2*alpha)+...
        (1/8+1/8*cdelta2)*(3*clambda2-1)*(-cazim)^2+...
        (-1/4-1/4*cdelta2)*(-cazim2)+1/2*cos(alpha-t)*sdelta2*...
        slambda2*(-cazim)^2-1/2*sin(alpha-t)*sdelta2*clambda*...
        sin(2*azim));
    
M12=spsi2*((-3/4+1/4*clambda2)*sin(2*azim)*sdelta*...
        sin(-2*t+2*alpha)-cos(alpha-t)*cdelta*clambda*(-cazim2)-...
        cos(-2*t+2*alpha)*sdelta*slambda*(-cazim2)-...
        1/2*sin(alpha-t)*cdelta*slambda2*sazim2)+...
        cpsi2*((3/4-1/4*cdelta2)*slambda*(-cazim2)*...
        sin(-2*t+2*alpha)+(3/16-1/16*cdelta2)*(clambda2-3)*...
        sazim2*cos(-2*t+2*alpha)+1/2*sin(alpha-t)*(-cazim2)*...
        sdelta2*clambda-1/4*cos(alpha-t)*sazim2*sdelta2*...
        slambda2-(3/16+3/16*cdelta2)*(clambda2+1)*sazim2);
    
M13=spsi2*(1/2*sin(-2*t+2*alpha)*sdelta*(-sazim)*...
        slambda2-cos(-2*t+2*alpha)*sdelta*(-cazim)*clambda+...
        cos(alpha-t)*cdelta*(-cazim)*slambda+sin(alpha-t)*...
        cdelta*(-sazim)*clambda2)+...
        cpsi2*((3/4-1/4*cdelta2)*clambda*(-cazim)*...
        sin(-2*t+2*alpha)+(3/8-1/8*cdelta2)*slambda2*(-sazim)*...
        cos(-2*t+2*alpha)-1/2*sin(alpha-t)*(-cazim)*slambda*sdelta2+...
        1/2*cos(alpha-t)*(-sazim)*sdelta2*clambda2+...
        (-3/8-3/8*cdelta2)*slambda2*(-sazim));
    
M11=spsi2*((1/2*(-cazim2)+1/2)*cdelta*slambda2*...
        sin(alpha-t)+((-1/4-1/4*(-cazim2))*clambda2-1/4+...
        3/4*(-cazim2))*sdelta*sin(-2*t+2*alpha)-cos(-2*t+2*alpha)*...
        sdelta*slambda*sazim2-cos(alpha-t)*cdelta*...
        clambda*sazim2)+...
        cpsi2*((-3/4+1/4*cdelta2)*...
        slambda*sazim2*sin(2*t-2*alpha)+(1/16*cdelta2-3/16)*...
        ((-cazim2+1)*clambda2+3*cazim2+1)*cos(2*t-2*alpha)-...
        1/2*sin(-alpha+t)*clambda*sdelta2*sazim2+...
        1/2*cos(-alpha+t)*(-sazim)^2*slambda2*sdelta2+...
        (3/16+3/16*cdelta2)*(clambda2+1)*(-cazim2)-...
        (1/16*cdelta2+1/16)*(-3*clambda2+1));
    
switch ant.type
    case 1
        r=-M11-M22+2*M33;
    case 2
        r=M11-M22;
    case 3
        r=M11;
    case 4
        r=M12;
    case 5
        r=M13;
    case 6
        r=M22;
    case 7
        r=M23;
    case 8
        r=M33;
end

g=gd(r);
g=edit_gd(g,'dx',24/n);