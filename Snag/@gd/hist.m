function varargout=hist(varargin)
% hist  gd overloading of hist
%
% Version 2.0 - November 2010
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

gin=varargin{1};
y=gin.y;

switch nargout
    case 0
        hist(y,varargin{2:nargin});
    case 1
        a1=hist(y,varargin{2:nargin});
        varargout{1}=a1;
    case 2
        [a1 a2]=hist(y,varargin{2:nargin});
        varargout{1}=a1;
        varargout{2}=a2;
    case 3
        [a1 a2 a3]=hist(y,varargin{2:nargin});
        varargout{1}=a1;
        varargout{2}=a2;
        varargout{3}=a3;
end
