function handl=plot3(g1,varargin)
% PLOT  plot3 for complex gds
%  
%     handl=plot3(g1,varargin)
%
% Use similar to plot, but one or more gds can be directly plotted
%    default grid on
%
% Examples :   plot3(gd1*10,'x',gd2,'.')

% Version 2.0 - November 2009
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

str='handl=plot3(real(g1.y),imag(g1.y),x_gd(g1)'; 

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