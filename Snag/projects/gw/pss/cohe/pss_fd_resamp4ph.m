function [out iout p]=pss_fd_resamp4ph(tin,kt,enh)
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
%   in      updated input structure
%
%  Conventions:
%    t    time in day (absolute)
%    T    corrected time in day (absolute)
%    tt   time in s (from t0)
%    tch  chunk time in SSB
% pieces begin with sample n2+1 and end with sample n2 (except extremal data)

% Version 3.0 - February 2011
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universit?"Sapienza" - Rome
%
% Spin-down correction by phase term introduced in March 2011 (D Antonio
% Sabrina -Rome 2 Tor Vergata)
% Spin-down parameters over 2nd order added in Apr 2011 (CP)
%
% TT to TCB conversion added properly (May 2013)
%
% c=299792458;
%


global in

if ~exist('enh','var')
    enh=8;
end
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

% make conversion from TT to TDB or TCB
if kt == 0
    in.Dteinst=tdt2tdb(tin);
elseif kt == 1
    in.Dteinst=tdt2tcb(tin);
else
    sprintf('ERROR: kt value not allowed: %f\n',kt)
end

in.Tck1=in.tck1+in.p1/86400;

DTin=in.DT;
tt1=(tin-in.t0)*86400;

switch in.op
    case 1 % the first n2
        %in.empdelay=0;
        toff=0-in.empdelay;
        in.totout=0;
        in.sd_c2=in.df0/(2*in.f0);
        in.sd_c3=in.ddf0/(6*in.f0); % dtsd=c2*ts^2+c3*ts^3
        in.sd_c4=in.d3f0/(24*in.f0);
        in.sd_c5=in.d4f0/(120*in.f0); 
        in.sd_c6=in.d5f0/(720*in.f0);
        in.sd_c7=in.d6f0/(5040*in.f0); 
        in.sd_c8=in.d7f0/(40320*in.f0);
        
        lmin=in.ifr2*enh;
        in.lfftout=ceil(lmin/in.lfftin)*in.lfftin;
        n2=in.lfftout/2;
        in.lfftenh=in.lfftout/in.lfftin;
        in.dtin1=in.dtin/in.lfftenh;
        
        infft=zeros(1,in.lfftout);
        infft(in.ifr1:in.ifr2)=in.sbl;
        %x=in.ifr1:in.ifr2;
        %figure;plot(x,infft(x));
        in.chunk1=2*ifft(infft)*in.lfftenh;

        p=interp_ini(in.p1,in.v1,n2,DTin);
%         tch=tt1+toff+in.dtin1*(0:n2-1);
%         dtsd=in.sd_c2*tch.^2+in.sd_c3*tch.^3;
%         tt=tch+p+dtsd+in.Dteinst;
        
        tch=tt1+p+toff+in.dtin1*(0:n2-1)+in.Dteinst;
        if (in.sd_c4 == 0)
            dtsd=in.sd_c2*tch.^2+in.sd_c3*tch.^3;
        elseif in.sd_c6 == 0
            dtsd=in.sd_c2*tch.^2+in.sd_c3*tch.^3+in.sd_c4*tch.^4+in.sd_c5*tch.^5;
        else
            dtsd=in.sd_c2*tch.^2+in.sd_c3*tch.^3+in.sd_c4*tch.^4+in.sd_c5*tch.^5+in.sd_c6*tch.^6+in.sd_c7*tch.^7+in.sd_c8*tch.^8;
        end
        tt=tch+dtsd;

%%%%%%%%%%
        ph1sab=mod(in.f0*(dtsd),1)*2*pi;
    	exposa=exp(-1j*ph1sab);
        in.chunk1(1:n2)=in.chunk1(1:n2).*exposa;  
        [out iout]=strobo(in.chunk1(1:n2),tch,in.dtout,toff);
        
        %[out iout]=strobo(in.chunk1(1:n2),tt,in.dtout);
%%%%%%%%%%%%%%%%%%%
	
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
        tch=tt1+p+toff+in.dtin1*(0:n2-1)+in.Dteinst;
        if (in.sd_c4 == 0)
            dtsd=in.sd_c2*tch.^2+in.sd_c3*tch.^3;
        elseif in.sd_c6 == 0
            dtsd=in.sd_c2*tch.^2+in.sd_c3*tch.^3+in.sd_c4*tch.^4+in.sd_c5*tch.^5;
        else
            dtsd=in.sd_c2*tch.^2+in.sd_c3*tch.^3+in.sd_c4*tch.^4+in.sd_c5*tch.^5+in.sd_c6*tch.^6+in.sd_c7*tch.^7+in.sd_c8*tch.^8;
        end
        
        tt=tch+dtsd;

