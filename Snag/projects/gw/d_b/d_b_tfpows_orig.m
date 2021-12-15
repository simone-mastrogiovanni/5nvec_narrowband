function [out_tsp,D_B]=d_b_tfpows(D_B)
%d_b_tfpows  time frequency spectrum
%
%          [out_tsp,D_B]=d_b_tfpows(D_B)
%
%          D_B        a D_B structure
%          out_tsp    time-frequency output spectrum

% Version 1.0 - April 1999
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1999  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

%---------------------- Preamble ---------------------

ntype=D_B.data.type;
file=D_B.data.file
chs=D_B.data.chname;
chn=D_B.data.chnumber;
sp=D_B.data.sp;
dt=D_B.data.dt;
dlen=D_B.data.dlen;
ff_struct=D_B.filter;
frame4par=D_B.data.frame4par;
iter=D_B.proc.iter;

%--------------------- Initial part ------------------

frmax0=0.5/dt;
sfr=sprintf('%f',frmax0);
   
lfft=1024;
if ntype == 100
   lfft=dlen;
end
lfft=sprintf('%d',lfft);

answ=inputdlg({'Length of an fft ? (not variable for simulation)' ...
   'Number of spectra ?' ...
   'Average on how many periodograms ?'...
   'Lower frequency ?' 'Higher frequency ?'},...
   'Base spectral parameters',1,...
   {lfft '100' '10' '0' sfr});
dslen=eval(answ{1});
if ntype == 100
   dslen=dlen
end   
nspec=eval(answ{2});
iter=nspec;
aver=eval(answ{3});
frmin=eval(answ{4});
frmax=eval(answ{5});

n1=floor(frmin*dslen/(2*frmax0)+1);
n2=floor(frmax*dslen/(2*frmax0));
dn=n2-n1+1;
frmin1=(n1-1)*2*frmax0/dslen;
frmax1=n2*2*frmax0/dslen;

amap=zeros(dn,nspec);

rglen=2*max(dslen,dlen);

typ=1;

[d,r,fid,reclen,g,r_struct]=db_open(ntype,file,chs,dslen,typ,rglen,dt,sp,frame4par);
[ff_struct,dout]=ffilt_open_ds(d,ff_struct);
      
%disp('check1'),r_struct.cont,r_struct.cont.dir
frmax=1/(2*dt);

%--------------------- Iterations ------------------

pause(0.2)

for i = 1:iter
   amap(:,i)=zeros(dn,1);
   r_struct.it=i;
   for j=1:aver
      [d,r,r_struct]=db_gods(d,r,g,ntype,file,chs,chn,fid,reclen,r_struct,sp);
      [ff_struct,dout]=ffilt_go_ds(d,ff_struct,dout);
      powsout=ipows_ds_ng(dout,answ,'interact','limit',n1,n2);
      amap(:,i)=amap(:,i)+powsout';
   end
   pause(0.1);
end

%--------------------- Final part ------------------

D_B.filter=ff_struct;
dx=dt*dslen*aver/typ;
dx2=1/(dt*dslen);
out_tsp=gd2(amap');
out_tsp=edit_gd2(out_tsp,'dx',dx,'dx2',dx2,'ini2',frmin1);
   
map_gd2(out_tsp);
