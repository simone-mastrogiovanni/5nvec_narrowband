function [s,sy,sy1]=gd_eq_pows(varargin)
%GD_EQ_POWS equalized power spectrum estimation; the spectrum is normalized
%           by a lower resolution spectrum
%
% the first argument is the gd
% the use is by the length or the number of pieces
%
% keys:
%   'ratio' the ratio between the long and short fft L_fft; def 128 or 100
%   'pieces'
%   'resolution' default=1
%   'length'
%   'nobias'
%   'window' (0 -> no, 1 -> bartlett, 2 -> hanning)
%   'interactive'
%   'short' only half spectrum for real data spectra
%
%    s      equalized spectrum
%    sy     spectrum
%    sy1    smoothed spectrum

% Version 2.0 - November 2005
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

g=varargin{1};
capt=capt_gd(g);

n=n_gd(g);
dx=dx_gd(g);
y=y_gd(g);
bias=mean(y);

defratio=128;
res=1;
np=0;
win=2;
nob=0;
inter=0;
icshort=0;

for i = 2:length(varargin)
   strin=varargin{i};
   switch strin
       case 'ratio'
           ratio=varargin{i+1};
   	   case 'pieces'
           np=varargin{i+1};
       case 'resolution'
           res=varargin{i+1};
       case 'length'
           len=varargin{i+1};
       case 'window'
           win=varargin{i+1};
       case 'nobias'
           nob=1;
       case 'interactive'
           inter=1;
       case 'short'
           icshort=1;
   end
end

if inter == 1
   prompt={'Number of pieces'...
         'Resolution'...
         'Subtract bias ? (1)'...
         'Window ? (0 -> no, 1 -> bartlett, 2 -> hanning, 3 -> flatcos)'...
         'Short (half spectrum for real data) ? (0 -> no, 1 -> yes)'};
   defarg={'1' '1' '1' '2' '1'};
   
   answ=inputdlg(prompt,'Power spectrum parameters',1,defarg);
   
   np=eval(answ{1});
   res=eval(answ{2});
   nob=eval(answ{3});
   win=eval(answ{4});
   icshort=eval(answ{5});
end

icshort=icshort*isreal(y_gd(g));

if ~exist('len')
    if np == 0
        np=1;
    end
   len=n/np;
end

if np == 0
   np=ceil(n*res/len);
else
   len=floor(n/np);
end

if floor(log2(len)) ~= ceil(log2(len))
   defratio=100;
end

if ~exist('ratio')
    ratio=defratio;
end
shlen=floor(len/ratio);
shnp=np*ratio;

[sy,df]=pows(y,len,np,res,n,dx,bias,nob,win,icshort);sp=mean(sy)
sy1=pows(y,shlen,shnp,res,n,dx,bias,nob,win,icshort);sp1=mean(sy1)
ns=length(sy)
ns1=length(sy1)
np
xx=1:ratio:ns-1;
figure,semilogy(sy),hold on
sy1=interp(sy1,ns/ns1);semilogy(sy1,'g')
s=sy./abs(sy1);spInterp=mean(sy1),rap=mean(sy)

s=gd(s);
s=edit_gd(s,'dx',df,'capt',['equalized power spectrum of:' capt]);


function [sy,df]=pows(y,len,np,res,n,dx,bias,nob,win,icshort)

len2=round(len*res);%len,len2,np
df=1/(len2*dx);
sy=zeros(1,len2);
y1=sy;

if nob ==1
   y=y-bias;
   bias=0;
end

ip=0;
for i=1:np
    lenmax=len;
    if ip+len > n
        lenmax=n-ip;
    end
    y1(1:lenmax)=y(ip+1:ip+lenmax);
    y1(lenmax+1:len)=0;
    if win == 1
       y1(1:len)=y1(1:len).*pswindow('bartlett',len);
    elseif win == 2
       y1(1:len)=y1(1:len).*pswindow('hanning',len);
    elseif win == 3
       y1(1:len)=y1(1:len).*pswindow('flatcos',len);
    end
    y1(len+1:len2)=bias;
    ip=ip+len;
   
    sy=sy+abs(fft(y1)).^2;
end

if icshort == 1
    l=length(sy);
    sy=sy(1:ceil(l/2));
end

sy=sy.*(dx/n);
