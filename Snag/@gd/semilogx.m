function handl=semilogx(g1,varargin)
% SEMILOGX  log x plot for gds
%  
%     handl=semilogx(g1,varargin)
%
% Use similar to plot, but one or more gds can be directly plotted
%
% Examples :   semilogx(gd1*10,'x',gd2,'.')

% Version 2.0 - August 2006
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

str='handl=semilogx(x_gd(g1),g1.y'; 

for i = 1:nargin-1
    if isa(varargin{i},'gd')
        ci=sprintf('%d',i);
        str=[str ',x_gd(varargin{' ci '}),varargin{' ci '}.y'];
    else
        str=[str ',''' varargin{i} ''''];
    end
end

str=[str ');'];
eval(str);