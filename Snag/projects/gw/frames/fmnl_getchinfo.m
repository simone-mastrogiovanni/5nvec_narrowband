function [chss,ndata,fsamp,t0]=fmnl_getchinfo(file)
%FMNL_GETCHINFO   gets the channel names in a file, from the first frame
%
%      [chs,ndata,fsamp,t0]=fmnl_getchinfo(file)
%
%      file   ...
%      chs    cell array with the names of the channels
%      ndata  number of data per frame for a given channel
%      fsamp  sampling frequency
%      t0     gps time (seconds)

% Version 1.0 - October 1999
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1999  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

struct_num=fmnl_dict(file);

r_struct=fmnl_open(file,1);
fid=r_struct.cont.fid;

fst_typ=0;
frstat=0;
adcon=0;
ii=0;

while fst_typ ~= -4
   fst=fmnl_read_struct(fid,struct_num);
   
   if fst.len <= 0
      disp('Error: structure length = 0');
      disp(fst);
      fclose(fid);
      break;
   end
   fst_typ=fst.classtype;
   
   if fst_typ == struct_num(1)
      frstat=frstat+1;
      t0=fst.gps_s+fst.gps_n/10^9;
   end
   
   if frstat == 1
      if fst_typ == struct_num(2)
         ii=ii+1;
         chss{ii}=fst.name;
         fsamp(ii)=fst.samprate;
         adcon=1;
      end
   end
   
   if fst_typ == struct_num(12)
      if adcon == 1
         adcon=0;
         ndata(ii)=fst.ndata;
      end
   end 
  
   if frstat == 2
      fclose(fid);
      return
   end
end
