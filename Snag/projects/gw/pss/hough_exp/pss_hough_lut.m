function [HM,psspar]=pss_hough_lut(psspar,tfmap)
%PSS_HOUGH_LUT  creates a Hough map by the lut method
%
%  psspar   input (and output) pss parameter structure
%  HM       output gd2 Hough map

crealut=1;

if isfield(psspar,'lut')
    if psspar.lut.minbeta == psspar.hmap.d1 & ...
            psspar.lut.betares == psspar.hmap.dd & ...
            psspar.lut.nbeta == (psspar.hmap.d2-psspar.hmap.d1)/psspar.hmap.dd
        crealut=0;
    end
end

if crealut > 0
    disp('  Creating lut ...');
    psspar=pss_crea_lut(psspar);
    disp('  lut created');
end

lutlam=psspar.lut.lam;
frmin=ini2_gd2(tfmap);
df=dx2_gd2(tfmap);
tmin=ini_gd2(tfmap);
dt=dx_gd2(tfmap);
nspec= n_gd2(tfmap)/m_gd2(tfmap);
nfr=m_gd2(tfmap);

fr0=psspar.band.f0+df*1.5;
% hdf=df*p.mapping.kdf;
% fr01=fr0-hdf;
% fr02=fr0+hdf;

[i1,j1]=findtr_gd2(tfmap); % i1 -> frequency, j1 -> time (ordered)
npeak=length(i1);

[vl1,vb1,ve1]=get_gd2_vdetect(tfmap);size_vl1=size(vl1)

y2=y_gd2(tfmap);
y1=zeros(nfr,1);
df0=fr0-frmin;
dcosfi=psspar.lut.dcosfi;

psspar.lut.dim_preHM=ceil(psspar.hmap.na*2);
preHM=zeros(psspar.lut.dim_preHM,psspar.hmap.nd);
bias=round(psspar.lut.kcosfi0-(fr0-frmin)/df)
mincos=0;maxcos=0;

for i = 1:nspec
    y1=find(y2(i,:));  % indices of non-zero values of the spectrum
    vlam=vl1(i);
    if vlam < 0
        vlam=vlam+360;
    end
    ksign=1;
    if vb1(i) < 0
        ksign=-1;
    end
    kvbet=floor((ksign*vb1(i))/psspar.lut.dvb)+1; % RICONTROLLARE
    
    for i = 1:length(y1)
        kcosfi=y1(i)+bias;
        if kcosfi > 0 & kcosfi <= psspar.lut.ncosfi
            preHM=draw_ann(psspar,preHM,lutlam,kcosfi,kvbet,vlam,ksign);
        end
    end
end

matimag(preHM');

HM=finHM(psspar,preHM);matimag(HM')

max(HM(:))