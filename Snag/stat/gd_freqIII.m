function [fr amp t]=gd_freqIII(g)
% gd_freqIII  computes varying frequency and amplitude
%
%    [fr amp]=gd_freqII(g,tres)
%
%   tres   [(pieces length) (how many shifts for a piece) overresolution]
%              pieces length                       def 1/50 of total
%              how many shifts for a piece (int)   def 10
%              overresolution                      50
%                 0 means default

% Version 2.0 - April 2011
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

x=x_gd(g);
dx=dx_gd(g);
y=y_gd(g);
y=y-mean(y);
n=n_gd(g);
iii=0;
y1=rota(y,1);
y2=rota(y,-1);
y(1)=0;
y2(1)=0;
y2(n)=0;

ii1=find(y.*y1 <= 0 & y > 0);

m=length(ii1)-1;

fr=zeros(1,m);
amp=fr;
t=fr;
ii=ii1(1);
xx0=x(ii-1)-y1(ii)*dx/(y(ii)-y1(ii));

for i = 1:m
    ii=ii1(i+1);
    xx=x(ii-1)-y1(ii)*dx/(y(ii)-y1(ii));
    t(i)=xx;
    fr(i)=1/(xx-xx0);
    xx0=xx;
end

jj1=find(y > y1 & y >= y2 & y2 ~= 0);
jj2=find(y < y1 & y <= y2 & y2 ~= 0);

m=min(length(jj1),length(jj2))-1;length(jj1),length(jj2)

% X:  -1  0  1
% Y:  y1  y  y2
%
% Y = aX^2+bX+c
%
% c=y
% b=(y2-y1)/2
% a=(y1+y2)/2-c
%
% xmax=-b/2a

for i = 1:m-1
    ii1=jj1(i+1);
    ii2=jj2(i+1);
    c=y(ii1);
    b=(y2(ii1)-y1(ii1))/2;
    a=(y1(ii1)+y2(ii1))/2-c;
    xmax=-b/(2*a);
    ymax=a*xmax^2+b*xmax+c;
    
    c=y(ii2);
    b=(y2(ii2)-y1(ii2))/2;
    a=(y1(ii2)+y2(ii2))/2-c;
    xmin=-b/(2*a);
    ymin=a*xmin^2+b*xmin+c;
    amp(i)=(ymax-ymin)/2;
end

n=min(length(amp),length(fr));
amp=amp(1:n);
fr=fr(1:n);
t=t(1:n);