function [ff_struct,varargout]=ffilt_open_ds(din,ff_struct)
%FILT_OPEN_DS   opens ds for frequency domain adaptive filtering output
%
%      [varargout,ff_struct]=ffilt_open_ds(din,ff_struct)
%
%     din           input ds
%     ff_struct     frequency filter structure
%
%     varargout     output ds (one or more)

% Version 1.0 - May 1999
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1999  Sergio Frasca - sergio.frasca@roma1.infn.it

nout=nargout-1;
if nout == 0
   return
end

n=min(nout,ff_struct.n);

if n == 0
   varargout{1}=din;
   return
end

ff_struct.lfft=len_ds(din);
ff_struct.w=exp(-1/ff_struct.tau);
ff_struct.wnorm=1;
lfft0=ff_struct.lfft;
dt0=dt_ds(din);
ff_struct.stau=ff_struct.tau*lfft0*dt0;
ff_struct.pfy=ones(lfft0,1);

for i = 1:n
   lfft=lfft0/ff_struct.sfilt(i).rlfft;
   dt=dt0*lfft0/lfft;
%   typ=ff_struct.sfilt(i).type;
   capt=ff_struct.sfilt(i).capt;
   dout(i)=ds(lfft);
%   varargout{i}=edit_ds(dout(i),'dt',dt,'type',typ,'capt',capt);
   varargout{i}=edit_ds(dout(i),'dt',dt,'capt',capt);
end
