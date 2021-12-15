function [out_dtsp,D_B]=d_b_dtfpows(D_B)
%D_B_DTFPOWS   innovation time-frequency spectrum
%
%          [out_dtsp,D_B]=d_b_dtfpows(D_B)
%
%          D_B        a D_B structure
%          out_dtsp   output time-frequency innovation spectrum

% Version 1.0 - April 1999
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
%    Luca Pontisso - luca.pontisso@roma1.infn.it
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

frmax0=0.5/dt;
sfr=sprintf('%f',frmax0);
   
lfft=1024;
if ntype == 100
   lfft=dlen;
end
lfft=sprintf('%d',lfft);
   
answ=inputdlg({'Length of an fft ? (not variable for simulation)' ...
   'Number of spectra ?' ...
   'tau value (in periodograms dt) ?' 'Lower frequency ?' 'Higher frequency ?'},...
   'Base spectral parameters',1,...
   {lfft '100' '10' '0' sfr});
dslen=eval(answ{1});
if ntype == 100
   dslen=dlen
end
nspec=eval(answ{2});
iter=nspec;
tau=eval(answ{3});
frmin=eval(answ{4});
frmax=eval(answ{5});

w=exp(-(1/tau));

n1=floor(frmin*dslen/(2*frmax0)+1);
n2=floor(frmax*dslen/(2*frmax0));
dn=n2-n1+1;
frmin1=(n1-1)*2*frmax0/dslen;
frmax1=n2*2*frmax0/dslen;

noper=0;

str={'Ratio' 'Difference' 'Normalized difference'};

[noper iok]=listdlg('PromptString','Select operation:',...
   'SelectionMode','single',...
   'ListString',str);

amap=zeros(dn,1);
dmap=zeros(dn,nspec);

rglen=2*max(dslen,dlen);

typ=1;

[d,r,fid,reclen,g,r_struct]=db_open(ntype,file,chs,dslen,typ,rglen,dt,sp,frame4par);

frmax=1/(2*dt);

norm=0;

for i =1:ceil(tau)
   r_struct.it=i;
   [d,r,r_struct]=db_gods(d,r,g,ntype,file,chs,chn,fid,reclen,r_struct,sp);
   powsout=ipows_ds_ng(d,answ,'interact','limit',n1,n2);
   amap=w*amap+powsout';
   norm=w*norm+1;
end

%--------------------- Iterations ------------------

pause(1)

for i = 1:iter
   r_struct.it=i;
   [d,r,r_struct]=db_gods(d,r,g,ntype,file,chs,chn,fid,reclen,r_struct,sp);
   powsout=ipows_ds_ng(d,answ,'interact','limit',n1,n2);
   switch noper
   case 1
      dmap(:,i)=norm*powsout'./amap;
   case 2
      dmap(:,i)=powsout'-amap./norm;
   case 3
      dmap(:,i)=(norm*powsout'-amap)./amap;
   end    
   amap=w*amap+powsout';
   norm=w*norm+1;
end

%--------------------- Final part ------------------

dx=dt*dslen/typ;
dx2=1/(dt*dslen);
  
dmap=dmap';
out_dtsp=gd2(dmap);
out_dtsp=edit_gd2(out_dtsp,'dx',dx,'dx2',dx2,'ini2',frmin1);
   
map_gd2(out_dtsp);