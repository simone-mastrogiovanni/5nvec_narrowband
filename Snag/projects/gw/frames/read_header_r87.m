function header=read_header_r87(a)
%READ_HEADER_R87  builds the header structure for an R87 record
%
%          header=read_header_r87(a)
%
%        a  the R87 record
%
%           Header structure
%
%     header.len         record length (in I16 words) [=0 -> end of file]
%     header.headlen     header length      "
%     header.recnum      record number
%     header.antenna     gravitational antenna code
%     header.runnum      run number
%     header.type        record type (1 sampled data, 2 physical parameters,
%                        3 experimenters comments, 4 DAGA setup (script)
%     header.len1        length of field 1
%     header.nc1         number of channels of field 1
%     header.len2        length of field 2
%     header.nc2         number of channels of field 2
%     header.len3        length of field 3
%     header.nc3         number of channels of field 3 
%     header.time        time (in MJD)
%     header.st          sampling time (in seconds)
%
%     header.adccode     ADC code
%     header.opflag      operational flag

% Version 1.0 - March 1999
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1999  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

header.len=a(1);
header.headlen=a(2);
header.recnum=a(3);
header.antenna=a(4);
header.runnum=a(5);
header.type=a(6);

header.len1=a(7);
header.nc1=a(8);
header.len2=a(9);
header.nc2=a(10);
header.len3=a(11);
header.nc3=a(12);

initime=zeros(1,6);
for i=1:6
   it(i)=a(12+i);
end
divi=1000;
if it(1) > 1998
   divi=10000;
end

time=datenum(it(1),1,it(2),it(3),it(4),it(5)+it(6)/divi)-678942;
header.time=time;

samptim=(a(19)+a(20)*0.001)*0.001;
header.st=samptim;

header.adccode=a(22);
header.opflag=a(25);
