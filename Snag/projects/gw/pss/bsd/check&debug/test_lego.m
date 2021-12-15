function outtest=test_lego(addr,ant,runame,fr0,band)
% checks lego procedures
%
%   fr0        sinusoid frequency
%   band       requested band
%   base_str   e.g. "'I:','ligol','O2'"

% Version 2.0 - December 2018
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by O.J.Piccinni and S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

[tab, tabpar]=read_tab_bsd(addr,ant,runame);

modstr.typ='sinsig';
modstr.fr=fr0;
modstr.ph=0;
modstr.amp=1;
modstr.t00=tabpar.t_ini;

% [bsd_out,BSD_tab_out,out]=bsd_lego(addr,ant,runame,1,band,1,[],modstr);
[bsd_out,BSD_tab_out,out]=bsd_lego(addr,ant,runame,1,band,1,modstr);

outtest.bandin=band;
outtest.fr0=fr0;
outtest.bsd=bsd_out;
outtest.tab_out=BSD_tab_out;
outtest.out=out;
outtest.worm=bsd_worm(bsd_out,fr0,1)