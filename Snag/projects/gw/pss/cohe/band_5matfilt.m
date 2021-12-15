function [out inif DF,yy]=band_5matfilt(gin,fr0,mf,band,k4)
% BAND_5MATFILT  computes a set of matched filters on an entire band
%
%   out=band_5matfilt(gin,fr0,mf,band)
%
%    gin       input gd
%    fr0       signal apparent frequency
%    mf(n,5)   matched filter bank
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

[i1,i2]=size(mf);
out=zeros(i1,n-4*dn);
out2=zeros(2,n-4*dn);

for i = 1:i1
    out(i,:)=mf(i,1)*y(1:n-4*dn)+mf(i,2)*y(1+dn:n-3*dn)+...
        mf(i,3)*y(1+2*dn:n-2*dn)+mf(i,4)*y(1+3*dn:n-dn)+mf(i,5)*y(1+4*dn:n);
end

out1=abs(out).^2;
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
figure,plot(x,out1'),grid on,hold on,
plot([-2 -2]*1/TS,[mi ma],'m')
plot([-1 -1]*1/TS,[mi ma],'m')
plot([0 0]*1/TS,[mi ma],'m')
plot([1 1]*1/TS,[mi ma],'m')
plot([2 2]*1/TS,[mi ma],'m')

figure,hist(out1',200),title('Single filter distribution')

out2(1,:)=out1(1,:)+out1(2,:);
out2(2,:)=out1(3,:)+out1(4,:);

out3=out2(1,:)-out2(2,:);

ma=max(max(out2));
mi=min(min(out2))+eps;
figure,plot(x,out2'),grid on,hold on,
plot([-2 -2]*1/TS,[mi ma],'m')
plot([-1 -1]*1/TS,[mi ma],'m')
plot([0 0]*1/TS,[mi ma],'m')
plot([1 1]*1/TS,[mi ma],'m')
plot([2 2]*1/TS,[mi ma],'m')

figure,hist(out2',200),title('F statistics')

disp(' Mean   Std    Sig')
for i = 1:i1
    yy(i)=out1(i,k1)+((out1(i,k2)-out1(i,k1))/(x2-x1))*(-x1);
    disp(sprintf(' %e  %e    %e',mean(out1(i,:)),std(out1(i,:)),yy(i)));
end

figure,plot(x,out3'),grid on,hold on,
plot([-2 -2]*1/TS,[mi ma],'m')
plot([-1 -1]*1/TS,[mi ma],'m')
plot([0 0]*1/TS,[mi ma],'m')
plot([1 1]*1/TS,[mi ma],'m')
plot([2 2]*1/TS,[mi ma],'m'),title('Difference f-stat')

figure,hist(out3',200),title('Difference f-stat')