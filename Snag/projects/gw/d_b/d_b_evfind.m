function D_B=d_b_evfind(D_B)
%D_B_EVFIND  event finder
%
%           D_B=d_b_evfind(D_B)
%
%     D_B       a D_B structure

% Version 1.0 - October 1999
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

r_struct=0;

%--------------------- Initial part ------------------

%pause(1)

answ=inputdlg({'Mode ? (0 no event, 1 find ev. 2 also shape)' ...
   'Statistics ? (0 no stat, 1 AR stat, 2 rectangular stat)' ...
   'tau ?'...
   'CR Threshold ?'...
   'Dead time ?'...
   'Statistics time intervals ?'...
	'Number of frames ?'},...
   'Event finder parameters',1,...
   {'1' '1' '100' '3' '0.1' '10' '100'});

mode(1)=eval(answ{1});
mode(2)=eval(answ{2});
mode(3)=0;
mode(4)=dt;
mode(5)=eval(answ{3});
mode(6)=eval(answ{4});
mode(7)=eval(answ{5});
mode(8)=eval(answ{6});
mode(9)=0;

iter=eval(answ{7});

folder=' ';
fileev='ev.dat';
filest='st.dat';
stat=zeros(1,30);

typ=1;
dslen=dlen;
rglen=dslen*2;

[d,r,fid,reclen,g,r_struct]=db_open(ntype,file,chs,dslen,typ,rglen,dt,sp,frame4par);

frmax=1/(2*dt);

%--------------------- Iterations ------------------

for i = 1:iter
   r_struct.it=i;
   [d,r,r_struct]=db_gods(d,r,g,ntype,file,chs,chn,fid,reclen,r_struct,sp);
   y=y_ds(d);
   stat=event_finder(y,mode,stat,folder,fileev,filest);
end

%--------------------- Final part ------------------

stat(1:20)