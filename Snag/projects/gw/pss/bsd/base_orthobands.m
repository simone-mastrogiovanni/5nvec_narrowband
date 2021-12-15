function out=base_orthobands(bandin,dt)
% basic orthobands info
% 
%   bandin     requested band
%   dt         sampling time
%
%       base orthobands
%  k   
%     dk 1 2 3 4 5 6 7 8 9...
%  0     * * * * * * * * * * * *
%  1     *
%  2     * *
%  3     *   *
%  4     * *   *
%  5     *       *
%  6     * * *     *
%  7     *           *
%  8     * *   *       *
%  9     *   *           *
% 10     * *     *         *
% 11     *                   *
% 12     * * * *    *          *
%
%  OBpar 1  bw, band width, in basic units (1,2,3,...)
%        2  bs, band start, in bw units (0,1,2,...)
%        3  sbd, sub-band divisor (1,2,3,...)
%        4  sbk, sub-band k (1,...,sbd)
%
%  red   = sbd/bw
%  dtout = dt*red

% Snag Version 2.0 - August 2019
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by O.J.Piccinni and S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

out.bandin=bandin;
out.dt0=dt;
Dbandin=diff(bandin);
kmaxband=ceil(bandin(2)*dt);
% bandmax=kmaxband/dt;

KdK=zeros(kmaxband+1,kmaxband);
KK=zeros(kmaxband+1,2*kmaxband);

for k = 1:kmaxband
    KdK(1:k:kmaxband+1,k)=1;
end

out.KdK=KdK;

for k = 1:kmaxband+1
    KK(k,k:2*k-2)=KdK(k,1:k-1);
end
KK(1,:)=1;

out.KK=KK;

kbandin=bandin*dt;
kb=floor(kbandin);
out.kbandin=kbandin;
out.kb=kb;

[i1,i2]=find(KK);
out.obstot=[i1-1,i2-1];

j1=find(i1 <= kb(1)+1 & i2 >= kb(2)+1);
k1=i1(j1)-1;
k2=i2(j1)-1;
% out.obss=[k1,k2];
[mk,kk]=min(k2-k1);
out.ob=[k1(kk),k2(kk)];
out.OBand=out.ob/dt;
out.DT=dt./(mk+1);
out.nband=diff(out.ob)+1;

bandtot=1/out.DT;
Nob=ceil(bandtot/Dbandin);
eps0=eps*10;

for kk = Nob:-1:1
    wob=bandtot/kk;
    i1=floor(bandin(1)/wob+eps0);
    b(1)=i1*wob;
    b(2)=b(1)+wob; 
    if b(1) <= bandin(1)+eps0 && b(2) >= bandin(2)-eps0
        jj=i1+1;
        break
    end
end

out.bandout=b;
out.kord=kk;
out.jband=mod(jj,kk);
if kk == 1
    out.jband=1;
end
out.dtout1=out.DT*kk;

out.bw=out.nband;
out.bs=kb(1);
out.sbd=out.kord
out.sbk=out.jband;
out.OBpar=[out.bw,out.bs,out.sbd,out.sbk];
out.red=out.sbd/out.bw;
out.dtout=dt*out.red;