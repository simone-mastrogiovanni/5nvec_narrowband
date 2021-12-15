function [out cohe inif DF yy]=band_5matfilt_cohe(gin,fr0,sig,band,k4)
% BANDK_5MATFILT_2  computes a set of matched filters on an entire band
%                   enhanced version
%
%   out=band_5matfilt(gin,fr0,mf,band)
%
%    gin       input gd
%    fr0       signal apparent frequency
%    sig(n,5)  signal bank
%    band      [mean max] frequency
%    k4        spectral enhancement factor

% Version 2.0 - February 2009
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

if ~exist('k4','var')
    k4=4;
end

y=y_gd(gin);
dt=dx_gd(gin);
n=length(y);

TS=86164.09053083288;

N=round(ceil(k4*n*dt/TS)*TS/dt);
y(n:N)=0;

DF=1/(N*dt);
dn=round(1/(DF*TS));
y=fft(y);
k1=round(band(1)/DF)+1;
k2=round(band(2)/DF);
inif=(k1-1)*DF;
y=y(k1:k2)*dt;
n=length(y);

[i1,i2]=size(sig);
out=zeros(i1,n-4*dn);
cohe=out;
out2=zeros(2,n-4*dn);
cohe2=out2;
mf=sig*0;

for i = 1:i1
    mf(i,:)=conj(sig(i,:))/sum(abs(sig(i,:)).^2);
    data=[y(1:n-4*dn) y(1+dn:n-3*dn) y(1+2*dn:n-2*dn) y(1+3*dn:n-dn) y(1+4*dn:n)];
    out(i,:)=mf(i,1)*y(1:n-4*dn)+mf(i,2)*y(1+dn:n-3*dn)+...
        mf(i,3)*y(1+2*dn:n-2*dn)+mf(i,4)*y(1+3*dn:n-dn)+mf(i,5)*y(1+4*dn:n);
    for j = 1:5
        cohe(i,:)=cohe(i,:)+abs(out(i,:).*sig(i,j)).^2;
    end
    cohe(i,:)=cohe(i,:)./sum(abs(data').^2);
end

for j = 1:5
    cohe2(1,:)=cohe2(1,:)+abs(out(1,:).*sig(1,j)+out(2,:).*sig(2,j)).^2;
    cohe2(2,:)=cohe2(2,:)+abs(out(3,:).*sig(3,j)+out(4,:).*sig(4,j)).^2;
end

cohe2(1,:)=cohe2(1,:)./sum(abs(data').^2);
cohe2(2,:)=cohe2(2,:)./sum(abs(data').^2);

% out(i1+1,:)=y(1:n-4*dn)+y(1+dn:n-3*dn)+...
%         y(1+2*dn:n-2*dn)+y(1+3*dn:n-dn)+y(1+4*dn:n);

out1=abs(out).^2;
out2(1,:)=out1(1,:)+out1(2,:);
out2(2,:)=out1(3,:)+out1(4,:);
mout=mean(out1.');
for i = 1:i1
    out1(i,:)=out1(i,:)/mout(i);
end

mout2=mean(out2.');
out2(1,:)=out2(1,:)/mout2(1);
out2(2,:)=out2(2,:)/mout2(2);

[j1,j2]=size(out);
% x=(round((inif-fr0+2/TS)/DF)+(0:j2-1))*DF;
k1=floor(-(inif-fr0+2/TS)/DF)+1;
k2=ceil(-(inif-fr0+2/TS)/DF)+1;
x=(inif-fr0+2/TS)+(0:j2-1)*DF;
x1=x(k1);
x2=x(k2); % x1,x2
k0=round((fr0-inif-2/TS)/DF)+1; % k0,k1,k2
ma=max(max(out1));
mi=min(min(out1))+eps;
figure,plot(x,out1'),grid on,hold on,title('Normalized matched filter output')
plot([-2 -2]*1/TS,[mi ma],'m')
plot([-1 -1]*1/TS,[mi ma],'m')
plot([0 0]*1/TS,[mi ma],'m')
plot([1 1]*1/TS,[mi ma],'m')
plot([2 2]*1/TS,[mi ma],'m')

mm=max(max(out1));

figure,plot(x,cohe'),grid on,hold on,plot([0 0],[0 1],'m'),title('Squared Coherence'),xlabel('Hz')
figure,plot(x,out1'/mm),grid on,hold on,plot([0 0],[0 1],'m')
title('Normalized matched filter output with coherence')
ylabel('Coherence'),xlabel('Hz')
plot(x,cohe',':+')

mco=max(max(cohe.*out1));

% figure,plot(x,(cohe.*out1)'/mco),grid on,hold on,plot([0 0],[0 1],'m'),title('Significance'),xlabel('Hz')

figure,hist(out1',200)

dxh=0.005;
xh=dxh/2:dxh:1;
hc=hist(cohe.',xh)/(dxh*j2);
figure,plot(xh,hc),grid on,title('Distribution of coherence')
ct=4*(1-xh).^3;
hold on, plot(xh,ct,'r--','LineWidth',2)

% figure,hist(sqrt((cohe.*out1)'/mco),200)

% cohe1=cohe(:);
% hcoh=histc(cohe1,0:0.005:1);
% pcoh=cumsum(hcoh(length(hcoh):-1:1));
% pcoh=pcoh(length(pcoh):-1:1)/pcoh(length(pcoh));
% figure,plot((0:length(pcoh)-1)*0.005,pcoh),grid on

nr=n-4*dn-k0+1
runmax1=zeros(i1,k0);
runmax2=zeros(i1,nr);size(runmax2)

disp(' Mean   Std    Sig')
for i = 1:i1
    yy(i)=out1(i,k1)+((out1(i,k2)-out1(i,k1))/(x2-x1))*(-x1);
    disp(sprintf(' %e  %e    %e',mean(out1(i,:)),std(out1(i,:)),yy(i)));
    runmax1(i,:)=running_max(out1(i,k0:-1:1));
    runmax2(i,1:nr)=running_max(out1(i,k0:k0+nr-1));
end

figure,semilogx((1:k0)*DF,runmax1'),grid on,title('Lower frequency'),xlabel('Hz'),ylabel('Highest value')
figure,semilogx((1:length(runmax2))*DF,runmax2),grid on,title('Higher frequency'),xlabel('Hz'),ylabel('Highest value')


% F-stat

mm=max(max(out2));

figure,plot(x,cohe2'),grid on,hold on,plot([0 0],[0 1],'m'),title('F-stat Squared Coherence'),xlabel('Hz')
figure,plot(x,out2'/mm),grid on,hold on,plot([0 0],[0 1],'m')
title('F-stat Normalized matched filter output with coherence')
ylabel('Coherence'),xlabel('Hz')
plot(x,cohe2.',':+')

figure,hist(out2.',200),title('normalized F-stat histogram')


hc2=hist(cohe2.',xh)/(dxh*j2);
figure,plot(xh,hc2),grid on,title('Distribution of coherence 4-dof')
ct2=12*xh.*(1-xh).^2;
hold on, plot(xh,ct2,'r--','LineWidth',2)

% figure,hist(cohe2',200),title('F-stat coherence histogram')
% figure,hist(sqrt((cohe.*out1)'/mco),200)

% cohe1=cohe2(:);
% hcoh=histc(cohe1,0:0.005:1);
% pcoh=cumsum(hcoh(length(hcoh):-1:1));
% pcoh=pcoh(length(pcoh):-1:1)/pcoh(length(pcoh));
% figure,plot((0:length(pcoh)-1)*0.005,pcoh),grid on,title('F-stat coherence probability')

nr=n-4*dn-k0+1
runmax1=zeros(i1,k0);
runmax2=zeros(i1,nr);size(runmax2)

disp(' Mean   Std    Sig')
for i = 1:2
    yy(i)=out2(i,k1)+((out2(i,k2)-out2(i,k1))/(x2-x1))*(-x1);
    disp(sprintf(' %e  %e    %e',mean(out1(i,:)),std(out1(i,:)),yy(i)));
    runmax1(i,:)=running_max(out2(i,k0:-1:1));
    runmax2(i,1:nr)=running_max(out2(i,k0:k0+nr-1));
end

figure,semilogx((1:k0)*DF,runmax1'),grid on,title('Lower frequency (F-stat)'),xlabel('Hz'),ylabel('Highest value')
figure,semilogx((1:length(runmax2))*DF,runmax2),grid on,title('Higher frequency (F-stat)'),xlabel('Hz'),ylabel('Highest value')

