function fr1=doppler(time,fr0,alpha,delta,long,lat)
%DOPPLER  computes the Doppler shifted frequency 
%
%        fr1=doppler(time,fr0,alpha,delta,long,lat)
%
%   time           serial date-time
%   fr0            original frequency
%   alpha,delta    source coordinates (hours, degrees)
%   long,lat       detectors Earth's coordinates (degrees)
%

hour_to_rad=pi/12;
deg_to_rad=pi/180;

[ae,de,v]=earth_v0(time,long,lat);

as=alpha*deg_to_rad;
ds=delta*deg_to_rad;

cosfi=(cos(as)*cos(ae)+sin(as)*sin(ae))*cos(ds)*cos(de)+sin(ds)*sin(de);

fr1=fr0*(1+cosfi*v);

