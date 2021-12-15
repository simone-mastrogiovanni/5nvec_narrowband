function candstr=psc_rheader(fid)
%PSS_RHEADER  reads the header of candidate file
%
%  fid      file identifier
%  candstr  candidate structure

% Version 2.0 - October 2005
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

candstr.prot=fread(fid,1,'int32');
c=fread(fid,128,'char');
candstr.capt=blank_trim(char(c'));
candstr.initim=fread(fid,1,'float64');
candstr.st=fread(fid,1,'float64');
candstr.fftlen=fread(fid,1,'int64');
candstr.inifr=fread(fid,1,'int64');
candstr.dlam=fread(fid,1,'float32');
candstr.dbet=fread(fid,1,'float32');
candstr.dsd1=fread(fid,1,'float32');
candstr.dcr=fread(fid,1,'float32');
candstr.dmh=fread(fid,1,'float32');
candstr.dh=fread(fid,1,'float32');

candstr.nsd1=0;

if candstr.prot > 2
    candstr.nsd1=fread(fid,1,'int32');
    dummy=fread(fid,16,'int32');
end
