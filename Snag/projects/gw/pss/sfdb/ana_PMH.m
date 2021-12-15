% ana_PMH

thresh=85;        % EDIT
VSR='O1L_2048Hz';  % EDIT
list=['PMH_' VSR '_list.txt'];
iniband=16;        % EDIT 

fidlist=fopen(list,'r');
nfiles=0;
ii=0;
veto=zeros(3000000,3);
ic4=0;

while (feof(fidlist) ~= 1)
    nfiles=nfiles+1;
    mat=fscanf(fidlist,'%s',1);
    [pathstr,nam,ext] = fileparts(mat);
    if ic4 == 0
        band=[str2num(nam(iniband:iniband+2)) str2num(nam(iniband+4:iniband+6))];
    end
    if ic4 == 1
        band=[str2num(nam(iniband:iniband+3)) str2num(nam(iniband+5:iniband+8))];
    end
    nam
    band
    if band(1) > band(2)
        band=[str2num(nam(iniband:iniband+2)) str2num(nam(iniband+4:iniband+7))]
        ic4=1;
    end
    fr(nfiles)=sum(band)/2;
    load(mat)
    eval(['gM=' nam ';'])
    M=y_gd2(gM);
    [n1 n2]=size(M);
    nbin(nfiles)=n1*n2;
    if nfiles == 1
        n11=n1;
        n21=n2;
    end
    yM=M(:);
    NpeakB(nfiles)=sum(yM);
    mea(nfiles)=mean(yM);
    sdev(nfiles)=std(yM);
    sk(nfiles)=skewness(yM);
    
    t=x_gd2(gM);
    f=x2_gd2(gM);
    [i1 i2 v]=find((M > thresh).*M);
    veto(ii+1:ii+length(i1),1)=t(i1);
    veto(ii+1:ii+length(i1),2)=f(i2);
    veto(ii+1:ii+length(i1),3)=v;
    ii=ii+length(i1);
end

veto=veto(1:ii,:);
fclose(fidlist);
veto=sortrows(veto);

cont=cont_gd2(gM)
iii=find(diff(veto(:,1)));
iii=[1 iii'+1];
nii=length(iii);
vetocell=cell(nii+2,1);
vetocell{1}=cont;
vetocell{2}=veto(iii)+cont.tim0;

for i = 1:nii-1
    vetocell{i+2}=veto(iii(i):iii(i+1)-1,2);
end
vetocell{nii+2}=veto(iii(nii):ii,2);

totpeak=sum(NpeakB);
totnbin=sum(nbin);
fprintf('%s :  %d PMHs \n',VSR,nfiles)
fprintf('PMH size %dx%d  tot bin %d, tot peak %d  mean %f \n',n11,n21,totnbin,totpeak,totpeak/totnbin)
figure,plot(fr,NpeakB),hold on,grid on,plot(fr,NpeakB,'r.')
title([VSR ' peaks; total ' num2str(totpeak)]),xlabel('Hz')

figure,plot(fr,mea),hold on,grid on,plot(fr,mea,'r.'),ylim([0 max(ceil(mea))]),...
    plot(fr,sdev,'r'),hold on,grid on,plot(fr,sdev,'.')%,plotyy(fr,mea,fr,sk)
title([VSR ' peaks: mean and st.dev. ']),xlabel('Hz')

color_points(veto)
