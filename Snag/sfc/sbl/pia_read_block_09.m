function [piahead,tps,sps,sft]=pia_read_block_09(fid,det)
% PIA_READ_BLOCK_09  reads a block of an sfdb09 file
%
%   [piahead,tps,sps,sft]=pia_read_block_09(fid);
%
%   fid        ...
%   det        = 1 checks detector type (def 0)
%
%   piahead    header of the block
%   tps        time averages
%   sps        short power spectrum
%   sft        sft
%
% piahead.endian        (double) 1
%        .gps_sec       (int32)
%        .gps_nsec      (int32)
%        .tbase         (double)
%        .firstfrind    (int32)
%        .nsamples      (int32)
%
%  end of file -> piahead = 0

if ~exist('det','var')
    det=0;
end

piahead.eof=0;

[piahead.endian count]=fread(fid,1,'double');
if count == 0
    piahead.eof=1;
    tps=0;
    sps=0;
    sft=0;
    return
end

piahead.detector=fread(fid,1,'int32');    % detector (0,1)
piahead.gps_sec=fread(fid,1,'int32');     
piahead.gps_nsec=fread(fid,1,'int32');    
piahead.tbase=fread(fid,1,'double');      % length of fft in s
piahead.firstfrind=fread(fid,1,'int32');  %
piahead.nsamples=fread(fid,1,'int32');    % number of samples of fft 

piahead.red=fread(fid,1,'int32');         % reduction factor (very short spectrum)
piahead.typ=fread(fid,1,'int32');         % 
piahead.n_flag=fread(fid,1,'float32');      
piahead.einstein=fread(fid,1,'float32');  %
piahead.mjdtime=fread(fid,1,'double');
piahead.nfft=fread(fid,1,'int32');
piahead.wink=fread(fid,1,'int32');        %
piahead.normd=fread(fid,1,'float32');     % factor |fft|^2 -> pow spect
piahead.normw=fread(fid,1,'float32');     % factor window (to be multiplied for normd)
piahead.frinit=fread(fid,1,'double');     %
piahead.tsamplu=fread(fid,1,'double');    % original sampling time
piahead.deltanu=fread(fid,1,'double');    % fft frequency bin

if piahead.detector == 0 && det == 1  % bar old
    piahead.frcal=fread(fid,1,'double');
    piahead.freqm=fread(fid,1,'double');
    piahead.freqp=fread(fid,1,'double');
    piahead.taum=fread(fid,1,'double');
    piahead.taup=fread(fid,1,'double');
else
    piahead.vx_eq=fread(fid,1,'double'); 
    piahead.vy_eq=fread(fid,1,'double'); 
    piahead.vz_eq=fread(fid,1,'double'); 
    piahead.px_eq=fread(fid,1,'double'); 
    piahead.py_eq=fread(fid,1,'double'); 
    piahead.pz_eq=fread(fid,1,'double');
    piahead.n_zeroes=fread(fid,1,'int32');
    piahead.sat_howmany=fread(fid,1,'double');
    piahead.spare1=fread(fid,1,'double');
    piahead.spare2=fread(fid,1,'double');
    piahead.spare3=fread(fid,1,'double');
    piahead.spare4=fread(fid,1,'float32');
    piahead.spare5=fread(fid,1,'float32');
    piahead.spare6=fread(fid,1,'float32');
    piahead.lavesp=fread(fid,1,'int32');
    piahead.spare8=fread(fid,1,'int32');
    piahead.spare9=fread(fid,1,'int32');
end

ltps=piahead.red;
if piahead.lavesp > 0
    lsps=piahead.lavesp;
    tps=fread(fid,lsps,'float');
else
    tps=fread(fid,ltps,'float');
    lsps=piahead.nsamples/ltps;
end

sps=fread(fid,lsps,'float');

n=piahead.nsamples;
n2=2*n;

if nargout < 4
    pos=ftell(fid);
    fseek(fid,pos+4*n2,'bof');
else
    cdat=fread(fid,n2,'float');
    sft=cdat(1:2:n2)+1i*cdat(2:2:n2);
end

% t=gps2mjd(piahead.gps_sec+piahead.gps_nsec*1.e-9);
%mjd2s(t)
