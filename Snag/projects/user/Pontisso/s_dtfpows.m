function out_dtsp=s_dtfpows(varargin)

g=varargin{1};

n=n_gd(g);
dt=dx_gd(g);
y=y_gd(g);

frmax0=0.5/dt;
sfr=sprintf('%f',frmax0);
   
lfft=1024;

lfft=sprintf('%d',lfft);
leng=sprintf('%d',length(y));


answ=inputdlg({'Length of gd' ...
   'Length of an fft ? (not variable for simulation)' ...
   'Number of spectra ?' ...
   'tau value (in periodograms dt) ?' 'Lower frequency ?' 'Higher frequency ?'},...
   'Base spectral parameters',1,...
   {leng lfft '100' '10' '0' sfr});

dslen=eval(answ{2});
nspec=eval(answ{3});
iter=nspec;
tau=eval(answ{4});
frmin=eval(answ{5});
frmax=eval(answ{6});

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

dstype=1;
d=ds(dslen);
d=edit_ds(d,'dt',dt,'type',dstype);

% rglen=2*max(dslen,dlen);

frmax=1/(2*dt);
norm=0;

for i =1:ceil(tau)
   d=gd2ds(d,g);
   powsout=ipows_ds_ng(d,answ,'interact','limit',n1,n2);
   amap=w*amap+powsout';
   norm=w*norm+1;
end

pause(1)

for i = 1:iter
   d=gd2ds(d,g);
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

dx=dt*dslen;
dx2=1/(dt*dslen);
  
dmap=dmap';
out_dtsp=gd2(dmap);
out_dtsp=edit_gd2(out_dtsp,'dx',dx,'dx2',dx2,'ini2',frmin1);
   
map_gd2(out_dtsp);
