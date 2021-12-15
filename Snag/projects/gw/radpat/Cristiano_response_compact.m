function Cristiano_response()
% (alpha_d,delta_d): source celestial coordinates (degree)
% lambda_d: detector latitude (degree)
% psi_d: wave polarization angle (degree)
% azim_d: detector azimuth (degree)
% t: rotation velocity x time (rad)
%
% M_{ij}: elements of the detector response matrix for + polarization.
% In order to get the M_{ij} for X polarization, rotate psi by pi/4.

alpha_d=83.5;
delta_d=23.01;
lambda_d=43.67;
psi_d=60.0;
azim_d=198.61;
alpha=alpha_d/180*pi;
delta=delta_d/180*pi;
lambda=lambda_d/180*pi;
psi=psi_d/180*pi;
a=azim_d/180*pi;

cdelta=cos(delta);
sdelta=sin(delta);
clambda=cos(lambda);
slambda=sin(lambda);
cpsi=cos(psi);
spsi=sin(psi);
cazim=cos(a);
sazim=sin(a);
%cbeta=cos(beta);
%sbeta=sin(beta);
calpha=cos(alpha);
salpha=sin(alpha);

time=1:1024;
t=time/1024*2*pi;

M33=sin(2*psi)*((1/2+1/2*cos(2*lambda))*sin(2*alpha-2*t)*sin(delta)-...
        sin(2*lambda)*cos(delta)*sin(alpha-t))+...
        cos(2*psi)*((3/4-1/4*cos(2*delta))*cos(lambda)^2*cos(2*alpha-2*t)-...
        1/2*sin(2*lambda)*cos(alpha-t)*sin(2*delta)+(1/2*cos(lambda)^2-...
        cos(2*lambda))*cos(delta)^2);
    
    M23=sin(2*psi)*(cos(alpha-t)*(-sin(a))*cos(delta)*sin(lambda)-...
        cos(-2*t+2*alpha)*(-sin(a))*sin(delta)*cos(lambda)-...
        1/2*sin(-2*t+2*alpha)*(-cos(a))*sin(delta)*sin(2*lambda)-...
        sin(alpha-t)*(-cos(a))*cos(delta)*cos(2*lambda))+...
        cos(2*psi)*((3/4-1/4*cos(2*delta))*cos(lambda)*(-sin(a))*...
        sin(-2*t+2*alpha)+(-3/8+1/8*cos(2*delta))*sin(2*lambda)*(-cos(a))*...
        cos(-2*t+2*alpha)-1/2*sin(alpha-t)*sin(2*delta)*(-sin(a))*sin(lambda)-...
        1/2*cos(alpha-t)*sin(2*delta)*(-cos(a))*cos(2*lambda)+...
        (3/8+3/8*cos(2*delta))*sin(2*lambda)*(-cos(a)));
    
    M22=sin(2*psi)*((-3/4*(-cos(2*a))+1/4*(-cos(2*a))*cos(2*lambda)-1/4-...
        1/4*cos(2*lambda))*sin(delta)*sin(-2*t+2*alpha)+cos(alpha-t)*...
        cos(delta)*cos(lambda)*sin(2*a)+sin(alpha-t)*cos(delta)*...
        sin(2*lambda)*(-cos(a))^2+cos(-2*t+2*alpha)*sin(delta)*sin(lambda)*...
        sin(2*a))+...
        cos(2*psi)*((-3/4+1/4*cos(2*delta))*sin(lambda)*...
        sin(2*a)*sin(-2*t+2*alpha)+(3/4-1/4*cos(2*delta))*...
        (-(1/2+1/2*cos(2*lambda))*(-cos(a))^2+cos(2*a))*cos(-2*t+2*alpha)+...
        (1/8+1/8*cos(2*delta))*(3*cos(2*lambda)-1)*(-cos(a))^2+...
        (-1/4-1/4*cos(2*delta))*(-cos(2*a))+1/2*cos(alpha-t)*sin(2*delta)*...
        sin(2*lambda)*(-cos(a))^2-1/2*sin(alpha-t)*sin(2*delta)*cos(lambda)*...
        sin(2*a));
    
    M12=sin(2*psi)*((-3/4+1/4*cos(2*lambda))*sin(2*a)*sin(delta)*...
        sin(-2*t+2*alpha)-cos(alpha-t)*cos(delta)*cos(lambda)*(-cos(2*a))-...
        cos(-2*t+2*alpha)*sin(delta)*sin(lambda)*(-cos(2*a))-...
        1/2*sin(alpha-t)*cos(delta)*sin(2*lambda)*sin(2*a))+...
        cos(2*psi)*((3/4-1/4*cos(2*delta))*sin(lambda)*(-cos(2*a))*...
        sin(-2*t+2*alpha)+(3/16-1/16*cos(2*delta))*(cos(2*lambda)-3)*...
        sin(2*a)*cos(-2*t+2*alpha)+1/2*sin(alpha-t)*(-cos(2*a))*...
        sin(2*delta)*cos(lambda)-1/4*cos(alpha-t)*sin(2*a)*sin(2*delta)*...
        sin(2*lambda)-(3/16+3/16*cos(2*delta))*(cos(2*lambda)+1)*sin(2*a));
    
    M13=sin(2*psi)*(1/2*sin(-2*t+2*alpha)*sin(delta)*(-sin(a))*...
        sin(2*lambda)-cos(-2*t+2*alpha)*sin(delta)*(-cos(a))*cos(lambda)+...
        cos(alpha-t)*cos(delta)*(-cos(a))*sin(lambda)+sin(alpha-t)*...
        cos(delta)*(-sin(a))*cos(2*lambda))+...
        cos(2*psi)*((3/4-1/4*cos(2*delta))*cos(lambda)*(-cos(a))*...
        sin(-2*t+2*alpha)+(3/8-1/8*cos(2*delta))*sin(2*lambda)*(-sin(a))*...
        cos(-2*t+2*alpha)-1/2*sin(alpha-t)*(-cos(a))*sin(lambda)*sin(2*delta)+...
        1/2*cos(alpha-t)*(-sin(a))*sin(2*delta)*cos(2*lambda)+...
        (-3/8-3/8*cos(2*delta))*sin(2*lambda)*(-sin(a)));
    
    M11=sin(2*psi)*((1/2*(-cos(2*a))+1/2)*cos(delta)*sin(2*lambda)*...
        sin(alpha-t)+((-1/4-1/4*(-cos(2*a)))*cos(2*lambda)-1/4+...
        3/4*(-cos(2*a)))*sin(delta)*sin(-2*t+2*alpha)-cos(-2*t+2*alpha)*...
        sin(delta)*sin(lambda)*sin(2*a)-cos(alpha-t)*cos(delta)*...
        cos(lambda)*sin(2*a))+...
        cos(2*psi)*((-3/4+1/4*cos(2*delta))*...
        sin(lambda)*sin(2*a)*sin(2*t-2*alpha)+(1/16*cos(2*delta)-3/16)*...
        ((-cos(2*a)+1)*cos(2*lambda)+3*cos(2*a)+1)*cos(2*t-2*alpha)-...
        1/2*sin(-alpha+t)*cos(lambda)*sin(2*delta)*sin(2*a)+...
        1/2*cos(-alpha+t)*(-sin(a))^2*sin(2*lambda)*sin(2*delta)+...
        (3/16+3/16*cos(2*delta))*(cos(2*lambda)+1)*(-cos(2*a))-...
        (1/16*cos(2*delta)+1/16)*(-3*cos(2*lambda)+1));
    
    