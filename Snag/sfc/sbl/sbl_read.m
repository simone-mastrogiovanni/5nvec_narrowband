function [M,sbl_]=sbl_read(sblfile,kbloc,chn,ind)
%READ_SBL   reads data from an sbl file 
%
%        ONLY FOR ONE DIMENSION ARRAYS
%
%    sblfile    file name (with path) (if absent, interactive)
%    kbloc      array with the bloc numbers (if absent, all the rest interactive)
%    chn        channel number
%    ind        [min,max] index
%
%    M          output data (bloc,ind)
%    sbl_       header

% Version 2.0 - February 2004
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

icdisp=0;
if ~exist('sblfile')
    sblfile=selfile(' ');
    icdisp=1
end

sbl_=sbl_open(sblfile);

if icdisp == 1
	disp(sprintf('          ch            dx            dy          lenx   leny type      bias'))    
	for i = 1:sbl_.nch
        disp(sprintf(' channel %3d  --> %12f  %12f   %8d %4d %3d  %10d   %s',i,sbl_.ch(i).dx,sbl_.ch(i).dy, ...
        sbl_.ch(i).lenx,sbl_.ch(i).leny,sbl_.ch(i).type,sbl_.ch(i).bias,sbl_.ch(i).name))
	end
end

if ~exist('kbloc')
    strbloc=sprintf(' 1, %d',sbl_.len);
    strch=sprintf(' %d',sbl_.nch);
    answ=inputdlg({'min, max blocs ?'...
        'channel number ?'},...
        'Parameters of requested data',1,...
        {strbloc strch});
    kbloc=eval(['[' answ{1} ']']);
    chn=eval(answ{2});
    
    strind=sprintf(' 1, %d',sbl_.ch(chn).lenx);
    answ=inputdlg({'min, max index ?'},...
        'Parameters of requested data',1,...
        {strind});
    ind=eval(['[' answ{1} ']']);
end

if length(kbloc) == 2
    kbloc=kbloc(1):kbloc(2);
end

lenbl=sbl_.blen;
bias0=sbl_.point0;
bias1=sbl_.ch(chn).bias;
typ=sbl_.ch(chn).type;
ndat=ind(2)-ind(1)+1;

M=zeros(length(kbloc),ndat);
i0=0;

for i = kbloc
    bias=bias0+(i-1)*lenbl+bias1;
    i0=i0+1;
    
    switch typ
        case 1
            fseek(sbl_.fid,bias+ind(1)-1,'bof');
            c=fread(sbl_.fid,ndat,'uchar');
            M(i0,:)=c.';
        case 2
            fseek(sbl_.fid,bias+(ind(1)-1)*2,'bof');
            c=fread(sbl_.fid,ndat,'int16');
            M(i0,:)=c.';
        case 3
            fseek(sbl_.fid,bias+(ind(1)-1)*4,'bof');
            c=fread(sbl_.fid,ndat,'int32');
            M(i0,:)=c.';
        case 4
            fseek(sbl_.fid,bias+(ind(1)-1)*4,'bof');
            c=fread(sbl_.fid,ndat,'float32');
            M(i0,:)=c.';
        case 5
            fseek(sbl_.fid,bias+(ind(1)-1)*8,'bof');
            c=fread(sbl_.fid,2*ndat,'float32');
            c=c(1:2:2*ndat)+j*c(2:2:2*ndat);
            M(i0,:)=c.';
        case 6
            fseek(sbl_.fid,bias+(ind(1)-1)*8,'bof');
            c=fread(sbl_.fid,ndat,'double');
            M(i0,:)=c.';
        case 7
            fseek(sbl_.fid,bias+(ind(1)-1)*16,'bof');
            c=fread(sbl_.fid,2*ndat,'double');
            c=c(1:2:2*ndat)+j*c(2:2:2*ndat);
            M(i0,:)=c.';
    end
end        
    
fclose(sbl_.fid);
