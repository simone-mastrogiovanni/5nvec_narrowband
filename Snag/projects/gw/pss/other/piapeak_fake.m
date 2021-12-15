function piapeak_fake(lfft,piafile,filout)
% PIAPEAK_FAKE  creates fake peak files in pia format, starting from real files
%
% Pia-Peak format:
%
%     Header
% nfft      int32
%
%   Block header
% mjd       double
% nmax      int32
% velx      double
% vely      double
% velz      double
%
%     Data (nmax times)
% bin       int32
% ratio     float
% xamed     float

% lfft = 2^22

% Version 2.0 - January 2006
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

if ~exist('lfft')
    lfft=2^22;
end

if ~exist('piafile')
    piafile=selfile('  ');
end
piafid=fopen(piafile);

if ~exist('filout')
    filout='peakfake.dat';
end
outfid=fopen(filout,'w');
inix=0

nfft=fread(piafid,1,'int32');
fwrite(outfid,nfft,'int32');

for i = 1:nfft
    mjd=fread(piafid,1,'double');
    fwrite(outfid,mjd,'double');
    nmax=fread(piafid,1,'int32');
    fwrite(outfid,nmax,'int32');
    v=fread(piafid,3,'double');
    fwrite(outfid,v,'double');
    bb=round(rand(nmax,1)*lfft/2);
    bb=sort(bb);
    for j = 1:nmax
        b=fread(piafid,1,'int32');
        a=fread(piafid,1,'float');
        x=fread(piafid,1,'float');
        fwrite(outfid,bb(j),'int32');
        fwrite(outfid,a,'float');
        fwrite(outfid,x,'float');
    end
end

fclose(outfid);
fclose(piafid);