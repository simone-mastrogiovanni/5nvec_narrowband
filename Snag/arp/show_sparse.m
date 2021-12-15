function show_sparse(varargin)
%SHOW_SPARSE  shows sparse matrices or sparse gd2
%
%    show_sparse(varargin)
%
%  odd arguments   sparse matrix
%  even arguments  symbol (like '+', 'o',...)

% Version 2.0 - July 2004
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

n=length(varargin);
figure

for i = 1:2:n
    A=varargin{i};
    if isobject(A)
        A=y_gd2(A);
    end
    sym=varargin{i+1};
    [x,y]=find(A);
    plot(x,y,sym)
    hold on
end

zoom on, grid on