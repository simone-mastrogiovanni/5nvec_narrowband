function [piahead,tps,sps,sft]=pia_read_block(fid)
%
% piahead.endian        (double) 1
%        .gps_sec       (int32)
%        .gps_nsec      (int32)
%        .tbase         (double)
%        .firstfrind    (int32)
%        .nsamples      (int32)
%
%  end of file -> piahead = 0

piahead.eof=0;

[piahead.endian count]=fread(fid,1,'double');
if count == 0
    piahead.eof=1;
    tps=0;
    sps=0;
    sft=0;
    return
end

piahead.detector=fread(fid,1,'int32');
piahead.gps_sec=fread(fid,1,'int32');
piahead.gps_nsec=fread(fid,1,'int32');
piahead.tbase=fread(fid,1,'double');
piahead.firstfrind=fread(fid,1,'int32');
piahead.nsamples=fread(fid,1,'int32');

piahead.red=fread(fid,1,'int32');
piahead.typ=fread(fid,1,'int32');
piahead.n_flag=fread(fid,1,'float32');
piahead.einstein=fread(fid,1,'float32');
piahead.mjdtime=fread(fid,1,'double');
piahead.nfft=fread(fid,1,'int32');
piahead.wink=fread(fid,1,'int32');
piahead.normd=fread(fid,1,'int32');
piahead.normw=fread(fid,1,'int32');
piahead.frinit=fread(fid,1,'double');
piahead.tsamplu=fread(fid,1,'double');
piahead.deltanu=fread(fid,1,'double');

if piahead.detector == 0 % bar
    piahead.frcal=fread(fid,1,'double');
    piahead.freqm=fread(fid,1,'double');
    piahead.freqp=fread(fid,1,'double');
    piahead.taum=fread(fid,1,'double');
    piahead.taup=fread(fid,1,'double');
else
    piahead.vx_eq=fread(fid,1,'double'); 
    piahead.vy_eq=fread(fid,1,'double'); % old: freqmin
    piahead.vz_eq=fread(fid,1,'double'); % old: freqmax
    piahead.spare1=fread(fid,1,'double');
    piahead.spare2=fread(fid,1,'double');
end

ltps=piahead.red;
tps=fread(fid,ltps,'float');

lsps=piahead.nsamples/ltps;
sps=fread(fid,lsps,'float');

n=piahead.nsamples;
n2=2*n;

if nargout < 4
    pos=ftell(fid);
    fseek(fid,pos+4*n2,'bof');
else
    cdat=fread(fid,n2,'float');
    sft=cdat(1:2:n2)+i*cdat(2:2:n2);
end

t=gps2mjd(piahead.gps_sec+piahead.gps_nsec*1.e-9);
%mjd2s(t)
