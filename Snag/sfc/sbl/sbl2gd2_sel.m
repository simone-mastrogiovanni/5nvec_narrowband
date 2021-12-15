function g2=sbl2gd2_sel(file,chn,x,y)
%SBL2GD2_SEL  puts a selection of data from an sbl file to a gd2 (standard)
%
%  Simplest way to call:  g2=sbl2gd2_sel   (no arguments - interactive)
%
%   file        input file
%   chn         number of the channel
%   x           a 2 value array containing the min and the max block
%   y           a 2 value array containing the min and the max index of the output vector
%
%  If the arguments are not present, asks interactively.
%  It works on chained files.

% Version 2.0 - February 2004
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

if ~exist('file','var')
    file=selfile(' ');
end

sbl_=sbl_open(file);
t0=sbl_.t0;
dt=sbl_.dt;
n=sbl_.len;
% t00=datenum([1980 1 6 0 0 0]);
% strt0=datestr(t0/86400+t00);

if ~exist('chn')
    for i = 1:sbl_.nch
        chss{i}=sbl_.ch(i).name;
    end
    [iadc iok]=listdlg('PromptString','Select a channel',...
       'Name','Channel selection',...
       'SelectionMode','single',...
       'ListString',chss);
	chn=iadc;
end

m=sbl_.ch(chn).lenx;
nstr=sprintf('%d',n);
mstr=sprintf('%d',m);

if ~exist('x')
    answ=inputdlg({'Initial x abscissa index',...
            'Final x abscissa index', ...
            'Initial x abscissa index',...
            'Final x abscissa index'}, ...
            'Abscissa selection',1,{'1',nstr,'1',mstr});
    x(1)=eval(answ{1});
    x(2)=eval(answ{2});
    y(1)=eval(answ{3});
    y(2)=eval(answ{4});
end

t(1:x(2)-x(1)+1)=0;
lenbl=sbl_.blen;
bias0=sbl_.point0;
bias1=sbl_.ch(chn).bias;
typ=sbl_.ch(chn).type;
dx=sbl_.ch(chn).dx;
inix=sbl_.ch(chn).inix+dx*(y(1)-1);
ndat=y(2)-y(1)+1;

A=zeros(x(2)-x(1)+1,y(2)-y(1)+1);
i0=0;

for i = x(1):x(2)
    bias=bias0+(i-1)*lenbl+bias1;
    biast=bias0+(i-1)*lenbl+16;
    fseek(sbl_.fid,biast,'bof');
    tt=fread(sbl_.fid,1,'double');
    t(i-x(1)+1)=tt;
    i0=i0+1;
    
    switch typ
        case 1
            fseek(sbl_.fid,bias+y(1)-1,'bof');
            c=fread(sbl_.fid,ndat,'uchar');
            A(i0,:)=c.';
        case 2
            fseek(sbl_.fid,bias+(y(1)-1)*2,'bof');
            c=fread(sbl_.fid,ndat,'int16');
            A(i0,:)=c.';
        case 3
            fseek(sbl_.fid,bias+(y(1)-1)*4,'bof');
            c=fread(sbl_.fid,ndat,'int32');
            A(i0,:)=c.';
        case 4
            fseek(sbl_.fid,bias+(y(1)-1)*4,'bof');
            c=fread(sbl_.fid,ndat,'float32');
            A(i0,:)=c.';
        case 5
            fseek(sbl_.fid,bias+(y(1)-1)*8,'bof');
            c=fread(sbl_.fid,2*ndat,'float32');
            c=c(1:2:2*ndat)+j*c(2:2:2*ndat);
            A(i0,:)=c.';
        case 6
            fseek(sbl_.fid,bias+(y(1)-1)*8,'bof');
            c=fread(sbl_.fid,ndat,'double');
            A(i0,:)=c.';
        case 7
            fseek(sbl_.fid,bias+(y(1)-1)*16,'bof');
            c=fread(sbl_.fid,2*ndat,'double');
            c=c(1:2:2*ndat)+j*c(2:2:2*ndat);
            A(i0,:)=c.';
    end
end        
    
fclose(sbl_.fid);

g2=gd2(A);
g2=edit_gd2(g2,'dx2',dx,'ini2',inix,'type',2,'x',t);
