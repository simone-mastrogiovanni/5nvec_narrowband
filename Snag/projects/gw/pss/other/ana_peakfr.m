function [his sp sh lin lintot]=ana_peakfr(pf,nofr,thr,maxfr,res)
% ANA_PEAKFR  analyses peakfr
%
%    [his sp lin]=ana_peakfr(pf,thr)
%
%   pf     peakfr gd
%   nofr   cancelled bands (sorted; by nofr=read_virgolines(10,2000);) 
%   thr    threshold
%   maxfr  max frequency
%   res    resolution (1 = natural)

% Version 2.0 - June 2007
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

pf1=gd_peaks(pf,thr);
[y n df ini capt x]=extr_gd(pf1);
N=0;
j1=1;
for i = 1:n
    iok=1;
    for j = j1:length(nofr)
        if x(i) >= nofr(j,1)-nofr(j,2) & x(i) <= nofr(j,1)+nofr(j,2)
            iok=0;
            j1=j;
            continue;
        end
    end
    if iok == 1
        N=N+1;
        x(N)=x(i);
        y(N)=y(i);
    end
end

x=x(1:N);
y=y(1:N);
pf1=edit_gd(pf1,'x',x,'y',y,'n',N);
 
figure,plot(pf1,'.'),grid on

pf=y_gd(pf);
dhis=max(pf)/100;
x=0:dhis:max(pf)*1.01;
his=hist(pf,x);

figure,stairs(x,his),grid on
his=gd(his);
his=edit_gd(his,'dx',dhis,'capt','peakfr histogram');

sp=peak_spec(pf1,100,1/maxfr,res);

figure,semilogy(sp),grid on

[sh lin lintot]=search_harmonics(pf1,0.6,60,0.01);
figure,plot(sh),grid on

% sh=search_harmonics(pf1,0,6,0.001);
% figure,plot(sh),grid on
   