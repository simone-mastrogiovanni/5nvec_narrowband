function ff_struct=set_ff_struct(varargin)
%SET_FF_STRUCT   initializes a ff_struct
%
%     ff_struct=set_ff_struct(varargin)
%
%  keys:
%
%     'file'   set from file; other keys apply afterward
%
%      ff_struct.
%   0           .n            number of bands
%   1           .lfft         length of the principal fft
%                             (must be set equal to the ds chunk length)
%   0           .pfilt        principal filter type 
%                             ('nothing','whitening','wiener',...)
%   210         .pfy          array containing the principal filter 
%                             (adaptively variable)
%   0           .tau          adaptivity time (in number of periodograms)
%   1           .stau         adaptivity time (in seconds)
%   1           .w            AR coefficient
%   2           .wnorm        normalization variable
%   0           .capt         general caption
%               .sfilt(k)     sub-filters structures
%   0           .sfilt.rlfft  sub-filter ratio lfft primary/secondary
%   0           .sfilt.shift  sub-band shift
%   0           .sfilt.mode   sub-filter type
%                             ('nothing','gauss','lorentz',...)
%   0           .sfilt.par(k) sub-filter parameters
% ! 0           .sfilt.type   ds type (1 or 2)  !  da togliere
%   0           .sfilt.capt   caption
%   10          .sfilt.sfy    array containing the sub-filter
%
%   0    -> set by user
%   1    -> set by ffilt_open_ds
%   2    -> set by ffilt_go

% Version 1.0 - May 1999
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1999  Sergio Frasca - sergio.frasca@roma1.infn.it

ff_struct.n=1;
ff_struct.w=0.95;
snag_local_symbols;

for i = length(varargin)
   str=varargin{i};
   switch str
   case 'file'
      [filTorun,dirTofile]= uigetfile([filtdir '*.m'],'File to run');
      run_m_file;
   end
end

for i = length(varargin)
   str=varargin{i};
   switch str

   end
end

