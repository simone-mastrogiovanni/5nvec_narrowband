function [piahead,data]=pia_read(file)
%
% piahead.endian        (double) 1
%        .gps_sec       (int32)
%        .gps_nsec      (int32)
%        .tbase         (double)
%        .firstfrind    (int32)
%        .nsamples      (int32)

fid=fopen(file);

piahead.endian=fread(fid,1,'double');
piahead.gps_sec=fread(fid,1,'int32');
piahead.gps_nsec=fread(fid,1,'int32');
piahead.tbase=fread(fid,1,'double');
piahead.firstfrind=fread(fid,1,'int32');
piahead.nsamples=fread(fid,1,'int32');

n=piahead.nsamples;
n2=2*n;

cdat=fread(fid,n2,'float');

data=cdat(1:2:n2)+i*cdat(2:2:n2);

t=gps2mjd(piahead.gps_sec+piahead.gps_nsec*1.e-9);
mjd2s(t)
