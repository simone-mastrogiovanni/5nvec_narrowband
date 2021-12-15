function fr1=doppler0(time,fr0,alpha,delta,long,lat)
%DOPPLER0  computes the Doppler shifted frequency in a simplified way
%
%        fr1=doppler(time,fr0,alpha,delta,long,lat)
%
%   time           serial date-time
%   fr0            original frequency
%   alpha,delta    source coordinates (hours, degrees)
%   long,lat       detectors Earth's coordinates (degrees)
%
%      ROZZISSIMA !!

hour_to_rad=pi/12;
deg_to_rad=pi/180;
c=299000000;

tsid=snag_tsid(time)*2*pi;
tanno=time/365.25;
tanno=(tanno-floor(tanno))*2*pi;

vrot=465;vorb=29700;
ar=alpha*hour_to_rad;dr=delta*deg_to_rad;
lor=long*deg_to_rad;lar=lat*deg_to_rad;

v=vorb*cos(tanno-ar)+vrot*cos(tsid-lor);

fr1=fr0*(1+v/c);

