function g=bar_ant_st_resp(bar_ant,source,n)
%BAR_ANT_ST_RESP   bar antenna response vs sidereal time
%
%   ATTENTION: old epsilon definition !
%
%   bar_ant   bar antenna structure
%          .long   longitude (degrees)
%          .lat    latitude      "
%          .ro     azimuth       "    (from south to west)
%          .incl   inclination        "
%
%   source
%         .alpha   right ascension
%         .delta   declination
%         .eps     linear polarization percentage
%         .psi     polarization angle
%   
%    n     dimension of the response gd g

% From ADES (SF, 1985)

a=(0:n-1)*360/n;

a=angr85(bar_ant,source,a);

g=gd(a);
g=edit_gd(g,'dx',360/n);

