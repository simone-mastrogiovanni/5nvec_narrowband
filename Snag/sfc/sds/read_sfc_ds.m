function [r_struct,varargout]=read_sfc_ds(fid,r_struct)
%READ_SFC_DS  read function for ds and mds
%fc
%     [r_struct,varargout]=read_sfc_ds(fid,r_struct)
%
%      r_struct      reading structure
%      varargout     contains the output dss
%
% Used in ds loops, after the open_snf_read .
%
% This reads a ds or mds file record.

% Version 2.0 - June 2003
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

switch r_struct.obj
case 'ds'
   r_struct.nrec=1;
   r_struct.trec=fread(fid,1,'float64');
   varargout{1}=fread(fid,r_struct.ds.len,r_struct.wform);
case 'mds'
   r_struct.mds.headi.val=fread(fid,1,'int32');
   r_struct.mds.headd.val=fread(fid,1,'float64');
   r_struct.trec=r_struct.mds.headd.val;
   offset=ftell(fid);
   for i = 1:length(r_struct.selk)
      k=r_struct.selk(i);
      fseek(fid,offset+r_struct.selbias(i),'bof');
      r_struct.mds.dt(k)=fread(fid,1,'float64');
      varargout{i}=fread(fid,r_struct.mds.len(k),r_struct.mds.wform{k});
   end
end

