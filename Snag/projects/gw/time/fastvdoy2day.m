function vday=fastvdoy2day(vdoy)
%FASTVDOY2DAY   conversion from vectorial doy time to vectorial day time
%
%   day time has 6 components
%   doy time has 5 components

vday(1)=vdoy(1);
vday(2)=1;
for i = 3:6
   vday(i)=vdoy(i-1);
end
