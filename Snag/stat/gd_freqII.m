function [fr amp]=gd_freqII(g,tres)
% gd_freqII  computes varying frequency and amplitude
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

if ~exist('tres','var')
    tres=[0 0 0];
end
if tres(1) == 0
    t=x_gd(g);
    tres(1)=(max(t)-min(t))/50;
end
if tres(2) == 0
    tres(2)=10;
end
if tres(3) == 0
    tres(3)=50;
end

dt=dx_gd(g);
n1=round(tres(1)/dt);
n2=round(n1/tres(2));
n1=n2*tres(2);
res=tres(3);

y=y_gd(g);
n=length(y);
jj=0;

for i = 1:n2:n-n1+1
    jj=jj+1;
    yy=y(i:i+n1-1);
    yy=gd(yy);
    yy=edit_gd(yy,'dx',dt);
    s=gd_pows(yy,'resolution',res,'window',2,'nobias','short');
    sx=x_gd(s);
    sy=y_gd(s);
    [aa ii]=max(sy);
    ii1=max(1,ii-3*res);
    ii2=min(length(sy),ii+3*res);
    fr(jj)=sx(ii);
    amp(jj)=sqrt(sum(sy(ii1:ii2)*4)*dx_gd(s));
end

fr=gd(fr);
fr=edit_gd(fr,'ini',ini_gd(g)+n2*dt/2,'dx',n2*dt);
amp=gd(amp);
amp=edit_gd(amp,'ini',ini_gd(g)+n2*dt/2,'dx',n2*dt);