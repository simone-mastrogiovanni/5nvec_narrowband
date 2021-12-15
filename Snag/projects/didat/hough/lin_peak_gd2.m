function g=lin_peak_gd2(nlin,p,q,snr,thresh,nx,ny,inix,dx,iniy,dy)
%LIN_PEAK_GD2 peak map with a straight line
%
%  g = lin_peak_gd2(nlin,p,q,snr,thresh,nx,ny)
%
%      nlin     number of lines
%      p,q      straight line parameters
%     thresh    threshold
%      snr      signal-to-noise ratio (power)
%     nx,ny     map dimensions
%
%       g       output peak map
%
%         y = p*x + q

% Version 1.0 - May 2002
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1999-2002  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

g=(randn(nx,ny).^2+randn(nx,ny).^2)/2;

for i = 1:nx
    x=inix+(i-1)*dx;
    for k = 1:nlin
        y=p(k)*x+q(k);
        j=round((y-iniy)/dy)+1;
        if j > 0 & j <= ny
            g(i,j)=((randn(1,1)+sqrt(2*snr)).^2+randn(1,1).^2)/2;
        end
    end
end

g=gd2(g);

g=peak_gd2(g,thresh);
g=binary_gd2(g);

g=edit_gd2(g,'n',nx*ny,'m',ny,'capt','Peak map for a line',...
    'ini',inix,'dx',dx,'ini2',iniy,'dx2',dy);

