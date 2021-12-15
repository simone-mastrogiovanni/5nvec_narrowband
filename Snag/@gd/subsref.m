function gout=subsref(gin,S)
% SUBSREF  selects subparts of gds
%  
%     gout=cin(i1:i2)
% 

% Version 2.0 - August 2006
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

ii=S.subs{1};

if length(gin) > 1
    disp('gd array : no subsection !')
    gout=gin(ii);
    return
end

gout=gin;

gout.y=gin.y(ii);
gout.n=length(gout.y);
gout.capt=['subsection of ' gin.capt];

x=x_gd(gin);

if gout.type == 1
    gout.ini=x(ii(1));
else
    gout.x=x(ii);
end