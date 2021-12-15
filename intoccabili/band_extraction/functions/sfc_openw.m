function sfc_=sfc_openw(file,sfc_)
%SFC_OPENW  open an sds file for writing
%
%   file      file to open
%   sfc_      sfc structure (without file,fid,pointers,prot,...)

% Version 2.0 - June 2003
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

sfc_.acc=0;
sfc_.file=file;

if ~isfield(sfc_,'userlen')
    sfc_.userlen=0;
end

fid=fopen(file,'w');
sfc_.fid=fid;
[file,pnam]=path_from_file(file);
sfc_.pnam=pnam;

fprintf(fid,'%8s',sfc_.label);
fwrite(fid,sfc_.prot,'int32');
fwrite(fid,sfc_.coding,'uint32');

fwrite(fid,sfc_.nch,'int32');
fwrite(fid,944+128*sfc_.nch+sfc_.userlen,'int32');
if ~isfield(sfc_,'len')
    sfc_.len=0;
end
fwrite(fid,sfc_.len,'int64');

if ~isfield(sfc_,'t0')
    sfc_.t0=0;
end
fwrite(fid,sfc_.t0,'double');
if ~isfield(sfc_,'dt')
    sfc_.dt=0;
end
fwrite(fid,sfc_.dt,'double');

if ~isfield(sfc_,'capt')
    sfc_.capt='no capt';
end
fprintf(fid,'%128s',sfc_.capt);

fprintf(fid,'%128s',file);
nofile='#NOFILE';
fprintf(fid,'%128s',nofile);
fprintf(fid,'%128s',nofile);
fprintf(fid,'%128s',nofile);
fprintf(fid,'%128s',nofile);
fprintf(fid,'%128s',nofile);
