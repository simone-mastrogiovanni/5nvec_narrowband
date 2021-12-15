function doptab=doptab_from_dds(subsamp,tim,file)
%READ_DOPPLER_TABLE  reads a doppler table created by crea_table
%
%     doptab=doptab_from_dds(subsamp,tim,file)
%
%   subsamp   subsampling (one every...)
%   tim       [min max] time (mjd for old format, tdt mjd for new)
%   file      (if exists) dds file containing the velocity data 
%             (e.g. tableVirgo_2000-2010.dds)
%
%  The data obtained from this procedure are in single precision.So we have a little error
%  on v using v_detector (normally less than some units in 10^-12). 
%  Better results can be obtained from doptab read directly from Pia files.

if ~exist('file','var')
    file=selfile(' ','*.dds','dds file containing the Doppler table ?');
end

if ~exist('subsamp','var')
    subsamp=1;
end

if ~exist('tim','var')
    tim=[0 1.e6];
end

dds_=dds_open(file);

A=fread(dds_.fid,[dds_.nch,dds_.len],'double');

A=A(:,1:subsamp:dds_.len);

t=dds_.t0+((0:subsamp:dds_.len-1).*dds_.dt/86400);min(t),max(t),length(t)
[ix iy]=find(t >= tim(1) & t <= tim(2));
n=length(iy);
doptab=zeros(4,n);

if dds_.nch == 7
    doptab(1,1:n)=t(iy);
    doptab(2,1:n)=A(1,iy);
    doptab(3,1:n)=A(2,iy);
    doptab(4,1:n)=A(3,iy);
    doptab(5,1:n)=A(4,iy);
    doptab(6,1:n)=A(5,iy);
    doptab(7,1:n)=A(6,iy);
    doptab(8,1:n)=A(7,iy);
else
    doptab(1,1:n)=t(iy);
    doptab(2,1:n)=A(1,iy);
    doptab(3,1:n)=A(2,iy);
    doptab(4,1:n)=A(3,iy);
    doptab(5,1:n)=A(4,iy);
    disp(' *** OLD TYPE DOPTAB !')
end
