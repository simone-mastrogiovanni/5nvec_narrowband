function [out iout p]=pss_fd_resamp3(tin,enh)
% PSS_FD_RESAMP  frequency domain Doppler resampling procedure
%
%    tin   time of the first sample of the time chunk
%    enh   enhancement time resolution factor (def 8)
%
%  GLOBAL in (input fd structure) :
%              in.sbl           -> input
%              in.chunk1      time dom hf
%              in.chunk0            "
%              in.last
%              in.tck1        t ck1 center
%              in.tck0              "
%              in.Tck1     t ck1 center corrected
%              in.Tck0              "
%              in.tt1      t (s) first sample out
%              in.lfftin        -> input
%              in.ifr1          -> input
%              in.ifr2          -> input
%              in.dtin          -> input
%              in.dfr
%              in.DT            -> input
%              in.dtout         -> input
%              in.lfftout
% %              in.ssamp
%              in.t0            -> input
%              in.f0            -> input
%              in.df0           -> input
%              in.ddf0          -> input
%              in.Dtsd          equivalent time delay of sd
%              in.dDtsd         variation of "
%              in.Dteinst       equivalent time delay of Einstein effect
%              in.p1            -> input
%              in.v1            -> input
%              in.p0
%              in.v0
%              in.ttot
%              in.time(2)     time(1) mjd, time(2) del res (s)
%              in.op (1 init, 2 norm, 3 hole, 4 final))  -> in (2 out)
%   dt       sampling time (reasonably an integer multiple or sub-multiple of 1 s)
%   tin      time of the first input sample 
%   enh      sampling enhancement (reasonably an integer number; def 8)
%
%   out     output chunk
%   tout    time of the first sample
%   in      updated input stracture
%
%  Conventions:
%    t    time in day (absolute)
%    T    corrected time in day (absolute)
%    tt   time in s (from t0)
%    tch  chunk time in SSB
% pieces begin with sample n2+1 and end with sample n2 (except extremal data)

% Version 2.0 - February 2010
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

% c=299792458;

global in

if ~exist('enh','var')
    enh=8;
end
% in
if in.op > 1
    in.tck0=in.tck1;
    in.Tck0=in.Tck1;
    dtz=(in.tck1-in.tck0)*86400;
else
    dtz=0;
    in.Dteinst=0;
    in.count=0;
end

in.tck1=tin+in.dtin*in.lfftin/(2*86400);
in.count=in.count+1;

ts=(tin-in.tref)*86400+in.lfftin*in.dtin/2;

[in.Dtsd in.dDtsd]=dt_spindown(in.f0,in.df0,in.ddf0,ts);

% dz=rough_deinstein(tin);
% in.Dteinst=in.Dteinst+dz*dtz;
in.Dteinst=tdt2tdb(tin);

in.Tck1=in.tck1+in.p1/86400;

DTin=in.DT;
tt1=(tin-in.t0)*86400;

switch in.op
    case 1 % the first n2
        in.empdelay=0;
        toff=0-in.empdelay;
        in.totout=0;
%         in.sd_c2=-in.df0/(2*in.f0);
%         in.sd_c3=-in.ddf0/(6*in.f0); % dtsd=c2*ts^2+c3*ts^3
        in.sd_c2=in.df0/(2*in.f0);
        in.sd_c3=in.ddf0/(6*in.f0); % dtsd=c2*ts^2+c3*ts^3
        lmin=in.ifr2*enh;
        in.lfftout=ceil(lmin/in.lfftin)*in.lfftin;
        n2=in.lfftout/2;
        in.lfftenh=in.lfftout/in.lfftin;
        in.dtin1=in.dtin/in.lfftenh;
        
        infft=zeros(1,in.lfftout);
        infft(in.ifr1:in.ifr2)=in.sbl;
        in.chunk1=2*ifft(infft)*in.lfftenh;

        p=interp_ini(in.p1,in.v1,n2,DTin);
