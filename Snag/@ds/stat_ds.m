function [histout,histx,m,s]=stat_ds(varargin)
%STAT_DS  computes running statistics of a ds
%
%  outputs an histogram (200 bins), mean and std
%
%  first input:   a ds
%  second input:  a double array (the same as histout, zeroed at beginning)
%  third input:   a double array of 200 (the same as histx)
%  fourth and fifth:   mean and standard deviation (m,s);
%                        s must be put = 0 at beginning
%
%  keys:
%
%   'single'   single chunk
%   'total'    followed by a double array "buff" that must be
%                also the first output argument
%   'ar'       autoregressive, followed by the tau (measured in units of chunks)
%
%   'nbin'     followed by the number of bins
%   'limit'    followed by the limits of the histogram
%   'span'     the percentage span relatively to the first hist (default = 2)
%   'onlylast' shows only the last histogram

% Version 1.0 - July 1998
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1998  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

d=varargin{1};
histout=varargin{2};
histx=varargin{3};
m=varargin{4};
s=varargin{5};

ichist=0;
tau=1;
nbin=200;
span=1;
onlyl=0;

for i = 5:length(varargin)
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
   case 'nbin'
      nbin=varargin{i+1};
   case 'limit'
      x1=varargin{i+1};
      x2=varargin{i+2};
      dx=(x2-x1)/nbin;
      histx=x1+(0:199)*dx;
      s=1e-30;
   case 'span'
      span=varargin{i+1};
   case 'onlylast'
      onlyl=1;
   end
end

kds=d.lcw;

if kds == d.nc1
   y=d.y1(1:d.len);
else
   y=d.y2;
end

if kds == 1
   h0scra = figure('Color',[0.8 0.8 0.8], ...
      'Name','gd Statistics',...
	   'Position',[232 288 560 420]);
   h1scra = axes('Parent',h0scra, ...
	   'Box','on', ...
	   'CameraUpVector',[0 1 0], ...
	   'Color',[1 1 1], ...
	   'XColor',[0 0 0], ...
	   'YColor',[0 0 0], ...
      'ZColor',[0 0 0]);
   histout=zeros(1,nbin);
end

m1=mean(y);
s1=std(y);

switch ichist
case 0
   m1=m;s=s1;
   mstr=sprintf('%d',m);
   sstr=sprintf('%d',s);
   disp(['  mean = ',mstr,', st.dev. = ',sstr]);
   [yfig,histx]=hist(y,nbin);
   [histx,Yfig]=tostairs(histx,yfig);
   tcol=rotcol(kds);
   if onlyl == 0
      h2scra = line('Parent',gca,'Color',tcol,'XData',Xfig,'YData',Yfig);
   else
      plot(Xfig,Yfig);
   end
   zoom on; grid on;
   m=m1;s=s1;
   histout=yfig;
case 1
   if s == 0
      xmin=min(y);xmax=max(y);
      xmean=(xmax+xmin)/2;xspan=(xmax-xmin)/2;
      histx=linspace(xmean-span*xspan,xmean+span*xspan,nbin);
   end
   yfig=hist(y,histx);
   yfig=yfig+histout;
   histout=yfig;
   [Xfig,Yfig]=tostairs(histx,histout);
   tcol=rotcol(kds);
   if onlyl == 0
      h2scra = line('Parent',gca,'Color',tcol,'XData',Xfig,'YData',Yfig);
   else
      plot(Xfig,Yfig);
   end
   zoom on; grid on;
   m=(m*(kds-1)+m1)/kds;
   s=(s*(kds-1)+s1)/kds;
   mstr=sprintf('%d',m);
   sstr=sprintf('%d',s);
   disp(['  mean = ',mstr,', st.dev. = ',sstr]);
case 2
   if s == 0
      xmin=min(y);xmax=max(y);
      xmean=(xmax+xmin)/2;xspan=(xmax-xmin)/2;
      histx=linspace(xmean-span*xspan,xmean+span*xspan,nbin);
   end
   yfig=hist(y,histx);
   yfig=((1-w)/(1-w^kds))*yfig+w*histout;
   histout=yfig;
   [Xfig,Yfig]=tostairs(histx,histout);
   tcol=rotcol(kds);
   if onlyl == 0
      h2scra = line('Parent',gca,'Color',tcol,'XData',Xfig,'YData',Yfig);
   else
      plot(Xfig,Yfig);
   end
   zoom on; grid on;
   m=(m*w+m1*(1-w));
   s=(s*w+s1*(1-w));
   mstr=sprintf('%d',m);
   sstr=sprintf('%d',s);
   disp(['  mean = ',mstr,', st.dev. = ',sstr]);
end
