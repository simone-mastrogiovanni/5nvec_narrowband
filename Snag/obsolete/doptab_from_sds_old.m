function doptab=doptab_from_sds(subsamp,file)
%READ_DOPPLER_TABLE  reads a doppler table created by crea_table
%
%   subsamp   subsampling (one every...)
%   file      (if exists) sds file containing the velocity data 
%             (e.g. tableVirgo_2000-2010.sds)
%

if ~exist('file')
    file=selfile(' ');
end

sds_=sds_open(file);

A=fread(sds_.fid,[sds_.nch,sds_.len],'float');%sa=size(A),sl=sds_.len
n=1+floor((sds_.len-1)/subsamp);
doptab=zeros(4,n);%sd=size(doptab)

t=sds_.t0+((0:subsamp:sds_.len).*sds_.dt);%st=size(t)
doptab(1,1:n)=t(1:n);
doptab(2,1:n)=A(1,1:subsamp:sds_.len);
doptab(3,1:n)=A(2,1:subsamp:sds_.len);
doptab(4,1:n)=A(3,1:subsamp:sds_.len);
