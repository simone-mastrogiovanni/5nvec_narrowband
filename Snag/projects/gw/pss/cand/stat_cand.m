function out=stat_cand(list,dim)
%
%     out=stat_cand(list,dim)
%
%   list    file list
%   dim     if exist, hist dimensions (fr, lam, bet, sd, amp, cr)
%           otherwise use default

% Version 2.0 - July 2012
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

hsky=0;
fidlist=fopen(list,'r');
nfiles=0;

N=0;
frmin=1000; frmax=0;
lammin=1000; lammax=0;
betmin=1000; betmax=-1000;
sdmin=1000; sdmax=-1000;
ampmin=1e30; ampmax=-1e30;
crmin=100000; crmax=-10000;
hmin=1e30; hmax=-1e30;
while (feof(fidlist) ~= 1)
    nfiles=nfiles+1;
    fil=fscanf(fidlist,'%s',1);
    str=sprintf('  %s ',fil);
    disp(str);
%     [pathstr, name, ext]= fileparts(fil);
    
    A=load(fil);
%    A=A.A;
    name=fieldnames(A);
    eval(['A=A.' name{1} ';'])
    if isstruct(A)
        info=A.info;
        A=A.cand;
    end
    [n1, n2]=size(A);
    
    N=N+n1;
    
    frmin=min(frmin,min(A(:,1)));
    frmax=max(frmax,max(A(:,1)));
    
    lammin=min(lammin,min(A(:,2)));
    lammax=max(lammax,max(A(:,2)));
    
    betmin=min(betmin,min(A(:,3)));
    betmax=max(betmax,max(A(:,3)));
    
    sdmin=min(sdmin,min(A(:,4)));
    sdmax=max(sdmax,max(A(:,4)));
    
    ampmin=min(ampmin,min(A(:,5)));
    ampmax=max(ampmax,max(A(:,5)));
    
    crmin=min(crmin,min(A(:,6)));
    crmax=max(crmax,max(A(:,6)));
    
    if n2 == 9
        A9=A(:,9);
        ii=find(A9 < 0.5e-22 & A9 > 1e-26);
        A9=A9(ii);
        hmin=min(hmin,min(A9));
        hmax=max(hmax,max(A9));
    end
end
fclose(fidlist);

fprintf('             %d candidates \n',N)
fprintf(' frequency min,max :  %f %f \n',frmin,frmax)
fprintf(' lambda min,max    :  %f %f \n',lammin,lammax)
fprintf(' beta min,max      :  %f %f \n',betmin,betmax)
fprintf(' spin-down min,max :  %e %e \n',sdmin,sdmax)
fprintf(' amplitude min,max :  %f %f \n',ampmin,ampmax)
fprintf(' h amp min,max     :  %e %e \n',hmin,hmax)
fprintf(' cr min,max        :  %f %f \n',crmin,crmax)
crmax=min(crmax,1000);

if exist('dim','var')
    hfr=zeros(1,dim(1));
    hlam=zeros(1,dim(2));
    hbet=zeros(1,dim(3));
    hsd=sdmin:info.sd/info.mode.ref.sd.enh:sdmax;
    hamp=zeros(1,dim(5));
    hcr=zeros(1,dim(6));
    xfr=frmin+(0:dim(1)-1)*(frmax-frmin)/dim(1); 
    xlam=lammin+(0:dim(2)-1)*(lammax-lammin)/dim(2);
    xbet=betmin+(0:dim(3)-1)*(betmax-betmin)/dim(3);
    xsd=sdmin+(0:dim(4)-1)*(sdmax-sdmin)/dim(4);
    xamp=ampmin+(0:dim(5)-1)*(ampmax-ampmin)/dim(5);
    xcr=crmin+(0:dim(6)-1)*(crmax-crmin)/dim(6); 
    if n2 == 9
        xh=hmin+(0:dim(5)-1)*(hmax-hmin)/dim(7);
    end
