function vout=tdwin(varargin)
%TDWIN  transformed domain windowing: eliminates high "frequencies"
% Operates on data (stretch of length a power of 2) in the transformed domain
% Useful for frequency domain filters
%
%  arg1    input double array or gd (vin)
%
%   keys :
%     'bartlett'
%     'cosine'
%     'gauss'       gaussian
%
%     'hhole'       half length hole in the center (standard for filters)
%     'amplitude'   followed by amp, windows amplitude (max 1)
%     'sqrt'        operates on the sqrt (to create a simulation)
%     'real'        forces the output to be real

% Version 1.0 - July 1998 - 2003
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

amp=1;
icwin=0;
hhole=0;
icsqrt=0;
icreal=0;
icgd=0;

vin=varargin{1};
if isa(vin,'gd')
    vin1=vin;
    vin=y_gd(vin);
    icgd=1;
end

for i = 2:length(varargin)
   str=varargin{i};
   switch str
   case 'bartlett'
      icwin=1;
   case 'cosine'
      icwin=2;
   case 'gauss'
      icwin=3;
  case 'hhole'
      hhole=1;
   case 'amplitude'
      amp=varargin{i+1};
   case 'sqrt'
      icsqrt=1;
   case 'real'
      icreal=1;
   end
end

if icsqrt == 1
    vin=sqrt(real(vin));
end

vout=fft(vin);
len=length(vin);%figure,plot(real(vout)),
len2=len/2;
if hhole == 1
    len2=len/4;
end
lw=round((len2-1)*amp);

switch icwin
case 1
   for i = 1:lw
      win=(lw-i)/lw;
      ii=len2-lw+i;
      vout(ii)=vout(ii)*win;
      ii=len+2-ii;
      vout(ii)=vout(ii)*win;
   end
case 2
   for i = 1:lw
      win=(1+cos(i*pi/lw))/2;
      ii=len2-lw+i;
      vout(ii)=vout(ii)*win;
      ii=len+2-ii;
      vout(ii)=vout(ii)*win;
   end
case 3
   for i = 1:lw
      win=exp(-(i*3/lw)^2);
      ii=len2-lw+i;
      vout(ii)=vout(ii)*win;
      ii=len+2-ii;
      vout(ii)=vout(ii)*win;
   end
end

if hhole == 1
    vout(len/4+1:3*len/4+1)=0;  % len/2 +1 -len/4 -> len/2+1 +len/4
%     for i = 1:10
%         vout(len/4-i+1)=vout(len/4-i+1)/(11-i);
%         vout(3*len/4+1+i)=vout(3*len/4+1+i)/(11-i);
%     end
    len8=len/8; %vout=vout*0+1;
    for i = 1:len8
        vout(len/4-i+1)=vout(len/4-i+1)*(1-cos(i*pi/len8))/2;
        vout(3*len/4+1+i)=vout(3*len/4+1+i)*(1-cos(i*pi/len8))/2;
    end
end
% figure,plot(abs(vout)),

vout(len2+1)=0;
vout=ifft(vout);
if icreal == 1
   vout=real(vout);
end
if icsqrt == 1
    vout=vout.^2;
end
if hhole == 1
    ind=find(vout<0);
    vout=abs(vout);
    ind=ind(3:length(ind-2));
    for jj = ind
        vout(jj)=(mean(vout(jj-3:jj-1))+mean(vout(jj+1:jj+3)))/2;
    end
end

if icgd == 1
    vout=edit_gd(vin1,'y',vout,'capt',[capt_gd(vin1) '->tdwin']);
end