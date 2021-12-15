function [v,dt,t0,r_struct]=fmnl_getch(r_struct,chs)
%FMNL_GETCH   gets one channel data for the next frame
%
%      [v,dt,t0]=fmnl_getch(r_struct,chs)
%
%      chs    the name of the channel
%
%      v      vector with the data
%      dt     sampling time
%      t0     gps time

% Version 1.0 - October 1999
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1999  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

fst_typ=0;
frstat=0;
%pos=ftell(fid)

fid=r_struct.cont.fid;
struct_num=r_struct.struct_num;

while 1
   fst=fmnl_read_struct(fid,struct_num);
   
   if fst.len <= 0
      disp('Error: structure length = 0');
      disp(fst);
      fclose(fid);
      r_struct=fmnl_reopen(r_struct);r_struct.cont
      fid=r_struct.cont.fid;
      %break;
   end
   
   fst_typ=fst.classtype;
   
   if fst_typ == struct_num(1)
      t0=fst.gps_s+fst.gps_n*1e-9;
      verb=check_verbose(r_struct,1);
      if verb > 0
         fprintf(' --> Frame %d  - t: %s \n',fst.frame,mjd2s(gps2mjd(t0)));
      end
      frstat=1;
   end
   
   if frstat == 1
   	if fst_typ == struct_num(2)
      	if strcmp(fst.name,chs)
         	dt=1/fst.samprate;
            frstat=2;
         end
      end
   end
   
   if frstat == 2
      if fst_typ == struct_num(12)
         v=fst.data;
         return
      end
   end
   
   if fst_typ == struct_num(15)
      fclose(fid);
      r_struct=fmnl_reopen(r_struct);
      if r_struct.cont.eofs == 1
         break
      else
         fid=r_struct.cont.fid;
      end
 	end
end
