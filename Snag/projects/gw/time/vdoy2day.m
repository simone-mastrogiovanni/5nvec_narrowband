function vdoy=vday2doy(vday)
%VDOY2DAY   conversion from vectorial day time to vectorial doy time
%
%   day time has 6 components
%   doy time has 5 components

vdoy(1)=vday(1);
doy=day2doy(vday(3),vday(2),vday(1))
vdoy(2)=doy;

for i = 4:6
   vdoy(i-1)=vday(i);
end
