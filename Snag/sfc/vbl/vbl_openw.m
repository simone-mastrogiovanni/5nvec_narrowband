function vbl_=vbl_openw(file,vbl_)
%VBL_OPENW  open an vbl file for writing
%
%   file      file to open
%   vbl_      vbl structure (without file,fid,pointers,prot,...)

% Version 2.0 - June 2003
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

vbl_.file=file;

vbl_.label='#SFC#VBL';
vbl_.prot=1;
vbl_.coding=0;

if ~isfield(vbl_,'len')
    vbl_.len=0;
end
if ~isfield(vbl_,'t0')
    vbl_.t0=0;
end
if ~isfield(vbl_,'dt')
    vbl_.dt=0;
end
if ~isfield(vbl_,'capt')
    vbl_.capt='nocapt';
end


vbl_=sfc_openw(file,vbl_);
fid=vbl_.fid;ftell(fid)

for i = 1:vbl_.nch
    if ~isfield(vbl_.ch(i),'lenx') | isempty(vbl_.ch(i).lenx)
        vbl_.ch(i).lenx=0;
    end
    if ~isfield(vbl_.ch(i),'leny') | isempty(vbl_.ch(i).leny)
        vbl_.ch(i).leny=0;
    end
    if ~isfield(vbl_.ch(i),'dx') | isempty(vbl_.ch(i).dx)
        vbl_.ch(i).dx=0;
    end
    if ~isfield(vbl_.ch(i),'dy') | isempty(vbl_.ch(i).dy)
        vbl_.ch(i).dy=0;
    end
    if ~isfield(vbl_.ch(i),'inix') | isempty(vbl_.ch(i).inix)
        vbl_.ch(i).inix=0;
    end
    if ~isfield(vbl_.ch(i),'iniy') | isempty(vbl_.ch(i).iniy)
        vbl_.ch(i).iniy=0;
    end
    if ~isfield(vbl_.ch(i),'type') | isempty(vbl_.ch(i).type)
        vbl_.ch(i).type=0;
    end
    fwrite(fid,vbl_.ch(i).dx,'double');
    fwrite(fid,vbl_.ch(i).dy,'double');
    fwrite(fid,vbl_.ch(i).lenx,'int32');
    fwrite(fid,vbl_.ch(i).leny,'int32');
    fwrite(fid,vbl_.ch(i).inix,'double');
    fwrite(fid,vbl_.ch(i).iniy,'double');
    fwrite(fid,vbl_.ch(i).type,'int32');
    fprintf(fid,'%84s',vbl_.ch(i).capt); % vbl_.ch(i)
end

vbl_.point0=ftell(fid);
