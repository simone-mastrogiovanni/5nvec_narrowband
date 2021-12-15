function [y,ind]=running_ds(d,y,ind,varargin)
%RUNNING_DS   running plot of a ds (of type 0 or 1)
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

% Version 1.0 - July 1998
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (c) 1998  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

len=len_ds(d);
dt=d.dt;
y1=y1_ds(d);

window=1;
delay=0.5;
lchunk=100;

for i = 1:length(varargin)
   str=varargin{i};
   switch str
   case 'window'
      window=varargin{i+1};
   case 'delay'
      delay=varargin{i+1};
   case 'lchunk'
      lchunk=varargin{i+1};
   end
end
% 'Position',[232 288 560 420]);
if ind == 0
   h0scra = figure('Color',[0.8 0.8 0.8], ...
   'Position',[232 288 560 420], ...
   'Name','Running ds');
	h1axgdpl = axes('Parent',h0scra, ...
	'Box','on', ...
	'CameraUpVector',[0 1 0], ...
	'Color',[1 1 1], ...
	'XColor',[0 0 0], ...
	'YColor',[0 0 0], ...
   'ZColor',[0 0 0]);

end

nch=len/lchunk;
lw=window/dt;
lw=ceil(lw/lchunk)*lchunk;
x=(1:lw)*dt;

if ind > len-lchunk;
   ind=1;
end

for i = 1:nch
   if ind == 0
      y=zeros(1,lw);
      y(1:lchunk)=y1(lchunk:-1:1);
      ind=lchunk+1;
   else
      y(lchunk+1:lw)=y(1:lw-lchunk);
      y(1:lchunk)=y1(ind+lchunk-1:-1:ind);
      ind=ind+lchunk;
   end
   plot(x,y);
   grid on;
   pause(delay)
end

