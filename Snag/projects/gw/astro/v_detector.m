function [v_x,v_y,v_z,einst]=v_detector(doptab,t)
%V_DETECTOR  computes the velocity of the detector
%
%     doptab    table containing the Doppler data (depends on antenna and year)
%                (a matrix (8,n) with:
%                first column       containing the times (normally every 10 min)
%                5th col            v_x (in c units, in equatorial cartesian frame)
%                6th col            v_y
%                7th col            v_z
%                8th column         einstein correction
%
%     t         time array(in mjd days)
%
% Converts UT in TDT to obtaincorrect results

% Version 2.0 - June 2005
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

deg_to_rad=pi/180;

[n1,n2]=size(doptab);

t1=mjd2tt(t);

tmin=min(t1)-0.5;
tmax=max(t1)+0.5;
doptab=reduce_doptab(doptab,tmin,tmax);

v_x=spline(doptab(1,:),doptab(5,:),t1);
v_y=spline(doptab(1,:),doptab(6,:),t1);
v_z=spline(doptab(1,:),doptab(7,:),t1); 

einst=spline(doptab(1,:),doptab(8,:),t1);
