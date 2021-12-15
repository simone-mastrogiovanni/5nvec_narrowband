function [powsout,answ]=ipows_ds(varargin)
%IPOWS_DS  computes running power spectrum of a ds
%
%  outputs a power spectrum
%
%  first input:   a ds
%  second input:  a double array (the same as powsout, zeroed at beginning)
%  third input:   answ, a cell array, not initiated
%
%  keys:
%
%   'interact' interactive setting: some settings are default 
%
%   'single'   single chunk
%   'total'    mean value until now
%   'ar'       autoregressive, followed by the tau (measured in units of chunks)
%   'dar'      autoregressive and last, followed by the tau (in units of chunks)
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
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

d=varargin{1};
powsout=varargin{2};
answ=varargin{3};

kds=d.lcw;
dt=d.dt;
len=d.len;
df=1/(len*dt);
xfig=(0:len-1)*df;
x11=0;
x21=xfig(len);
ind1=1;
ind2=len;

icint=0;

ichist1=0;
iclog1=0;
icsqrt1=0;
tau1=6;
icwind1=0;

for i = 4:length(varargin)
   str=varargin{i};
   switch str
   case 'interact'
      icint=1;
   case 'single'
      ichist1=0;
   case 'total'
      ichist1=1;
   case 'ar'
      ichist1=2;
      tau1=varargin{i+1};
   case 'dar'
      ichist1=3;
      tau1=varargin{i+1};
   case 'limit'
      x11=varargin{i+1};
      x21=varargin{i+2};
   case 'logy'
      iclog1=1;
   case 'loglog'
      iclog1=2;
   case 'sqrt'
      icsqrt1=1;
   case 'nwindow'
      icwind1=0;
   case 'bwindow'
      icwind1=1;
   case 'hwindow'
      icwind1=2;
   end
end

if icint < 1
   ichist=ichist1;
   iclog=iclog1;
   icsqrt=icsqrt1;
   tau=tau1;
   icwind=icwind1;
   x1=x11;
   x2=x21;
end

if kds == d.nc1
   y=d.y1(1:d.len);
else
   y=d.y2;
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
   
   if icint > 0
       if exist('x11')
           fr1=x11;
           fr2=x21;
       else
           fr1=0;
           fr2=5000;
       end
      ginpowsds;
   end
else
   if icint > 0
      ichist=eval(answ{1});
      tau=eval(answ{2});
      iclog=eval(answ{3});
      icsqrt=eval(answ{4});
      icwind=eval(answ{5});
      x1=eval(answ{6});
      x2=eval(answ{7});
      if x2 > x21
         x2=x21;
      end
   end
end

ind1=indsel(0,df,len,x1);
ind2=indsel(0,df,len,x2);
w=exp(-1/tau);

if icwind == 1
   y=y.*pswindow('bartlett',length(y));
elseif icwind == 2
   y=y.*pswindow('hanning',length(y));
elseif icwind == 3
   y=y.*pswindow('flatcos',length(y));
end

yfig=abs(fft(y)).^2*dt/length(y);
if icsqrt == 1
   yfig=sqrt(yfig*2);
end

switch ichist
case 0
   [Xfig,Yfig]=tostairs(xfig(ind1:ind2),yfig(ind1:ind2));
   tcol=rotcol(kds);
   %h2scra = line('Parent',gca,'XData',Xfig,'YData',Yfig);
   powsout=yfig;
   if iclog == 0
      plot(Xfig,Yfig,'color',tcol);
   elseif iclog == 1
      semilogy(Xfig,Yfig,'color',tcol);
   else
      hl=loglog(Xfig,Yfig,'color',tcol);
   end
   %line('color',tcol);
   zoom on; grid on; hold off;
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
   zoom on; grid on;
case 3
   yfig1=yfig;
   yfig1=((1-w)/(1-w^kds))*yfig1+w*powsout;
   histout=yfig;
   [Xfig,Yfig]=tostairs(xfig(ind1:ind2),yfig(ind1:ind2));
   [Xfig,Yfig1]=tostairs(xfig(ind1:ind2),yfig1(ind1:ind2));
   tcol=rotcol(kds);
   %h2scra = line('Parent',gca,'XData',Xfig,'YData',Yfig);
   if iclog == 0
      plot(Xfig,Yfig,'r',Xfig,Yfig1);
   elseif iclog == 1
      semilogy(Xfig,Yfig,'r',Xfig,Yfig1);
   else
      loglog(Xfig,Yfig,'r',Xfig,Yfig1);
   end
   zoom on; grid on;
end
