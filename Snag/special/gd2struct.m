function s=gd2struct(g)
% GD2STRUCT  creates a structure from a gd

s.type=type_gd(g);
s.y=y_gd(g);
s.ini=ini_gd(g);
s.n=n_gd(g);
s.dx=dx_gd(g);
s.capt=capt_gd(g);
s.cont=cont_gd(g);

if s.type == 2
    s.x=x_gd(g);
end

disp('unc and uncx not given')