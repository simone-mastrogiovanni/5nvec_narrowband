function out=bsd_multi_dopp(in,direc,miniband)
% Doppler and spin-down correction
%
%    out=bsd_multi_dopp(in,direc,miniband)
% 
%   in         input bsd
%   direc      direction (.a,.d) or (.lam,.bet)
%   miniband   width of the mini bands (def 1 Hz; sub multiple of bandw)

% Snag Version 2.0 - April 2017
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
y=y_gd(in);
y0=y*0;
Y=fft(y);

VPstr=extr_velpos_gd(in);
p0=interp_VP(VPstr,direc);
fr0=0;
ini1=0;

for i = 1:nmini
    fr=(i-0.5)*miniband+inifr;
    fr1=i*miniband;
    ini2=round(fr1/dfr);
    y1=Y;
    y1(1:ini1)=0;
    y1(ini2+1:N)=0;
    y1=ifft(y1);
    ph=p0*fr*2*pi;
    corr=exp(-1j*ph);
    y1=y1.*corr;
    y0=y0+y1;
    ini1=ini2;
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