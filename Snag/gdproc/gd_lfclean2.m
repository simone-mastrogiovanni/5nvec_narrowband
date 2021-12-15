function [out out_lp]=gd_lfclean2(gdin,lf)
% gd_lfclean  subtracts low frequencies
%
%     out=gd_lfclean(gdin,winlen)
%
%   gdin   input gd
%   lf     cut low (pseudo)frequency

% Version 2.0 - March 2012
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

out_lp=0;
if ~exist('lf','var')
    lf=1/7;
end

M=y_gd(gdin);
n=length(M);
t=x_gd(gdin);
ii=find(M);
n1=length(ii);
M1=M(ii);
t1=t(ii);
me=mean(M1);

T=max(t1)-min(t1);
% dt=T/(n1-1);
df=1/T;
klf=round(lf/df);
disp(sprintf('Tobs = %f  df = %f  n1 = %d  klf = %d',T,df,n1,klf))
klf1=ceil(klf/10);
dklf=klf1-klf;

F=fft(M1);
F(1:klf+1)=0;
F(n1:-1:n1-klf+1)=0;
F(klf+2:klf1+1)=F(klf+2:klf1+1)*(1:dklf)/dklf;
F(n1-klf:-1:n1-klf1+1)=F(n1-klf:-1:n1-klf1+1)*(1:dklf)/dklf;
M2=ifft(F)+me;
M(ii)=M2;

% figure,plot(t),hold on,plot(t(base_min),'g'),plot(t(base_max),'r'),grid on

out=gdin;
out=edit_gd(out,'y',M2,'capt',[capt_gd(gdin) '-> subtracted lp']);
% out_lp=edit_gd(out,'y',M2,'capt',[capt_gd(gdin) '-> lp']);


figure,plot(gdin,'.'),hold on,plot(out,'r.')