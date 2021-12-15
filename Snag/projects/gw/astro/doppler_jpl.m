function [newf,pos,vel]=doppler_jpl(coord,ai,di,lat,lon,hei,fre,day,ind);
%DOPPLER_JPL computes the Doppler shifted frequency and the detector's position 
%       and velocity  vectors with respect to the solar system barycenter (SSB) 
%
%        [newf,pos,vel]=doppler_jpl(coord,ai,di,lon,lat,hei,fre,day,ind) 
%
%   coord               horizon,equatorial,ecliptic,galactic (string)
%   ai (lon), di(lat)   source coordinates in coord standard units 
%                       (see function astro_coord)
%   long,lat,hei        detectors Earth's coordinates (degrees) and height (m)
%   day                 day number from 31 Dec 1899
%   ind                 in-day time (s) 
%   fre                 original frequency (Hz)
%   alpha,delta         source coordinates (hours, degrees)
%   newf                output new frequency, shifted by the Doppler effect (Hz)
%   pos                 detector position (km) 
%   vel                 detector velocity in units of light speed (c)
%
%
%  dopplerem.dll has been buit on 
%  Intel WINNT platform using:
%                             Visual C++ 6.0      (C interface and Novas routines)  
%                             Digital Fortran 6.0 (Fortran 77 static library to
%                                                  access the binary ephemerides
%                                                  file JPLEPH provided by JPL)  
%                             Matlab 5.3 debugger (to build and debug the C mexFunction)
%
%  FURTHER DOCUMENTATION:
%  
%   REFERENCES:
%     Kaplan, G. H. et. al. (1989). Astron. Journ. Vol. 97, 
%			pp. 1197-1210.
%
%		Kaplan, G. H. "NOVAS: Naval Observatory Vector Astrometry
%			Subroutines"; USNO internal document dated 20 Oct 1988;
%			revised 15 Mar 1990.
%
%		E. M. Standish et Al. revision  of 
%			"The JPL (Jet propulsion Lab.) Export Planetary Ephemeris", 
%			29 June 1990.
%
%		The list of leap_second is given in:
%			http://tycho.usno.navy.mil/leapsec.html

% Version 1.0 - June 1999
% Copyright (C) 1999-2000  Ettore Majorana - ettore.majorana@roma1.infn.it
% Istituto Nazionale di Fisica Nucleare Sez. di Roma 
% c/o Universita` "La Sapienza"
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome


current=pwd;
snag_local_symbols;

strappo=['cd ' strcat(snagdir,'gw')];
eval(strappo);

[ao,do]=astro_coord(coord,'equatorial',ai,di);

[newf,pos,vel]=Dopplerem(ao,do,lat,lon,hei,fre,day,ind);

strappo=['cd ' current];
eval(strappo);

