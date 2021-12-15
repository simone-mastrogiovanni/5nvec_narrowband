function gout=gd_s2mjd(gin,inimjd)
%gd_s2mjd  converts abscissa from seconds to mjd
% 
%  inimjd   mjd of the first sample; if absent, uses cont.t0

if ~exist('inimjd','var')
    cont=cont_gd(gin);
    inimjd=cont.t0;
end

dx=dx_gd(gin)/86400;

if type_gd(gin) == 1
    gout=edit_gd(gin,'dx',dx,'ini',inimjd);
else
    x=x_gd(gin);
    x=x/86400;
    gout=edit_gd(gin,'dx',dx,'ini',inimjd,'x',x);
end