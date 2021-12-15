function mp=gd2mp(g,mpin,kp)
%GD2MP  attaches a gd to an mp structure
%
%  g      input gd
%  mpin   mp structure
%  kp     channel number of mp
%
%  mp     output mp structure

mp=mpin;
mp.ch(kp).n=n_gd(g);
mp.ch(kp).y=y_gd(g);
mp.ch(kp).x=(1:n_gd(g))*dx_gd(g)+ini_gd(g);
mp.ch(kp).n=n_gd(g);
mp.ch(kp).name='from gd';
mp.ch(kp).unitx='x';
mp.ch(kp).unity='y';