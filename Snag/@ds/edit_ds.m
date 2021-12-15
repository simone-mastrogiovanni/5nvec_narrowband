function d=edit_ds(varargin)
%DS/EDIT_DS edits parameters of a ds
%
% use always with ; and the output ds
% the first input argument must be the ds to edit
%
% keys (even arguments):
%  'tini1'
%  'tini2'
%  'dt'
%  'len'
%  'y1'
%  'y2'
%  'type'
%  'nc1'
%  'nc2'
%  'lcw'
%  'lcr'
%  'capt'
%  'verb'

% Version 1.0 - July 1998
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

d=varargin{1};

for i = 2:2:length(varargin)
   strin=varargin{i};
   switch strin
      case 'tini1'
         d.tini1=varargin{i+1};
      case 'tini2'
         d.tini2=varargin{i+1};
      case 'dt'
         d.dt=varargin{i+1};
      case 'len'
         d.len=varargin{i+1};
      case 'y1'
         d.y1=varargin{i+1};
      case 'y2'
         d.y2=varargin{i+1}; 
      case 'type'
         d.type=varargin{i+1};
      case 'nc1'
         d.nc1=varargin{i+1};
      case 'nc2'
         d.nc2=varargin{i+1};
      case 'lcw'
         d.lcw=varargin{i+1};
      case 'lcr'
         d.lcr=varargin{i+1};
      case 'capt'
         d.capt=varargin{i+1};
      case 'verb'
         d.verb=varargin{i+1};
   end
end

display_ds(d);