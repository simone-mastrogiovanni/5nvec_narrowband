function [M,vbl_]=vbl_read(vblfile,kbloc,chn,ind)
%VBL_READ   reads data from a vbl file 

ATTENZIONE !!! da sistemare

%
%        ONLY FOR ONE DIMENSION ARRAYS
%
%    vblfile    file name (with path) (if absent, interactive)
%    kbloc      array with the bloc numbers (if absent, all the rest interactive)
%    chn        channel number
%    ind        min,max index
%
%    M          output data (bloc,ind)
%    vbl_       header

% Version 2.0 - January 2006
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

icdisp=0;
if ~exist('vblfile')
    vblfile=selfile(' ');
    icdisp=1
end

vbl_=vbl_open(vblfile);

if icdisp == 1
	disp(sprintf('          ch            dx            dy          lenx   leny type      bias'))    
	for i = 1:vbl_.nch
        disp(sprintf(' channel %3d  --> %12f  %12f   %8d %4d %3d  %10d   %s',i,vbl_.ch(i).dx,vbl_.ch(i).dy, ...
        vbl_.ch(i).lenx,vbl_.ch(i).leny,vbl_.ch(i).type,vbl_.ch(i).bias,vbl_.ch(i).name))
	end
end

if ~exist('kbloc')
    strbloc=sprintf(' 1, %d',vbl_.len);
    strch=sprintf(' %d',vbl_.nch);
    answ=inputdlg({'min, max blocs ?'...
        'channel number ?'},...
        'Parameters of requested data',1,...
        {strbloc strch});
    kbloc=eval(['[' answ{1} ']']);
    chn=eval(answ{2});
    
    strind=sprintf(' 1, %d',vbl_.ch(chn).lenx);
    answ=inputdlg({'min, max index ?'},...
        'Parameters of requested data',1,...
        {strind});
    ind=eval(['[' answ{1} ']']);
end

if length(kbloc) == 2
    kbloc=kbloc(1):kbloc(2);
end

%lenbl=vbl_.blen;
bias0=vbl_.point0;
bias1=vbl_.ch(chn).bias;
typ=vbl_.ch(chn).type;
ndat=ind(2)-ind(1)+1;

M=zeros(length(kbloc),ndat);
i0=0;
vbl_=vbl_headblr(vbl_);
vbl_=vbl_headchr(vbl_);

while vlb_.block < kblock(1)
    vbl_=vbl_nextbl(vbl_);
end

while vlb_.block < kbloc(2)
    while vbl_.ch0.chnum ~= chn & vbl_.eob == 0
        vbl_=vbl_nextch(vbl_);
    end
    
    if vbl_.eob == 1
        vbl_=vbl_nextbl(vbl_);
        continue;
    end
    
    if vbl_.eof > 0
        break
    end
        
    i0=i0+1;
    
    switch vbl_.type
        case 1
            c=fread(vbl_.fid,ndat,'uchar');
            M(i0,:)=c.';
        case 2
            c=fread(vbl_.fid,ndat,'int16');
            M(i0,:)=c.';
        case 3
            c=fread(vbl_.fid,ndat,'int32');
            M(i0,:)=c.';
        case 4
            c=fread(vbl_.fid,ndat,'float32');
            M(i0,:)=c.';
        case 5
            c=fread(vbl_.fid,2*ndat,'float32');
            c=c(1:2:2*ndat)+j*c(2:2:2*ndat);
            M(i0,:)=c.';
        case 6
            c=fread(vbl_.fid,ndat,'double');
            M(i0,:)=c.';
        case 7
            c=fread(vbl_.fid,2*ndat,'double');
            c=c(1:2:2*ndat)+j*c(2:2:2*ndat);
            M(i0,:)=c.';
    end
end        
    
fclose(vbl_.fid);
