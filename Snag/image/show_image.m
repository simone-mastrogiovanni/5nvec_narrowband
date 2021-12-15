function show_image(A,parvis,parim)
%SHOW_IMAGE
%
%  A       matrix or gd
%
%  parvis  visualization parameters
%     (1)  colormap 0 -> gray; 
%          col comando colormap_sel si puo' cambiare interattivvamente
%     (2)  autoscale 1 -> yes
%
%  parim   image parameters

% Version 2.0 - September 2005
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

if ~isnumeric(A)
    A=y_gd2(A);
end

colmap='gray';

switch parvis(1)
    case 1
    case 2
    case 3
end

switch parvis(2)
    case 1 
        minsc=min(A(:));
        maxsc=max(A(:));
        A=64*(A-minsc)/(maxsc-minsc);
    case 2
    case 3
end

figure,image(A)
colormap(colmap)