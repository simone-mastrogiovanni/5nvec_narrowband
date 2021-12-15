function handl=cplot(g1,varargin)
% PLOT  plot for gds
%  
%     handl=plot(g1,varargin)
%
% Use similar to plot, but one or more gds can be directly plotted
%    default grid on
%
% Examples :   plot(gd1*10,'x',gd2,'.')

% Version 2.0 - Octobert 2010
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universit� "Sapienza" - Rome

str='handl=plot(g1.y'; 

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
grid on