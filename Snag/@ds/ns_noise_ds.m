function [d,buff,nss]=ns_noise_ds(d,buff,nss,varargin)
%NS_NOISE_DS  generates a non-interlaced data-stream of non-stationary 
%             noise (ds type 1) using cosine tapered method
%
% The non-stationarity has different features:
%
%  Amplitude n-s:  nsfo    first order
%                  nspas   periodic any shape
%
%  Spectral n-s:   nssp    
%
%  Pulse n-s:      nsrp    random pulse
%                  nsdp    deterministic pulses
%
% The data are stationary inside the chunk. 
% The non-stationarity is managed by the nss structure
%
%  nss.iter           iteration (initially 0)
%
%  nss.nsfo.tau       first-order n-s tau  (0 if not present)
%  nss.nsfo.amp       first-order n-s amplitude
%  nss.nsfo.mem       first-order n-s memory (only output)
%  nss.nsfo.norm      first-order n-s normalization factor (only output)
%
%  nss.nspas.amp      amplitude shape array (0 if not present)
%  nss.nspas.k        amplitude shape array index (0 at start)
%
%  nss.nssp.sp(i,n)   array with the n spectra (0 if not present)
%  nss.nssp.k         spectra collection index * life (0 at start)
%  nss.nssp.life      life of a spectrum (integer minimum 1)
%
%  nss.nsrp.sh(i,n)   pulse shape array
%  nss.nsrp.amp       pulse amplitude (expected value of the exponential)
%  nss.nsrp.lam       pulse lambda (events per minute; 0 if not present)
%  nss.nsrp.buf       pulse buffer (contains residual pulse)
%
%  nss.nsdp.sh(i,n)   pulse shape array 
%  nss.nsdp.evs(4,N)  for each of the N events, the shape index, the
%                     amplitude, the chunk and the position in the chunk
%                     (0 if not present)
%  nss.nsdp.buf       pulse buffer (contains residual pulse)
%
% This is a ds server.
% The first argument, d, contains a ds
% The second argument, buff, contains a double array of length 3*d.len/2, 
%   which first third contains the input noise, the second third the
%   output noise (of the previous stage), the third third the cosine window;
%   it must be also in output.
% The third is the nss structure.
% Typical call:
%    [d,buff,nss]=ns_noise_ds(d,buff,nss,'spect',sp,'real')
%
% keys:
%
%   'srspect'      a double containing the sqrt of a spectrum
%   'spect'        a double containing a spectrum
%   'resonances'   a structure for resonances
%                  the array structure is:
%                    rs(i).amp
%                    rs(i).freq
%                    rs(i).tau
%   'complex'      complex output (at the end)
%   

% Operation:
%
% if d.lcw == 0 -> initializes
% if d.lcw ~= d.lcr exits
% if d.lcw < d.lcr  error
% if d.lcw > d.lcr  warning

% Version 2.0 - November 2004
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

icsp=0;
nrs=0;
icreal=1;

for i = 1:2:length(varargin)
	str=varargin{i};
   switch str
   case 'srspect'
      sp=varargin{i+1};
      icsp=1;
   case 'spect'
      sp=sqrt(varargin{i+1});
      icsp=1;
   case 'resonances'
      rs=varargin{i+1};
      nrs=length(rs);
   case 'ramp'
      d.cont=1;
   case 'complex'
      icreal=0;
   end
end

if ~exist('nss.iter')
    nss.iter=0;
end
nss.iter=nss.iter+1;
if nss.iter == 1
    if ~exist('nss.nsfo')
        nss.nsfo.tau=0;
    end
    if ~exist('nss.nspas')
        nss.nspas.amp=0;
    end
    if ~exist('nss.nssp')
        nss.nssp.sp=0;
    end
    if ~exist('nss.nsrp')
        nss.nsrp.lam=0;
    end
    if ~exist('nss.nsdp')
        nss.nsdp.evs=0;
    end
end

if nss.nsfo.tau > 0
    if ~exist('nss.nsfo.norm')
        nss.nsfo.norm=0;
    end
    w=exp(-1/nss.nsfo.tau);
    if ~exist('nss.nsfo.mem')
        nss.nsfo.mem=0;
    end
    mem=nss.nsfo.mem;
    nss.nsfo.mem=mem*w+randn(1,1);
    norm=nss.nsfo.norm;
    nss.nsfo.norm=norm*w+1;
    fo=nss.nsfo.amp*nss.nsfo.mem/nss.nsfo.norm;
    nsfo=1+fo;
else
    nsfo=1;
end

if length(nss.nspas.amp) > 1
    if ~exist('nss.nspas.k')
        nss.nspas.k=0;
    end
    nss.nspas.k=nss.nspas.k+1;
    if nss.nspas.k > length(nss.nspas.amp)
        nss.nspas.k=1;
    end
    nspas=nss.nspas.amp(nss.nspas.k);
else
    nspas=1;
end