else
    xfr=info.run.anaband(1):info.run.anaband(3)/10:info.run.anaband(2)+info.run.anaband(3);
    xlam=0:360;
    xbet=-90:90;
    xsd=sdmin:info.sd.dnat/info.mode.ref.sd.enh:sdmax;
    xamp=1:ceil(ampmax);
    xcr=crmin+(0:499)*(crmax-crmin)/500;
    xh=hmin:hmin/2:hmax;
    frmin=info.run.anaband(1);
    lammin=0;
    betmin=-90;
    ampmin=1;
    hfr=xfr*0;
    hlam=xlam*0;
    hbet=xbet*0;
    hsd=xsd*0;
    hamp=xamp*0;
    hcr=xcr*0;
    hh=xh*0;
end

ctrs{1}=xlam;
ctrs{2}=xbet;
% h3lb=zeros(dim(2),dim(3));
a2=[];
a3=[];

fidlist=fopen(list,'r');
while (feof(fidlist) ~= 1)
    fil=fscanf(fidlist,'%s',1);disp(fil)
    
    A=load(fil);
%    A=A.A;
    name=fieldnames(A);
    eval(['A=A.' name{1} ';'])
    if isstruct(A)
        A=A.cand;
    end
    
    A(:,2)=mod(A(:,2),360);
    A(:,4)=correct_sampling(A(:,4),0,info.sd.dnat/info.mode.ref.sd.enh);
    h=hist(A(:,1),xfr);
    hfr=hfr+h;
    h=hist(A(:,2),xlam);
    hlam=hlam+h;
    h=hist(A(:,3),xbet);
    hbet=hbet+h;
    h=hist(A(:,4),xsd);
    hsd=hsd+h;
    h=hist(A(:,5),xamp);
    hamp=hamp+h;
    h=hist(A(:,6),xcr);
    hcr=hcr+h; % length(xh),figure,plot(xh,'.')
    h=hist(A(:,9),xh);
    hh=hh+h;

%     a2=[a2 A(:,2)'];
%     a3=[a3 A(:,3)'];
end
fclose(fidlist);
    
% AA(:,1)=a2;
% AA(:,2)=a3;
% h3=hist3(AA,ctrs);
% figure,hist(a2,100)
% figure,hist(a3,100)

figure,plot(xfr,hfr),grid on,title('Frequency')
figure,plot(xlam,hlam),grid on,title('Lambda')
figure,plot(xbet,hbet),grid on,title('Beta')
figure,plot(xsd,hsd),grid on,title('Spin-down')
figure,semilogy(xamp,hamp),grid on,title('Amplitude')
figure,semilogy(xcr,hcr),grid on,title('Critical Ratio')
figure,semilogy(xh,hh),grid on,title('h amplitude')

% figure,image(xlam,xbet,h3),colorbar,grid on 

hfr=gd(hfr);
out.hfr=edit_gd(hfr,'ini',frmin,'dx',xfr(2)-xfr(1));
hlam=gd(hlam);
out.hlam=edit_gd(hlam,'ini',lammin,'dx',xlam(2)-xlam(1));
hbet=gd(hbet);
out.hbet=edit_gd(hbet,'ini',betmin,'dx',xbet(2)-xbet(1));
hsd=gd(hsd);
out.hsd=edit_gd(hsd,'ini',sdmin,'dx',xsd(2)-xsd(1));
hamp=gd(hamp);
out.hamp=edit_gd(hamp,'ini',ampmin,'dx',xamp(2)-xamp(1));
hcr=gd(hcr);
out.hcr=edit_gd(hcr,'ini',crmin,'dx',xcr(2)-xcr(1));
hh=gd(hh);
out.hh=edit_gd(hh,'ini',hmin,'dx',xh(2)-xh(1));

% hsky=gd2(h3');
% hsky=edit_gd2(hsky,'ini',lammin,'dx',(lammax-lammin)/dim(2),'ini2',betmin,'dx2',(betmax-betmin)/dim(3))