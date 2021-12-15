function out_tsp=s_tfpows(varargin)

g=varargin{1};

n=n_gd(g);
dt=dx_gd(g);
y=y_gd(g);

frmax0=0.5/dt;
sfr=sprintf('%f',frmax0);
   
lfft=1024;
lfft=sprintf('%d',lfft);

answ=inputdlg({'Length of an fft ?' ...
   'Number of spectra ?' ...
   'Average on how many periodograms ?'...
   'Lower frequency ?' 'Higher frequency ?'},...
   'Base spectral parameters',1,...
   {lfft '100' '10' '0' sfr});
dslen=eval(answ{1});

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

dstype=1;
d=ds(dslen);
d=edit_ds(d,'dt',dt,'type',dstype);

frmax=1/(2*dt);

pause(0.2)

for i = 1:iter
   amap(:,i)=zeros(dn,1);
   for j=1:aver
      d=gd2ds(d,g);
      powsout=ipows_ds_ng(d,answ,'interact','limit',n1,n2);
      amap(:,i)=amap(:,i)+powsout';
   end
   pause(0.1);
end

dx=dt*dslen*aver;
dx2=1/(dt*dslen);

out_tsp=gd2(amap');
out_tsp=edit_gd2(out_tsp,'dx',dx,'dx2',dx2,'ini2',frmin1);
select_mapgd2(out_tsp);
