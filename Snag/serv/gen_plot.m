function ic=gen_plot(gin,comstr)
% gen_plot  chooses lin or log plot depending on the values
%
%   ic=gen_plot(gin,comstr)
%
%  gin     input gd
%  comstr  e.g. 'r.' or similar; default nothing

% Version 2.0 - March 2011
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

if ~exist('comstr','var')
    comstr='';
else
    comstr=[',''' comstr ''''];
end

ma=max(gin);
mi=min(gin);

if ma/mi > 10
    figure
    eval(['semilogy(gin' comstr  ');']);
else
    figure
    eval(['plot(gin' comstr ');']);
end

grid on