function [ff_struct,varargout]=ffilt_go_ds(din,ff_struct,varargin)
%FFILT_GO_DS   frequency filtering of a type 1 ds
%
%      [ff_struct,varargout]=ffilt_go_ds(din,ff_struct,varargin)
%
% It needs the ffilt_open_ds; the ff_struct can be set up by set_ff_struct or
% by loading ff_struct in a precharged m-file (in snag/analysis/filters, by
% means of run_m_file).

% Version 1.0 - May 1999
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1999  Sergio Frasca - sergio.frasca@roma1.infn.it

if ff_struct.n == 0
   varargout{1}=din;
   return;
end

for i = 1:length(varargin)
   varargout{i}=varargin{i};
   varargout{i}.nc1=din.nc1;
   varargout{i}.nc2=din.nc2;
   varargout{i}.lcw=din.lcw;
   varargout{i}.tini1=din.tini1-(din.len/4)*din.dt;
   varargout{i}.tini2=din.tini2-(din.len/4)*din.dt;
   varargout{i}.y2=varargin{i}.y1(1:d.len);
end

len=din.len;
len2=len/2;
len4=len/4;
len32=3*(len/2);

y1=y1_ds(din);
y2=y2_ds(din);
y=zeros(len32,1);
y(1:len2)=y2(len2+1:len);
y(len2+1:len32)=y1;
   
y1=fft(y(1:len));
ay=1./abs(y1);

pfy=ff_struct.pfy;

switch ff_struct.pfilt
case 'whitening'
   ff_struct.wnorm=ff_struct.wnorm*ff_struct.w+1;
   pfy=pfy*ff_struct.w+ay;
   ff_struct.pfy=pfy;
   pfy=pfy./ff_struct.wnorm;
case 'wiener'
   ff_struct.wnorm=ff_struct.wnorm*ff_struct.w+1;
   pfy=pfy*ff_struct.w+ay.*ay;
   ff_struct.pfy=pfy;
   pfy=pfy./ff_struct.wnorm;
end

y1=y1.*pfy;
y1=ifft(y1);
varargout{1}.y1(1:len2)=y1(len4+1:3*len4);

y2=fft(y(len2+1:len32));
y2=y2.*pfy;
y2=ifft(y2);
varargout{1}.y1(len2+1:len)=y2(len4+1:3*len4);
