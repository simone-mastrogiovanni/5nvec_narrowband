function [file,ch]=r87_pows
%R87_POWS   running power spectrum for R87 files
%
%        [file,adc]=r87_pows
%
%        file    selected file
%        adc     selected adc

% Version 1.0 - March 1999
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1999  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

snag_local_symbols;

file=selfile(rogdata);

answ=inputdlg({'Channel' 'Length of an fft ?' 'Number of cycles ?'},...
   'Base spectral parameters',1,...
   {'201' '8192' '1000'});
ch=eval(answ{1});
l=eval(answ{2});
cycles=eval(answ{3});

[fid,reclen,initime,samptim]=open_r87(file);
[header,data]=read_r87_ch(fid,reclen,ch);
lr=2*max(l,length(data));
[d,r]=inifr2ds(l,1,lr);
frmax=1/(2*header.st);

for i =1:cycles
   [d,r]=r872ds(d,r,file,ch,fid,reclen);
   [powsout,answ]=ipows_ds(d,powsout,answ,'interact','limit',11,frmax);
   pause(2);
end
