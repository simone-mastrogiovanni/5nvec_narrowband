function g=sds2gd_selt(file,chn,t,cont)
%SDS2GD_SELT  creates a gd with a selection of the data of chained sds files
%
%  Simplest way to call:  gd=sds2gd_selt   (no arguments - interactive)
%
%   file        input file
%   chn         number of the channel
%   t           [init dur] initial time and duration (in sds units)
%   cont        see check_mjd
%
%  If the arguments are not present, asks interactively.
%  It works on chained files.

% Version 2.0 - June 2003
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

if ~exist('file','var')
    file=selfile(' ');
end

sds_=sds_open(file);
t0=sds_.t0;
dt=sds_.dt;
n=sds_.len;
t00=datenum([1858 11 17 0 0 0]);
strt0=datestr(t0+t00);

if ~exist('chn','var')
    chn=sds_selch(file);
end

if ~exist('t','var')
    answ=inputdlg({'Starting time of wanted data','Duration (s)'}, ...
        'Time data selection',2,{strt0,'10'});%answ{1}
    t(1)=(datenum(answ{1})-t00);%,mjd2s(t(1))
    t(2)=eval(answ{2});
end

if ~exist('cont','var')
    cont=2;
end

minind=round((t(1)-t0)*86400/dt+1);
numdat=round(t(2)/dt);

while minind > n
    if sds_.fid > 0
        fclose(sds_.fid);
    end
    if strcmp(sds_.filspost,'#NOFILE')
        sds_.eof=1;
        str=sprintf(' --------> End of files');disp(str);
        return
    else
        sds_=sds_open([sds_.pnam sds_.filspost]);
        str=sprintf(' *** open file %s',sds_.filspost);
        disp(str);
        t0=sds_.t0;
        minind=round((t(1)-t0)*86400/dt+1);
        n=sds_.len;
    end
end

if minind > 1
    %A=fread(sds_.fid,[sds_.nch,minind-1],'float');
    del=sds_.point0+(sds_.nch*(minind-1))*4;
    status=fseek(sds_.fid,del,'bof');
    if status < 0
        ferror(sds_.fid)
    end
end

A=vec_from_sds(sds_,chn,numdat);%sds_,chn,figure,plot(A)
g=gd(A);
fclose(sds_.fid);

tin=sds_.t0+(minind-1)*sds_.dt/86400;
if ~exist('cont','var')
    cont=-1;
end

tinit=check_mjd(tin,cont);

capt=sprintf('from %s - channel %d',sds_.filme,chn);
g=edit_gd(g,'ini',tinit,'dx',sds_.dt,'capt',capt);