%         tch=tt1+toff+in.dtin1*(0:n2-1);
%         dtsd=in.sd_c2*tch.^2+in.sd_c3*tch.^3;
%         tt=tch+p+dtsd+in.Dteinst;
        tch=tt1+p+toff+in.dtin1*(0:n2-1);
        dtsd=in.sd_c2*tch.^2+in.sd_c3*tch.^3;
        tt=tch+dtsd+in.Dteinst;
        
        [out iout]=strobo(in.chunk1(1:n2),tt,in.dtout);
        in.last=in.chunk1(n2);
        in.ioutini=iout;
    case 2 % the old n4 and the new n4
        toff=0-in.empdelay;
        infft=zeros(1,in.lfftout);
        infft(in.ifr1:in.ifr2)=in.sbl;
        in.chunk1=2*ifft(infft)*in.lfftenh;
 
        n2=in.lfftout/2;
        n4=n2/2;
        p=interp_pol3(in.p0,in.p1,in.v0,in.v1,n2,DTin);
%         tch=tt1+toff+in.dtin1*(0:n2-1);
%         dtsd=in.sd_c2*tch.^2+in.sd_c3*tch.^3;
%         tt=tch+p+dtsd+in.Dteinst;
        tch=tt1+p+toff+in.dtin1*(0:n2-1);
        dtsd=in.sd_c2*tch.^2+in.sd_c3*tch.^3;
        tt=tch+dtsd+in.Dteinst;
        
        [out iout]=strobo([in.last in.chunk0(n2+1:n2+n4) in.chunk1(n4+1:n2)],tt,in.dtout);
        in.last=in.chunk1(n2);
    case 3 % no last n2,  new n2 (different abscissa)
        toff=0-in.empdelay;
        infft=zeros(1,in.lfftout);
        infft(in.ifr1:in.ifr2)=in.sbl;
        in.chunk1=2*ifft(infft)*in.lfftenh;
        
        n2=in.lfftout/2;
        p=interp_ini(in.p1,in.v1,n2,DTin);
%         tch=tt1+in.dtin1*(0:n2-1);
%         dtsd=in.sd_c2*tch.^2+in.sd_c3*tch.^3;
%         tt=tch+toff+p+dtsd+in.Dteinst;
        tch=tt1+p+in.dtin1*(0:n2-1);
        dtsd=in.sd_c2*tch.^2+in.sd_c3*tch.^3;
        tt=tch+toff+dtsd+in.Dteinst;
        
        [out iout]=strobo(in.chunk1(1:n2),tt,in.dtout);
    case 4 % last n2
        toff=0-in.empdelay; % controllare
        n2=in.lfftout/2;
        p=interp_fin(in.p0,in.v0,n2,DTin);
%         tch=tt1+in.dtin1*(0:n2-1);
%         dtsd=in.sd_c2*tch.^2+in.sd_c3*tch.^3;
%         tt=tch+toff+p+dtsd+in.Dteinst;
        tch=tt1+p+in.dtin1*(0:n2-1);
        dtsd=in.sd_c2*tch.^2+in.sd_c3*tch.^3;
        tt=tch+toff+dtsd+in.Dteinst;
        
        [out iout]=strobo(in.chunk0(n2+1:n2*2),tt,in.dtout);
end

in.tout=tt(1);
in.totout=in.totout+length(out);
in.p0=in.p1;
in.v0=in.v1;
in.chunk0=in.chunk1;
in.op=2;
p=p(1:64:length(p));
in.time(1)=tin;
in.time(2)=tt(1)-tt1;


function p=interp_pol3(p0,p1,v0,v1,n,DT)
%
%   p0,p1,d0,d1  position and velocity (s and % of c)
%   n            number of points in the interval
%   DT           length of the interval (in s)
%
%  starts from the first point after the center of the past chunck

v0=v0*DT;
v1=v1*DT;
b(4)=p0;
b(3)=v0;
b(2)=3*(p1-p0)-(v1+2*v0);
b(1)=v1+v0-2*(p1-p0);
dx=1/n;
x=(1:n)*dx;
p=polyval(b,x);


function p=interp_ini(p1,v1,n2,DT)

dx=(DT/n2);
x=(-n2:-1)*dx;
p=p1+v1*x;


function p=interp_fin(p0,v0,n2,DT)

dx=(DT/n2);
x=(0:n2-1)*dx;
p=p0+v0*x;


function [out iout]=strobo(x,tt,dtout)

tt=tt/dtout;
tt1=floor(tt);
ii=find(diff(tt1));
out=x(ii+1);
iout=round(tt(ii(1)));