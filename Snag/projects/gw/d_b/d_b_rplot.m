function [out_y,D_B]=d_b_rplot(D_B)
%D_B_RPLOT   running plot
%
%             [out_y,D_B]=d_b_rplot(D_B)
%
%             D_B        a D_B structure
%             out_y      last chunk

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

%iter=D_B.proc.iter;

%--------------------- Initial part ------------------

dslen=dlen;
if dslen > 20000
    dslen=20000
end
rglen=2*dlen;
strdslen=sprintf('%d',dslen);
strwind=sprintf('%d',dslen*dt*4);

answ=inputdlg({'Window length (in seconds)',...
   'Length of chunk',...
   'Pause time (in seconds)',...
	'Number of chunks'},...
   'Running plot parameters',1,...
   {strwind,strdslen,'1','100'});

wind=eval(answ{1});
dslen=eval(answ{2});
delay=eval(answ{3});
iter=eval(answ{4});

typ=1;

[d,r,fid,reclen,g,r_struct]=db_open(ntype,file,chs,dslen,typ,rglen,dt,sp,frame4par);

ind=0;
y=zeros(1,dslen);

%--------------------- Iterations ------------------

pause(1)

for i = 1:iter
   r_struct.it=i;
   [d,r,r_struct]=db_gods(d,r,g,ntype,file,chs,chn,fid,reclen,r_struct,sp);
   [y,ind]=running_ds(d,y,ind,'window',wind,'lchunk',dslen/2,'delay',1);
end

%--------------------- Final part ------------------

out_y=gd(y);
out_y=edit_gd(out_y,'dx',dt);
