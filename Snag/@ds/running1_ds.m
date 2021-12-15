function [y,ind]=running1_ds(varargin)
%RUNNING1_DS   running plot of a ds (of type 0 or 1)
%
%  first argument is the ds
%  second argument is a double array (equal to the output y)
%  third argument is an index (equal to the output ind);
%                  it should be 0 at beginning
%
%   keys :
%
%    'window'   in seconds
%    'delay'    in seconds
%    'lchunk'   length of elementary chunks (in samples): 
%                must be less than the length of the window
%                should be a submultiple of the length of the ds
%    'span'     how much increase the scale at beginning (def=2)

% Version 1.0 - July 1998
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (c) 1998  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

d=varargin{1};
y=varargin{2};
ind=varargin{3};
len=len_ds(d);
dt=d.dt;
y1=y_ds(d);

window=1;
delay=0.5;
lchunk=100;
span=2;
ymin=min(y1);ymax=max(y1);
ymean=(ymin+ymax)/2;yspan=(ymax-ymin)/2;

for i = 4:length(varargin)
   str=varargin{i};
   switch str
   case 'window'
      window=varargin{i+1};
   case 'delay'
      delay=varargin{i+1};
   case 'lchunk'
      lchunk=varargin{i+1};
   case 'span'
      span=varargin{i+1};
   end
end

nch=len/lchunk;
lw=window/dt;
lw=ceil(lw/lchunk)*lchunk;
x=(1:lw)*dt;
size(x);
jjj=0;iii=0;

Ymin=ymean-span*yspan;Ymax=ymean+span*yspan;

if ind > len-lchunk;
   ind=1;
end

for i = 1:nch
   if ind == 0
      y=zeros(1,lw);
      y(1:lchunk)=y1(1:lchunk);
      ind=lchunk+1;
      plot(x,y);
      %Axes('YLim',[Ymin Ymax]);
      jjj=jjj+1
   else
      line('Parent',gca,'Color','w','XData',x,'YData',y);
      y(lchunk+1:lw)=y(1:lw-lchunk);
      y(1:lchunk)=y1(ind:ind+lchunk-1);
      line('Parent',gca,'Color','b','XData',x,'YData',y);
      ind=ind+lchunk;
      iii=iii+1
   end
   %grid on;
   pause(delay)
end

