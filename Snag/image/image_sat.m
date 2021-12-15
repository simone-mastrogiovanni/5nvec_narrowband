function gout=image_sat(gin,min1,max1)
%IMAGE_SAT  image amplitude saturation
%
%  min1,max1   minimum,maximum saturation levels

% Version 2.0 - September 2005
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

[i,j]=find(gin<min1);
for k = 1:length(i)
    gin(i(k),j(k))=min1;
end

[i,j]=find(gin>max1);
for k = 1:length(i)
    gin(i(k),j(k))=max1;
end

gout=gin;