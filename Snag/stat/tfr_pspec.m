function [sp nev pow]=tfr_pspec(tt,T,res,freq)
% Time-frequency pulse power spectrum
%
%    sp=tfr_pspec(tt,T,res,freq)
%
%   tt    events time (in days)
%   T     time window (in days)
%   res   resolution
%   freq  [frmin frmax] (in Hz)

% Version 2.0 - December 2012
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome


minnumev=4;

init=min(tt);
tt=sort(tt)*86400;
T=T*86400;
ntt=length(tt);
T0=tt(length(tt))-tt(1);
T2=T/2;
Nt=ceil(T0/T2);
i=floor((tt-tt(1))/T2)+1;   max(i)
di=diff(i);
jj=find(di);
di=di(jj);
ii=zeros(Nt,1);
ij=0;
for i = 1:length(jj)
    ij=ij+di(i);
    ii(ij)=jj(i);
end
ii=[ii' ntt];
Nt=ceil(T0/T2);
dfr=1/(2*T*res);
Nfr=ceil((freq(2)-freq(1))/dfr);
if Nt*Nfr > 1e8;
    fprintf('Nfr = %d, Nt = %d : too big \n',Nfr,Nt);
    sp=0;nev=0;pow=0;
    return
else
    fprintf('Nfr = %d, Nt = %d \n',Nfr,Nt);
end
sp=zeros(Nt,Nfr);
nev=zeros(Nt,1);
pow=zeros(Nfr,1);

fr=freq(1)+(0:Nfr)*dfr;
% Ns=sp;
% N=0;

f=exp(-1j*2*pi*fr(1)*tt);
df=exp(-1j*2*pi*dfr*tt);

for j = 1:Nfr
    i1=1;
    if j == floor(j/1000)*1000;
        fprintf('%d done \n',j/Nfr)
    end
    for i = 2:Nt
        iii=i1:ii(i);
        niii=length(iii);
        if niii >= minnumev
            sp(i,j)=abs(sum(f)).^2/niii^2;
        end
        i1=ii(i-1)+1;
        if j == 2
            nev(i)=niii;
        end
    end
    f=f.*df;
    pow(j)=mean(sp(:,j));
end

sp=gd2(sp);
sp=edit_gd2(sp,'ini',floor(init),'dx',T2/86400,'ini2',freq(1),'dx2',dfr);
nev=gd(nev);
nev=edit_gd(nev,'ini',floor(init),'dx',T2/86400);
pow=gd(pow);
pow=edit_gd(pow,'ini',freq(1),'dx',dfr);
