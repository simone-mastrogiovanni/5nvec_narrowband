function a=ffilt_gd(b,filt)
%GD/FFILT_GD   frequency domain filtering
%
%      a=ffilt_gd(b,filt)
%       or
%      a=ffilt_gd(b)
%
%      a,b    input,output gds
%      filt   array containing the filter
%
% If the function is called without "filt", the filter can be loaded from a mat file
% containing a double array.

% Version 1.0 - November 1999
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1999  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

snag_local_symbols;

if ~exist('filt')
   [filtfile,dir]= uigetfile([filtdir '*.mat'],'File containing the filter');
   
   eval(['load ' dir filtfile]);
   eval(['filt=' filtfile(1:length(filtfile)-4)]);
end

filt=filt(:);
lenfil=length(filt);

lendat=b.n+lenfil/2;


npiece=ceil((2*lendat)/lenfil)-2;
lendat=npiece*lenfil/2

x(1:lenfil/4)=0;
x(lenfil/4+1:lenfil/4+b.n)=b.y;
x(lenfil/4+b.n+1:lendat)=0;
x=x(:);
yy=zeros(b.n,1);

ii=0;
lenfil2=lenfil/2;
lenfil4=lenfil/4;

for i = 1:npiece
   y=fft(x(ii+1:ii+lenfil));
   y=y.*filt;
   y=ifft(y);
   
   yy(ii+1:ii+lenfil2)=y(lenfil4+1:lenfil4+lenfil2);
   ii=ii+lenfil2;
end

a=gd(b);
capt=[b.capt ' freq filt'];

a=edit_gd(a,'y',yy(1:b.n),'capt',capt);
