function powsout=pows_ds(varargin)
%POWS_DS  computes running power spectrum of a ds
%
%  outputs a power spectrum
%
%  first input:   a ds
%  second input:  a double array (the same as powsout, zeroed at beginning)
%
%  keys:
%
%   'single'   single chunk
%   'total'    mean value until now
%   'ar'       autoregressive, followed by the tau (measured in units of chunks)
%
%   'nwindow'  no window
%   'bwindow'  Bartlett window
%   'hwindow'  Hanning window
%
%   'limit'    limits on the frequency axis; followed by f1,f2
%   'logy'     semilog y
%   'loglog'   
%   'sqrt'     square root of the power spectrum

% Version 1.0 - July 1998
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (c) 1998  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

d=varargin{1};
powsout=varargin{2};

kds=d.lcw;
dt=d.dt;
len=d.len;
df=1/(len*dt);
xfig=(0:len-1)*df;
x1=0;
x2=xfig(len);
ind1=1;
ind2=len;

ichist=0;
iclog=0;
icsqrt=0;
tau=1;
icwind=0;

for i = 3:length(varargin)
   str=varargin{i};
   switch str
   case 'single'
      ichist=0;
   case 'total'
      ichist=1;
   case 'ar'
      ichist=2;
      tau=varargin{i+1};
      w=exp(-1/tau);
   case 'limit'
      x1=varargin{i+1};
      x2=varargin{i+2};
      ind1=indsel(0,df,len,x1);
      ind2=indsel(0,df,len,x2);
   case 'logy'
      iclog=1;
   case 'loglog'
      iclog=2;
   case 'sqrt'
      icsqrt=1;
   case 'nwindow'
      icwind=0;
   case 'bwindow'
      icwind=1;
   case 'hwindow'
      icwind=2;
   end
end

if kds == d.nc1
   y=d.y1(1:d.len);
else
   y=d.y2;
end

if icwind == 1
   y=y.*pswindow('bartlett',length(y));
elseif icwind == 2
   y=y.*pswindow('hanning',length(y));
end

if kds == 1
   h0scra = figure('Color',[0.8 0.8 0.8], ...
      'Name','ds Power Spectrum',...
	   'Position',[232 288 560 420]);
   h1scra = axes('Parent',h0scra, ...
	   'Box','on', ...
	   'CameraUpVector',[0 1 0], ...
	   'Color',[1 1 1], ...
	   'XColor',[0 0 0], ...
	   'YColor',[0 0 0], ...
      'ZColor',[0 0 0]);
   powsout=zeros(1,len);
end

yfig=abs(fft(y)).^2/len;
if icsqrt == 1
   yfig=sqrt(yfig);
end

switch ichist
case 0
   [Xfig,Yfig]=tostairs(xfig,yfig);
   tcol=rotcol(kds);
   h2scra = line('Parent',gca,'XData',Xfig,'YData',Yfig);
   zoom on; grid on;hold on;
   powsout=yfig;
case 1
   yfig=(yfig+powsout*(kds-1))/kds;
   powsout=yfig;
   [Xfig,Yfig]=tostairs(xfig(ind1:ind2),yfig(ind1:ind2));
   tcol=rotcol(kds);
   %h2scra = line('Parent',gca,'XData',Xfig,'YData',Yfig);
   if iclog == 0
      plot(Xfig,Yfig);
   elseif iclog == 1
      semilogy(Xfig,Yfig);
   else
      loglog(Xfig,Yfig);
   end
   zoom on; grid on; hold off;
case 2
   yfig=((1-w)/(1-w^kds))*yfig+w*powsout;
   histout=yfig;
   [Xfig,Yfig]=tostairs(xfig,yfig);
   tcol=rotcol(kds);
   %h2scra = line('Parent',gca,'XData',Xfig,'YData',Yfig);
   if iclog == 0
      plot(Xfig,Yfig);
   elseif iclog == 1
      semilogy(Xfig,Yfig);
   else
      loglog(Xfig,Yfig);
   end
   zoom on; grid on;
end
