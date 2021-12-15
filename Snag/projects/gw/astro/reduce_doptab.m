function subdoptab=reduce_doptab(doptab,tmin,tmax)
%REDUCE_DOPTAB  extracts a sub-Doppler table
%
%  tmin,tmax  time interval

t=doptab(1,:);
[ni,nj]=size(doptab);

imin=indexofarr(t,tmin);
imax=indexofarr(t,tmax);
n=imax-imin+1;
%str=sprintf(' ---> index min, max : %d, %d ;  %d input data, %d selected',imin,imax,nj,n);
%disp(str)

subdoptab=zeros(ni,n);
subdoptab(1:ni,1:n)=doptab(1:ni,imin:imax);