%%%%%%%%%%%%
        ph1sab=mod(in.f0*(dtsd),1)*2*pi;
        exposa=exp(-1j*ph1sab);
        in.chunk0(n2+1:n2+n4)=in.chunk0(n2+1:n2+n4).*exposa(1:n4);
        in.chunk1(n4+1:n2)=in.chunk1(n4+1:n2).*exposa(n4+1:n2);
        [out iout]=strobo([in.last in.chunk0(n2+1:n2+n4) in.chunk1(n4+1:n2)],tch,in.dtout,toff);
%%%%%%%%%%%%%%%%%%%%
        
%[out iout]=strobo([in.last in.chunk0(n2+1:n2+n4) in.chunk1(n4+1:n2)],tt,in.dtout);
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
        tch=tt1+toff+p+in.dtin1*(0:n2-1)+in.Dteinst;
        if (in.sd_c4 == 0)
            dtsd=in.sd_c2*tch.^2+in.sd_c3*tch.^3;
        elseif in.sd_c6 == 0
            dtsd=in.sd_c2*tch.^2+in.sd_c3*tch.^3+in.sd_c4*tch.^4+in.sd_c5*tch.^5;
        else
            dtsd=in.sd_c2*tch.^2+in.sd_c3*tch.^3+in.sd_c4*tch.^4+in.sd_c5*tch.^5+in.sd_c6*tch.^6+in.sd_c7*tch.^7+in.sd_c8*tch.^8;
        end
        
        tt=tch+dtsd;
%%%%%%%%%%%%%%%%%
        ph1sab=mod(in.f0*(dtsd),1)*2*pi;
        exposa=exp(-1j*ph1sab);
        in.chunk1(1:n2)=in.chunk1(1:n2).*exposa;
        [out iout]=strobo(in.chunk1(1:n2),tch,in.dtout,toff);
%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
    case 4 % last n2
        toff=0-in.empdelay; 
        n2=in.lfftout/2;
        p=interp_fin(in.p0,in.v0,n2,DTin);
%         tch=tt1+in.dtin1*(0:n2-1);
%         dtsd=in.sd_c2*tch.^2+in.sd_c3*tch.^3;
%         tt=tch+toff+p+dtsd+in.Dteinst;
        tch=tt1+p+toff+in.dtin1*(0:n2-1)+in.Dteinst;
        if (in.sd_c4 == 0)
            dtsd=in.sd_c2*tch.^2+in.sd_c3*tch.^3;
        elseif in.sd_c6 == 0
            dtsd=in.sd_c2*tch.^2+in.sd_c3*tch.^3+in.sd_c4*tch.^4+in.sd_c5*tch.^5;
        else
            dtsd=in.sd_c2*tch.^2+in.sd_c3*tch.^3+in.sd_c4*tch.^4+in.sd_c5*tch.^5+in.sd_c6*tch.^6+in.sd_c7*tch.^7+in.sd_c8*tch.^8;
        end
        
        tt=tch+dtsd;
%%%%%%%%%%%%%%%%%
        ph1sab=mod(in.f0*(dtsd),1)*2*pi;
        exposa=exp(-1j*ph1sab);
        in.chunk0(n2+1:n2*2)=in.chunk0(n2+1:n2*2).*exposa;
        [out iout]=strobo(in.chunk0(n2+1:n2*2),tch,in.dtout,toff);
%%%%%%%%%%%%%%%%%
       
end
%ope=in.op,tch_ini=tch(1),tch_fin=tch(length(tch))

in.tout=tt(1);
in.totout=in.totout+length(out);
in.p0=in.p1;
in.v0=in.v1;
in.chunk0=in.chunk1;
in.op=2;
p=p(1:64:length(p));
in.time(1)=tin;
in.time(2)=tt(1)-tt1;
%save PSS_FD

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


function [out iout]=strobo(x,tt,dtout,toff)

tt=tt/dtout;
tt1=floor(tt);
ii=find(diff(tt1));
out=x(ii+1);
iout=round(tt(ii(1))*dtout-toff);




  
