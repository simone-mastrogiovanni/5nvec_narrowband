function mp=fmnl_getchmp(file,chss,ndata,fr1,nfr)
%FMNL_GETCHMP   gets multi channel data
%
%      mp=fmnl_getchmp(file,chss,ndata,fr1,nfr)
%
%      file   ...
%      chss   a cell array containing the needed channels
%      ndata  array containing the number of data per frame of each channel
%      fr1    initial frame (relative to beginning)
%      nfr    number of frames
%
% mp structure (multiplot):
%
%     mp.nch
%     mp.ch(i).name
%             .n
%             .x
%             .y
%             .unitx
%             .unity

% Version 1.0 - October 1999
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1999  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome


struct_num=fmnl_dict(file)

mp.nch=length(chss);

for i = 1:length(chss)
   mp.ch(i).name=chss{i};
   mp.ch(i).n=0;
   mp.ch(i).x=zeros(ndata(i)*nfr,1);
   mp.ch(i).y=mp.ch(i).x;
end

r_struct=fmnl_open(file,0);
fid=r_struct.cont.fid;

fst_typ=0;
frstat=0;
chname='void';

while fst_typ ~= -4
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
      frstat=frstat+1;
      if frstat == fr1+nfr
      	return
   	end
   end
   
   if frstat >= fr1
      if fst_typ == struct_num(2)
         chname=fst.name;
      end
      if fst_typ == struct_num(12)
         for k = 1:mp.nch
            %if strcmp(mp.ch(k).name,fst.name)
            if strcmp(mp.ch(k).name,chname)
               nd=fst.ndata;
               ii=mp.ch(k).n;
               mp.ch(k).x(ii+1:ii+nd)=(ii+1:ii+nd)*fst.dx;
               mp.ch(k).y(ii+1:ii+nd)=fst.data;
               mp.ch(k).n=mp.ch(k).n+nd;
               mp.ch(k).unitx=fst.unitx;
               mp.ch(k).unity=fst.unity;
            end
         end
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
