function [out_hist,D_B]=d_b_rhist(D_B)
%D_B_RHIST   running histogram
%
%             [out_hist,D_B]=d_b_rhist(D_B)
%
%             D_B        a D_B structure
%             out_hist   output histogram

% Version 1.0 - April 1999
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

%---------------------- Preamble ---------------------

ntype=D_B.data.type;
file=D_B.data.file;
chs=D_B.data.chname;
chn=D_B.data.chnumber;
sp=D_B.data.sp;
dt=D_B.data.dt;
dlen=D_B.data.dlen;
frame4par=D_B.data.frame4par;
iter=D_B.proc.iter;

%--------------------- Initial part ------------------

dslen=dlen;
if dslen > 20000
    dslen=20000
end
rglen=2*dlen;
      
typ=1;

[d,r,fid,reclen,g,r_struct]=db_open(ntype,file,chs,dslen,typ,rglen,dt,sp,frame4par);

ginhistds;

m=0;s=0;histout=zeros(1,nbin);histx=1:nbin;

strhist=['[histout,histx,m,s]=stat_ds(d,histout,histx,m,s,''span'',1.8,' strhist];

%--------------------- Iterations ------------------

pause(1)

for i = 1:iter
   r_struct.it=i;
   [d,r,r_struct]=db_gods(d,r,g,ntype,file,chs,chn,fid,reclen,r_struct,sp);
   eval(strhist);
   pause(2);
end

%--------------------- Final part ------------------

dx=histx(2)-histx(1);

out_hist=gd(histout);
out_hist=edit_gd(out_hist,'dx',dx,'ini',histx(1));
