function map=gen_pows3d
%GEN_POWS3D   3 D power spectrum for frames and R87 files
%
%        map=gen_pows3d
%
%     map is a gd2

% Version 1.0 - March 1999
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1999  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

[ntype,file]=db_fildatsel;

[chn,chs,dt,dlen,sp]=db_selch(ntype,file);

frmax0=0.5/dt;
sfr=sprintf('%f',frmax0);

answ=inputdlg({'Length of an fft ?' 'Number of spectra ?' 'Average on how many ?'...
   'Lower frequency ?' 'Higher frequency ?'},...
   'Base spectral parameters',1,...
   {'1024' '100' '10' '0' sfr});
dslen=eval(answ{1});
nspec=eval(answ{2});
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

typ=2;

[d,r,fid,reclen,g,r_struct]=db_open(ntype,file,chs,dslen,typ,rglen,dt,sp);

frmax=1/(2*dt);

for i =1:nspec
   amap(:,i)=zeros(dn,1);
   for j=1:aver
      [d,r,r_struct]=db_gods(d,r,g,ntype,file,chs,chn,fid,reclen,r_struct,sp);
      powsout=ipows_ds_ng(d,answ,'interact','limit',n1,n2);
      amap(:,i)=amap(:,i)+powsout';
   end
end

dx=dt*dslen*aver/typ;
dx2=1/(dt*dslen);

amap=amap';
map=gd2(amap);
map=edit_gd2(map,'dx',dx,'dx2',dx2,'ini2',frmin1);
