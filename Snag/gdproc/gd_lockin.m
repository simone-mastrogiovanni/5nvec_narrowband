function [gout ef]=gd_lockin(gin,fr,hbw,per,n,w)
% GD_LOCKIN  lock-in in the frequency domain and epoch folding; gd type 1
%
%     gout=gd_lockin(gin,fr,hbw,per,n,w)
%
%   fr,hbw   frequency, half bandwidth
%   per      the period, or
%            = -1 -> sidereal epoch folding
%            = 0 or absent, no
%   n        number of bins in the period
%   w        if present, weights (on the N data), as wiener filter

% Version 2.0 - March 2010
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

y=y_gd(gin);
dt=dx_gd(gin);
N=n_gd(gin);
w=5;

if ~exist('per','var')
    per=0;
end

y=fft(y);
dfr=1/(dt*N);
k1=floor((fr-hbw)/dfr);
k2=ceil((fr+hbw)/dfr);
y1=zeros(N,1);
k=mod(k1:k2,N)+1;
y1(k)=1;
k=mod(k2+1:k2+w,N)+1;
y1(k)=(w:-1:1)/w;
k=mod(k1-w:k1-1,N)+1;
y1(k)=(1:w)/w; size(y),size(y1)
%figure,plot(y1),grid on
y=y.*y1;
y=ifft(y);
y=y.*exp(-1j*fr*2*pi*dt*(0:N-1)');

gout=edit_gd(gin,'y',y,'capt',['lock in on ' capt_gd(gin)]);

if per ~= 0
    if ~exist('n','var')
        n=1000;
    end
    ef=zeros(1,n);
    if ~exist('w','var')
        w=ones(1,N);
    end
    w=w(:);
    y=y.*w;
    ii=find(abs(y) == 0);%figure,plot(ii)
    w(ii)=0;
    ii=find(y);
    x=x_gd(gin);
    if per == -1
        a=cont_gd(gin);
        t0=a.t0;
        per=86164.09053083288;
        st0=gmst(t0)*3600;
        x=x-x(1)+st0;
    end
    iii=floor(mod(x,per)/per)*n+1;
    def=per/n;
    
    for i = 1:n
        jj=find(iii == i);
        ww=sum(w(jj));
        if ww > 0
            ef(i)=sum(y(jj))/ww;
        end
    end
    
    ef=gd(ef);
    ef=edit_gd(ef,'dx',def,'capt','epoch folding');
end