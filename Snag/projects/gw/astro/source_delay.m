function delay=source_delay(doptab,sour,t)
%GW_DOPPLER  computes the percentage Doppler shift for the Earth motion
%            it works with a single time or with a single source
%
%     doptab    table containing the Doppler data (depends on antenna)
%                (a matrix (8,n) 
%     sour      source structure
%     t         time array(in mjd days)

% Version 2.0 - December 2009
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

deg_to_rad=pi/180;
r=astro2rect([sour.a sour.d 1]);

[n1,n2]=size(doptab);

t1=mjd2tt(t);

tmin=min(t1)-0.5;
tmax=max(t1)+0.5;
doptab=reduce_doptab(doptab,tmin,tmax);

x=spline(doptab(1,:),doptab(2,:),t1);
y=spline(doptab(1,:),doptab(3,:),t1);
z=spline(doptab(1,:),doptab(4,:),t1); 

delay=x*r(1)+y*r(2)+z*r(3);

% einst=spline(doptab(1,:),doptab(8,:),t);
