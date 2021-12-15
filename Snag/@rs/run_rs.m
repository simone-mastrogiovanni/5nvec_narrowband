function [r,g]=run_rs(r,nstep,varargin)
%RUN_RS  "runs" an rs, producing a gd output
%           call ->   [r,g]=run_rs(varargin)
% the first argument is the rs, that must be also the first output argument,
% the second input argument is the number of steps of the run
% the secont output argument is a gd
%
%         r        an rs
%         nstep    number of steps
%
%  keys :
%
%  'input'   followed by an input array; exclude the wn, that can be switched
%             on by a subsequent 'wn'
%  'wn'      followed by the amplitude; feeds the rs with white noise (default 
%             with amplitude 1, if not set input)
%  'real'    real output (default)
%  'complex' complex output

% Version 1.0 - July 1998
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1998  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

g=gd(nstep);
gy=zeros(1,nstep);

icinp=0;
icwn=1;
wnamp=1;
icreal=1;

for i = 1:length(varargin)
   str=varargin{i};
   switch str
   case 'input'
      icinp=1;
      icwn=0;
      yin=varargin{i+1};
   case 'wn'
      icwn=1;
      wnamp=varargin{i+1};
   case 'real'
      icreal=1;
   case 'complex'
      icreal=0;
   end
end

inp=zeros(1,nstep);

if icwn == 1
   inp=inp+wnamp*randn(1,nstep);
end
if icinp == 1
   inp=inp+yin;
end

for i = 1:nstep
   rr=r.st.*r.w+inp(i)*r.amp.*sqrt(1-abs(r.w).^2);
   r.st=rr;
   if icreal == 1
      gy(i)=sum(real(r.st)*sqrt(2));
   else
      gy(i)=sum(r.st);
   end
end

str=sprintf('%u resonances',r.n);
g=edit_gd(g,'y',gy,'dx',r.dt,'capt',str);
