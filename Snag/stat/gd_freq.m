function [f env]=gd_freq(g1,nomean)
% GD_FREQ  signal frequency evaluation
%
%     [f env]=gd_freq(g1,nomean)
%
%  g1      input gd
%  nomean  no-mean flag (default 1)
%
%  f       evaluated frequency
%  env     envelope

% Version 2.0 - April 2008
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

if ~exist('nomean','var')
    nomean=1;
end
if nomean == 1
    g1=g1-mean(g1);
end

hil=gd_hilb(g1);
en=abs(hil);
phi=gd_atan3(hil);
t=x_gd(phi);
phi=y_gd(phi);
n=length(t);

phi=diff(phi);
dt=diff(t);
f=g1;
f=edit_gd(f,'y',phi./dt,'n',n-1,'capt',['frequency of ' capt_gd(g1)]);
env=edit_gd(en,'capt',['envelope of ' capt_gd(g1)]);