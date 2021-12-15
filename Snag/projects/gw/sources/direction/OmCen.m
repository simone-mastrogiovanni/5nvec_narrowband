function direc=OmCen()
%
%   ? Cen or NGC 5139
%
%  13h 26m 47.28s , ?47° 28? 46.1?[2]
%    4.84 kpc

direc.name='OmCen';
direc.a=hour2deg('13:26:47.28');
direc.d=-(47+28/60+46.1/3600);
direc.dist=4.84; % kpc
