function dop=gw_doppler(doptab,source,t)
%GW_DOPPLER  computes the percentage Doppler shift for the Earth motion
%            it works with a single time or with a single source
%
%     doptab    table containing the Doppler data (depends on antenna and year)
%                (a matrix (n*4) or (n*5) with:
%                first column       containing the times (normally every 10 min)
%                second col         x (in c units, in equatorial cartesian frame)
%                third col          y
%                fourth col         z
%     source    pss structures or a double array (n*2) with 
%                first col    the sources alpha (in deg)
%                second col   the source delta (in deg)
%     t         time array TT (in mjd days)
%

% Version 2.0 - April 2004
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

deg_to_rad=pi/180;
%maxv=max(abs(doptab'));

x=spline(doptab(1,:),doptab(5,:),t);
y=spline(doptab(1,:),doptab(6,:),t);
z=spline(doptab(1,:),doptab(7,:),t); 

if isstruct(source)
	as=source.a*deg_to_rad;
	ds=source.d*deg_to_rad;
else
    as=source(:,1)*deg_to_rad;
    ds=source(:,2)*deg_to_rad;
end

xs=cos(ds).*cos(as);
ys=cos(ds).*sin(as);
zs=sin(ds);

vcosfi=x*xs+y*ys+z*zs;

dop=1+vcosfi;
