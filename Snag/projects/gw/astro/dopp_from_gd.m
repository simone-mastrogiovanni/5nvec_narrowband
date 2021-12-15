function [lfr,lph]=dopp_from_gd(gdin,source)
%
%     [lfr,lph]=dopp_from_gd(gdin,source)
%
%   gdin       BSD gd (or similar)
%   source     periodic source structure
%

% Version 2.0 - June 2016
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Ornella Piccinni and Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

cont=cont_gd(gdin);
v=cont.v_eq(:,1:3);
p=cont.p_eq(:,1:3);
t=cont.v_eq(:,4);
nt=length(t);
t0=cont.t0;

source=new_posfr(source,t0);

r=astro2rect([source.a source.d],0);
r=repmat(r,nt,1);
f0=source.f0;

prod=dot(v,r,2);                    %scalar product between v and source position
Df=prod*f0;                         %factor f0*v*n/c doppler shift for source position
tt=x_gd(gdin);                      %times of the gd data
lfr=spline(t,Df,tt);                %interpolation of Doppler shift factors 

lph=0;