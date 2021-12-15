function [dout s]=maxdemspect(din,shlen,interl,perc)
% maxdemspet  Maxwell demon based filter and spectrum
%
%      s=maxdemspect(din,shlen)
%
%  din     data input (array or gd)
%  shlen   short pieces length (for interlaced operations, shlen should be
%           a multiple of 4)
%  interl  interlaced (1 yes, 0 no)
%  perc    percentage (0-1) of kept data

% Version 2.0 - June 2007
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

s=0;
if isa(din,'gd')
    igd=1;
    dt=dx_gd(din);
    len=n_gd(din);
    din=y_gd(din);
else
    din=din(:);
    igd=0;
    dt=1;
    len=length(din);
end

dout=din*0;
N=2*floor((interl+1)*len/(shlen*2))-interl;
N1=ceil(N*perc);
delay=shlen/(1+interl);
ini=1;
A=zeros(N,shlen);
if interl == 1
    win=pswindow('flatcos',shlen);
else
    win=ones(1,shlen);
end

for i = 1:N
    a=din(ini:ini+shlen-1);
    ini=ini+delay;
    A(i,:)=fft(a.*win.');
end

for i = 1:shlen
    [a1,i1]=sort(abs(A(:,i)));
    a1=a1*0;
    a1(i1(1:N1))=1;
    A(:,i)=A(:,i).*a1;
end

ini=1;
i1=1;
i2=shlen;
if interl == 1
    i1=shlen/4+1;
    i2=i1+shlen/2-1;
end

for i = 1:N
    a=A(i,:);
    a=ifft(a);
    dout(ini:ini+delay-1)=a(i1:i2);
    ini=ini+delay;
end

dout=dout*sqrt(N/N1);

if igd == 1
    dout=gd(dout);
    dout=edit_gd(dout,'dx',dt,'capt','max_dem');
end