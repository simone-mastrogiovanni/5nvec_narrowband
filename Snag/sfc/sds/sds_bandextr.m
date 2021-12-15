function g=sds_bandextr(file,t,band,dt,gdout)
% SDS_BANDEXTR  extracts a band from an sds stream; creates a gd and a new unique sds
%        good for very narrow bands 
%    LIMITATION: the sds are supposed to contain a single channel
%
%     g=sds_bandextr(file,t,band,dt,gdout)
%
%   file     the first sds file or list (or 0 -> interactive choice)
%            the list is used in case of more decades. It is created by 
%                 dir /b/s  > list.txt
%            and then edited taking only the first file of the each decade, as
%     O:\pss\virgo\sd\sds\VSR2\sds_h_resh\deca_20090707\VIR_V1_h_4096Hz_20090707_131945_.sds
%     O:\pss\virgo\sd\sds\VSR2\sds_h_resh\deca_20090717\VIR_V1_h_4096Hz_20090717_010625_.sds
%     O:\pss\virgo\sd\sds\VSR2\sds_h_resh\deca_20090728\VIR_V1_h_4096Hz_20090728_002625_.sds
%     O:\pss\virgo\sd\sds\VSR2\sds_h_resh\deca_20090807\VIR_V1_h_4096Hz_20090807_002625_.sds
%    
%   t        [tinit tfin] or 0 -> all
%   band     [frmin frmax]
%   dt       output sampling time
%   gdout    name of the output gd (in absence a default name)
%            if gdout is a double, it is the frequency of a simulation;
%            the gdout is 'sinsim'

% Version 2.0 - November 2009
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

if isnumeric(file)
    file=selfile(' ');
end

if ~exist('gdout','var')
    gdout=['h_' num2str(floor(band(1)))];
end

icsim=0;
if isnumeric(gdout)
    frsim=gdout;
    isim=0;
    icsim=1;
    gdout='sinsim';
end

gdoutfile=[gdout '_' snag_timestr(now)];

if length(t) < 2
    t=[0 1.e6];
end

[pathstr,name,ext]=fileparts(file);

iclist=0;
ndeca=1;
if ~strcmp(ext,'.sds')
    disp('  Decade List Mode')
    iclist=1;
    fidlist=fopen(file);
    tline=fgetl(fidlist);
    ndeca=0;

    while tline ~= -1
        ndeca=ndeca+1;
        filelist{ndeca}=tline;
        tline=fgetl(fidlist);
    end
    file=filelist{1};
end

file
sds_=sds_open(file);
str=sprintf(' *** open file %s',file);
disp(str);

t0=sds_.t0;
t00=t0;
dtin=sds_.dt;
len=sds_.len;
fint=t0+len*dtin/86400;

dt=round(dt/dtin)*dtin;
fprintf('Sampling time in,out: %f , %f \n',dtin,dt);

rdt=round(dt/dtin);
lfftout=4*round(1000000/rdt);
if lfftout < 128
    lfftout=128;
end

lfft=rdt*lfftout;
fprintf('FFT length in,out: %d , %d \n',lfft,lfftout);

n2=lfft/2;
n4=lfft/4;
n3=n4*3;
t1=t0;
g=[];
dfr=1/(lfft*dtin);
ifr1=round(band(1)/dfr)+1;
ifr2=round(band(2)/dfr)+1;
nfr=ifr2-ifr1+1;
kfr=mod(ifr1-1:ifr2-1,lfftout)+1;
m4=lfftout/4;
yf=zeros(lfftout,1);
x=zeros(lfft,1);
npiec=0;

for kdeca = 1:ndeca
    while fint < t(1)
        sds_=sds_open([sds_.pnam sds_.filspost]);
        t0=sds_.t0;
        len=sds_.len;
        fint=t0+len*dtin/86400;
        str=sprintf(' *** open file %s',sds_.filspost);
        disp(str);
    end

    [x(n3+1:lfft) tim0 cont sds_]=read_sds_vec(sds_,n4,t1);
    if icsim == 1
        [sim isim]=simsin(frsim,dtin,n4,isim);
        x(n3+1:lfft)=sim;
    end
    nn=n4;
    npiec=npiec+1;

    while 1
        x(1:n2)=x(n2+1:lfft);
        t2=t1+nn*dtin/86400;
        [x(n2+1:lfft) t1 cont sds_]=read_sds_vec(sds_,n2,t2); 
        npiec=npiec+1;
        if sds_.eof >= 2
            break
        end
        if t1 > t(2)
            break
        end
        if t1 < t(1)
            continue
        end
        if icsim == 1
            [sim isim]=simsin(frsim,dtin,n2,isim);
            x(n2+1:lfft)=sim;
        end
        nn=n2;
        if cont == 1
            hole=(t1-t2)*86400/dt; % in output units
%             ihole=ceil(hole+1/(10*rdt));
            ihole=ceil(hole);
            g=[g zeros(1,ihole)];
            idel=round((ihole-hole)*rdt);
            fprintf('Hole of %f s at piece %d on %s; %d input samples deleted\n',hole*dt,npiec,mjd2s(t1),idel)
            x(1:n4)=0;
            x(n4+1-idel:n4+n2-idel)=x(n2+1:lfft);
            nrest=n2-n4+idel;
            t2=t1+nn*dtin/86400;
            [x(n4+n2-idel+1:lfft) t1 , cont, sds_]=read_sds_vec(sds_,nrest,t2);
            if icsim == 1
                isim=isim+round(ihole*rdt);
                [sim isim]=simsin(frsim,dtin,nrest,isim);
                x(n4+n2-idel+1:lfft)=sim;
            end
            nn=nrest;
        end

        xf=fft(x);
        yf(kfr)=xf(ifr1:ifr2);

        yf1=ifft(yf);
        g=[g yf1(m4+1:3*m4).'];
    end
    if kdeca < ndeca
        file=filelist{kdeca+1};
        sds_=sds_open(file);
        str=sprintf(' *** open file %s',file);
        disp(str);
    end
end

g=2*g/rdt; % the 2 factor is empirical
size(g)
% figure,plot(real(g))
% figure,plot(imag(g))
% figure,plot(abs(fft(g)))

eval([gdout '=gd(g);'])
eval([gdout '=edit_gd(' gdout ',''dx'',dt,''ini'',(tim0-floor(tim0))*86400),''cont'',t00']);

eval(['save ' gdoutfile ' ' gdout])

eval(['g=' gdout])



function [sim isim]=simsin(fr,dt,n,isim)

phi=2*pi*mod((isim+(0:n-1))*fr*dt,1);
sim=sin(phi);
isim=isim+n;