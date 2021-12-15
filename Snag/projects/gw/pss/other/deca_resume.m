function deca_resume(ant,decadir,minhole,chn,freqs)
% DECA_RESUME  checks the deca sds structures, with resumé
%
%   ant       antenna prefix (as 'VIR_')
%   decadir   directory containing the decades
%   minhole   basic length, typically 4096 or 4000)
%   chn       channel number (normally 1)
%   freqs     initial frequencies of the band
%
%  e.g.  deca_resume('VIR_','Y:\pss\virgo\sd\sds\VSR1-2\',2*4096,1,[20 50 100 300 700])

% Version 2.0 - September 2008
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

disp(['directory ' decadir])
eval(['cd ' decadir])

appo=dir('deca*');
ndir=0;
for i = 1:length(appo)
    if appo(i).isdir
        ndir=ndir+1;
        dirs{ndir}=appo(i).name;
    end
end

for i = 1:ndir
    direc=dirs{i}
    eval(['cd ' direc])
    files=dir([ant '*']);
    fil=files(1).name;
    sds_resume(['resume_' direc],minhole,fil,chn,freqs);
    eval(['cd ' decadir])
end
