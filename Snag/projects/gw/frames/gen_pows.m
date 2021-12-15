function gen_pows
%GEN_POWS   power spectrum for frames, matlab and R87 files
%
%        gen_pows
%

% Version 1.0 - March 1999
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1999  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

[ntype,file]=db_fildatsel;

[chn,chs,dt,dlen,sp]=db_selch(ntype,file);

answ=inputdlg({'Length of an fft ?' 'Number of cycles ?'},...
   'Base spectral parameters',1,...
   {'1024' '100'});
dslen=eval(answ{1});
cycles=eval(answ{2});

rglen=2*max(dslen,dlen);

[d,r,fid,reclen,g,r_struct]=db_open(ntype,file,chs,dslen,2,rglen,dt,sp);

frmax=1/(2*dt);

for i =1:cycles
   [d,r,r_struct]=db_gods(d,r,g,ntype,file,chs,chn,fid,reclen,r_struct,sp);
   [powsout,answ]=ipows_ds(d,powsout,answ,'interact','limit',11,frmax);
   pause(2);
end
