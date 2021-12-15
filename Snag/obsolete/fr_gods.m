function [d,r,r_struct]=fr_gods(d,r,g,ntype,file,chs,chn,fid,reclen,r_struct,sp)
%FR_GODS  ds client
%
%        [d,r,r_struct]=fr_gods(d,r,g,ntype,file,chs,chn,fid,reclen)
%
%        d       the ds
%        r       the service rg or service double array (for simulation)
%
%        g          the input gd (for matlab files)
%        ntype      type of data format
%        file       file with path
%        chs        channel name
%        chn        channel number (0 if not available)
%        fid        file handle
%        reclen     length of R87 record
%        r_struct   read-write structure
%        sp         array containg the spectrum (for simulation)

% Version 1.0 - March 1999
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

%disp('in fr_gods');r_struct.cont
%display_ds(d);

switch ntype
case 1
   r_struct.select={chs};
   [d,r]=snf2ds(d,r,fid,r_struct);
case 2
   [d,r,r_struct]=fr2ds(d,r,r_struct,chs);
case 3
   [d,r,r_struct]=sds2ds(d,r,r_struct,chs);
case 4
   [d,r]=r872ds(d,r,file,chn,fid,reclen);
      %disp('y1');
      a1=y1_ds(d);
      %size(a1)
      %disp('y2');
      a2=y2_ds(d);
      %size(a2)
case 5
   d=gd2ds(d,g);
case 100
   [d,r]=noise_ds(d,r,'spect',sp);
   
   a1=y1_ds(d);
   a2=y2_ds(d);
   
end

r_struct.verbose=1;
