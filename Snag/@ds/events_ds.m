function [d,ngen]=events_ds(d,dslen,varargin)
% EVENT_DS  
%
% This is a ds server
% Typical call:
%    [d,ngen,max]=events_ds(d,dslen,varargin)
%
% keys:
%
%   input:
%   d            ds
%   dslen        ds lenght
%   eve          Number of events to be generated in one try
%   prob         Probability to generate one event in one try
%   ampl         amplitudes of the pulses
%   ngen         nember of generated pulses
%
%   output:
%   d            ds 
%   ngen         number of generated pulses
%
% ----------------------------------------------------
% Laura Brocco   laura.brocco@roma1.infn.it  
%                6/6/2003
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ini=0;
for i = 1:2:length(varargin)
    str=varargin{i};
    switch str
       case 'eve'
           eve=varargin{i+1};
       case 'prob'
           p=varargin{i+1};
       case 'ampl'
           ampl=varargin{i+1};
       case 'ngen'
           ngen=varargin{i+1};
    end
end


pp=p*eve;
if(ini==0)
    events=zeros(dslen,1);
end
ini=1;

for k=1:dslen
    x=rand(1);
    if(x<pp)
        ngen=ngen+1;
        events(k)=ampl;
    end
end
d.capt='pulse generation';
d.y1=events;

   
