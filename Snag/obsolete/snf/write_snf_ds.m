function w_struct=write_snf_ds(fid,w_struct,varargin)
%WRITE_SNF_DS  write function for ds and mds
%
%     w_struct=write_snf_ds(fid,w_struct,varargin)
%
%      w_struct     writing structure
%      varargin     contains the dss to be written
%
% Used in ds loops, after the [fid,w_struct]=open_snf_write(w_struct,varargin) .
%
% This writes a ds or mds file record.

% Version 1.0 - May 1999
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (c) 1999  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

w_struct.nrec=w_struct.nrec+1;
switch w_struct.obj
case 'ds'
   count=fwrite(fid,w_struct.nrec,'int32');
   count=fwrite(fid,w_struct.trec,'float64');
   count=fwrite(fid,y_ds(varargin(1)),w_struct.wform);
case 'mds'
   w_struct.mds.headi.val(1)=w_struct.nrec;
   w_struct.mds.headd.val(1)=w_struct.trec;
   count=fwrite(fid,w_struct.mds.headi.val,'int32');
   count=fwrite(fid,w_struct.mds.headd.val,'float64');
   for i = 1:w_struct.mds.nch
      y=y_ds(varargin{i});
      count=fwrite(fid,w_struct.mds.dt(i),'float64');
      count=fwrite(fid,y,w_struct.mds.wform{i});
   end
end

w_struct.trec=w_struct.trec+w_struct.dtrec/86400;