if length(nss.nssp.sp) > 1
    if ~exist('nss.nssp.k')
        nss.nssp.k=0;
    end
    [n,i]=size(nss.nssp.sp);
    nss.nssp.k=nss.nssp.k+1;
    k=ceil(nss.nssp.k/nss.nssp.life);
    lif=(nss.nssp.k-(k-1)*nss.nssp.life)/nss.nssp.life;
    if k > n
        k=1;
    end
    kk=kk+1;
    if kk > n
        kk=1;
    end
    sp=nss.nssp.sp(k)*lif+nss.nssp.sp(kk)*(1-lif);
end

sp=sp.*nsfo*nspas;

len=d.len;
len2=len/2;
len4=len/4;

if d.lcw == 0   
   d.ind1=1;
   d.tini1=d.treq-len*d.dt;
%   d.type=1;  grosso errore presumibile
   d.capt='noise simulation';
   x=randn(1,len);
   if icsp == 1
      sp=sp(:)';
      b1=fft(x);
      b1=b1.*sp;
      b1=ifft(b1);
      buff(1:len2)=x(len2+1:len);
      buff(len2+1:len)=b1(len2+1:len);
      buff(len+1:len+len2)=cos((0:len2-1)*pi/len);
   end
else
   d.y2=d.y1(1:d.len);
end

if icsp == 1
   sp=sp(:)';
   x(1:len2)=buff(1:len2);
   x(len2+1:len)=randn(1,len2);
   b1=fft(x);
   b1=b1.*sp;
   b1=ifft(b1);
   d.y1(1:len2)=buff(len2+1:len).*buff(len+1:len2+len)+...
      b1(1:len2).*(1-buff(len+1:len2+len).^2);
   
   x(1:len2)=x(1+len2:len);
   x(len2+1:len)=randn(1,len2);
   b2=fft(x);
   b2=b2.*sp;
   b2=ifft(b2);
   d.y1(1:len2)=b1(len2+1:len).*buff(len+1:len2+len)+...
      b2(1:len2).*(1-buff(len+1:len2+len).^2);
   
   buff(1:len2)=x(len2+1:len);
   buff(len2+1:len)=b2(len2+1:len);
end

d.tini1=d.tini1+len*d.dt;
d.y1(1:len2)=b1(len4+1:3*len4);
d.y1(len2+1:len)=b2(len4+1:3*len4);

if nss.nsrp.lam > 0
   if exist('nss.nsrp.buf')
       d.y1(1:length(nss.nsrp.buf))=d.y1(1:length(nss.nsrp.buf))+nss.nsrp.buf;
       app=nss.nsrp;
       app=rmfield(app,'buf');
       nss.nsrp=app;
   end
   
   [shind,ampev,indev]=nsrp_evs(nss.nsrp,d.len,d.dt);
   nev=length(shind1);
   
   [d.y1,buf]=write_ev_on_chunk(d.y1,nss.nsrp,shind,ampev,indev);
end

if length(nss.nsdp.evs) > 1
   if exist('nss.nsdp.buf')
       d.y1(1:length(nss.nsdp.buf))=d.y1(1:length(nss.nsdp.buf))+nss.nsdp.buf;
       app=nss.nsdp;
       app=rmfield(app,'buf');
       nss.nsdp=app;
   end
   (i,N)=size(nss.nsdp.evs);
   for i = 1:N
       if nss.nsdp.evs(3,i) == nss.iter
           nev=nev+1;
           shind(nev)=nss.nsdp.evs(1,i);
           ampev(nev)=nss.nsdp.evs(2,i);
           indev(nev)=nss.nsdp.evs(4,i);
       end
   end
   shind=shind(1:nev);
   ampev=ampev(1:nev);
   indev=indev(1:nev);
   
     
   [d.y1,buf]=write_ev_on_chunk(d.y1,nss.nsdp,shind,ampev,indev);
end

d.lcw=d.lcw+1;
d.nc1=d.lcw;
lcw=sprintf('%d',d.lcw);
%disp(strcat('ds chunk ->',lcw,' - y1'));



function [shind,ampev,indev]=nsrp_evs(nsrp,len,dt)

len1=floor(sqrt(len+.001));
len2=floor(len/len1);
DT=dt*len1;
[i,nsh]=size(nsrp.sh);

p1=DT*nsrp.lam/60;
r1=rand(len1,1);
p2=dt*nsrp.lam/60;

nev1=0;

for i = 1:len1
    if r1(i) < p
        r2=rand(len2,1);
        for j = 1:len2
            if r2(j) < p2
                nev1=nev1+1;
                indev(nev1)=(i-1)*len1+j;
                ampev(nev1)=randn(1,1)*nsrp.amp;
                shind(nev1)=floor(nsh*ran(1,1)+1);
            end
        end
    end
end


function [y,buf]=write_ev_on_chunk(y,nsp,shind,ampev,indev)

nev=length(shind);
[lev,n]=size(nsp.sh);
ly=length(y);

for i = 1:nev
    sh=nsp.sh(:,shind(i));
    lev1=lev;
    finind=lev+indev(i)-1;
    lev2=0;
    if finind > ly
        lev2= finind-ly;
        lev1=lev-lev2;
    end
    y(indev(i):indev(i)+lev1)=y(indev(i):indev(i)+lev1)+sh(1:lev1);
    buf=sh(lev1+1:lev1+lev2);
end
    
