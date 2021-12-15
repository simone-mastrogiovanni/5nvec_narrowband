function out=gd2sds(gin,file,prec)
%
%     out=gd2sds(gin,prec)
%
%   gin    input gd
%   prec   precision (1=single, 2=double)  !!! NOT YET IMPLEMENTED
%
% sds_writegd is simpler, but less complete

% !!! PRECISION, COMPLEX DATA AND REAL ABSCISSA NOT YET IMPLEMENTED 

% Version 2.0 - January 2016
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

out=struct();
gdstr=gd2struct(gin);

sds_.nch=1;
sds_.len=gdstr.n;
sds_.t0=gdstr.ini;
sds_.dt=gdstr.dx;
sds_.capt=gdstr.capt;
sds_.ch{1}=gdstr.capt;
sds_.prot=1;

iccompl=0;
if ~isreal(gdstr.y)
    iccompl=1;
end
icttype=0;
if gdstr.type == 2
    icttype=1;
end

sds_.prot=prec+iccompl*2*(1-icttype);

N=1+icttype*(1+iccompl);

cont=cont_gd(gin);
if isstruct(cont)
    out1=struct2file(cont,0,0,'cont');
    sds_.point0=944+N*128+out1.lenfil;
end

sds_=sds_openw(file,sds_);

if isstruct(cont)
    struct2file(cont,0,sds_.fid,'cont');
end

if icttype == 0
    A(1,:)=real(gdstr.y);
    if iccompl == 1
        A(2,:)=imag(gdstr.y);
    end
else
    A(1,:)=gdstr.x-gdstr.ini;
    A(2,:)=real(gdstr.y);
    if iccompl == 1
        A(3,:)=imag(gdstr.y);
    end
end

switch sds_.prot
    case 1
        fwrite(sds_.fid,A,'float');
    case 2
        fwrite(sds_.fid,A,'double');
    case 3
        fwrite(sds_.fid,A,'float');
    case 4
        fwrite(sds_.fid,A,'double');
end

fclose(sds_.fid);

out.iccompl=iccompl;
out.icttype=icttype;
out.N=N;
out.prot=sds_.prot;