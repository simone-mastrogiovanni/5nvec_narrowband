function [file,ch]=snf_pows
%R87_POWS   running power spectrum for R87 files
%
%        [file,adc]=snf_pows
%
%        file    selected file
%        adc     selected adc

% Version 1.0 - May 1999
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1999  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

snag_local_symbols;

file=selfile('D:\SF_Prog\MatLab\Prova');

answ=inputdlg({'Channel' 'Length of an fft ?' 'Number of cycles ?'},...
   'Base spectral parameters',1,...
   {'201' '8192' '1000'});
ch=answ{1};
l=eval(answ{2});
cycles=eval(answ{3});
powsout=1:10;

clear r_struct;
r_struct.file=file;
r_struct.select=cell(1,1);
r_struct.select{1}=ch;
[fid,r_struct]=open_snf_read(r_struct);
reclen=2*r_struct.reclen;
lr=r_struct.mds.len(r_struct.selk(1))
%[fid,reclen,initime,samptim]=open_r87(file);
%[header,data]=read_r87_ch(fid,reclen,ch);
%lr=2*max(l,length(data));
[d,r]=inifr2ds(l,1,lr);
frmax=1/(2*r_struct.mds.dt(r_struct.selk(1)));
%frmax=1/(2*header.st);

for i =1:cycles
   [d,r]=snf2ds(d,r,fid,r_struct);
   [powsout,answ]=ipows_ds(d,powsout,answ,'interact','limit',11,frmax);
   pause(1);
end
