function [out_sp,D_B]=d_b_rpows(D_B)
%D_B_RPOWS  running power spectrum
%
%          [out_sp,D_B]=d_b_rpows(D_B)
%
%     D_B       a D_B structure
%     out_sp    output final spectrum

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

pause(1)

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

rglen=2*max(dslen,dlen);

typ=1;

[d,r,fid,reclen,g,r_struct]=db_open(ntype,file,chs,dslen,typ,rglen,dt,sp,frame4par);

frmax=1/(2*dt);

%--------------------- Iterations ------------------

powsout=zeros(1,dslen);  %%

for i = 1:iter
   r_struct.it=i; % display_ds(d)
   [d,r,r_struct]=db_gods(d,r,g,ntype,file,chs,chn,fid,reclen,r_struct,sp);
   [powsout,answ]=ipows_ds(d,powsout,answ,'interact','limit',frmin1,frmax1);
   pause(1);
end

%--------------------- Final part ------------------

dx=1/(dt*dslen);

out_sp=gd(powsout);
out_sp=edit_gd(out_sp,'dx',dx,'ini',frmin1);
