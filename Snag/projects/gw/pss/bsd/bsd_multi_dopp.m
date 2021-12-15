function out=bsd_multi_dopp(in,direc,miniband)
% Doppler and spin-down correction
%
%    out=bsd_multi_dopp(in,direc,miniband)
% 
%   in         input bsd
%   direc      direction (.a,.d) or (.lam,.bet)
%   miniband   width of the mini bands (def 1 Hz; sub multiple of bandw)

% Snag Version 2.0 - April 2019
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by O.J.Piccinni and S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

tic
cont=cont_gd(in);

if ~exist('miniband','var')
    miniband=1;
end

t0=cont.t0;
inifr=cont.inifr;
bandw=cont.bandw;
nmini=round(bandw/miniband);
N=n_gd(in);
dt=dx_gd(in);
dfr=1/(N*dt);
frtot=1/dt;
frs=((1:nmini)-0.5)/(nmini*dt);
n4=round(N/(nmini*4));
n2=n4*2;
win2=(1-cos(pi*(1:n2)'/n2))/2;
i2=round((0:nmini-1)*N/nmini)+1;
i1=max(1,i2-n4);
i2=i2+n4;
i3=round((1:nmini)*N/nmini);
i4=min(i3+n4,N)-1;
i3=i3-n4;

y=y_gd(in);
y0=y*0;
Y=fft(y); 

VPstr=extr_velpos_gd(in);
p0=interp_VP(VPstr,direc);

for i = 1:nmini
    fr=(i-0.5)*miniband+inifr;
    fr1=i*miniband;
    y1=Y;
    y1(1:i1(i)-1)=0;
    y1(i4(i)+1:N)=0;
    if i > 1
        y1(i1(i):i2(i)-1)=Y(i1(i):i2(i)-1).*win2;
    end
    if i < nmini
        y1(i3(i):i4(i))=Y(i3(i):i4(i)).*win2(n2:-1:1);
    end
    y1=ifft(y1);
    ph=p0*fr*2*pi;
    corr=exp(-1j*ph);
    y1=y1.*corr;
    y0=y0+y1;
end

oper=struct();
oper.op='bsd_multi_dopp';
if isfield(cont,'oper')
    oper.oper=cont.oper;
end
oper.direc=direc;
oper.miniband=miniband;

cont.oper=oper;

out=edit_gd(in,'y',y0);
out=bsd_zeroholes(out,in);
toc