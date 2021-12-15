function [p_dec,einst]=pos_detector(doptab,t)
%POS_DETECTOR  computes the position of the detector
%
%     doptab    table containing the Doppler data (depends on antenna)
%                (a matrix (8,n) 
%
%     t         time array(in mjd days)
%
% Converts UT in TT to obtain correct results

% Version 2.0 - December 2009
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

deg_to_rad=pi/180;

[n1,n2]=size(doptab);

t1=mjd2tt(t);

tmin=min(t1)-0.5;
tmax=max(t1)+0.5;
doptab=reduce_doptab(doptab,tmin,tmax);
p_dec=zeros(3,length(t));

p_dec(1,:)=spline(doptab(1,:),doptab(2,:),t1);
p_dec(2,:)=spline(doptab(1,:),doptab(3,:),t1);
p_dec(3,:)=spline(doptab(1,:),doptab(4,:),t1); 

einst=spline(doptab(1,:),doptab(8,:),t);
