function g=gd_fun_sample(strfun,t)
%FUN_SAMPLE creates a type 2 gd with the samples of a function
%
%  strfun   string with the function (in the form, for example, 'sin(4*t)'
%  t        sampling times

% Version 2.0 - September 2005
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

t=sort(t);

str=['g=' strfun ';']
eval(str);

g=gd(g);
g=edit_gd(g,'type',2,'x',t,'capt',strfun);