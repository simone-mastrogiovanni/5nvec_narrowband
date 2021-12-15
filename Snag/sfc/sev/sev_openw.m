function sev_=sev_openw(file,sev_,user)
%SEV_OPENW  open an sev file for writing
%
%   file      file to open
%   sev_      sev structure (without file,fid,pointers,prot,nch... it should contain
%             ch(i), nd, ni, nf, lar)
%   user      user header (string; no, if absent)

% Version 2.0 - September 2008
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

sev_.file=file;

sev_.label='#SFC#SEV';
sev_.prot=1;
sev_.coding=0;

sev_.nch=sev_.nd+sev_.ni+sev_.nf+sign(sev_.lar);
if sev_.nch < length(sev_.ch)
    disp( '*** Inconsistent parameters'),sev_
    return
end
sev_.evlen=sev_.nd*8+(sev_.ni+sev_.nf+sev_.lar)*4;

if exist('user','var')
    sev_.userlen=length(user);
end

sev_=sfc_openw(file,sev_);

for i = 1:sev_.nch
    fprintf(sev_.fid,'%128s',sev_.ch{i});
end

if exist('user','var')
    fwrite(sev_.fid,user,'uchar');
end

fwrite(sev_.fid,sev_.nd,'int32');
fwrite(sev_.fid,sev_.ni,'int32');
fwrite(sev_.fid,sev_.nf,'int32');
fwrite(sev_.fid,sev_.lar,'int32');
