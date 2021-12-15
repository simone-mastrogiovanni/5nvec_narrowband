function out=ana_merge_cand(cand,patches,basic_merge,hm_job)
% analysis for Hough candidates from merged peakmaps as created by lancia_merge
%
%

out=struct();
disp('     ana_merge_cand')

[M dummy]=size(patches);
m=(sqrt(M)-1)/2+1;
Z=zeros(M,3);

l=patches(:,1);
b=patches(:,2);
f=cand(1,:);
sd=cand(4,:);
a=cand(5,:);

ul=unique(l);
dl=ul(2)-ul(1);

ub=unique(b);
db=ub(2)-ub(1);

Df=0;
Dl=0;
Db=0;
Dsd=0;

out.f=f;
out.l=l';
out.b=b';
out.sd=sd;
out.a=a;

[out.A.max,ii]=max(a);
out.imax=ii;

if f(ii) == min(f)
    Df=-5*hm_job.fr(2);
    fprintf(' frequency edge reached ! change hm_job by %.5f \n',Df)
end
if f(ii) == max(f)
    Df=5*hm_job.fr(2);
    fprintf(' frequency edge reached ! change hm_job by %.5f \n',Df)
end

if l(ii) == min(l)
    Dl=-6*dl;
    fprintf(' lambda edge reached ! change patches by %.5f \n',Dl)
end
if l(ii) == max(l)
    Dl=6*dl;
    fprintf(' lambda edge reached ! change patches by %.5f \n',Dl)
end

if b(ii) == min(b)
    Db=-6*db;
    fprintf(' beta edge reached ! change patches %.5f \n',Db)
end
if b(ii) == max(b)
    Db=6*db;
    fprintf(' beta edge reached ! change patches by %.5f \n',Db)
end

if sd(ii) == min(sd)
    Dsd=-10*hm_job.sd(2);
    fprintf(' spin-down edge reached ! change hm_job by %.5f \n',Dsd)
end
if sd(ii) == max(sd)
    Dsd=10*hm_job.sd(2);
    fprintf(' spin-down edge reached ! change hm_job by %.5f \n',Dsd)
end

out.Df=Df;
out.Dl=Dl;
out.Db=Db;
out.Dsd=Dsd;

Z(:,1)=l;
Z(:,2)=b;
Z(:,3)=a;
color_points_1(Z),title('sky'),xlabel('lambda'),ylabel('beta')
hold on,plot(l(ii),b(ii),'rO'),grid on

Z(:,1)=f;
Z(:,2)=sd;
Z(:,3)=a;
color_points_1(Z),title('sd vs fr'),xlabel('frequency'),ylabel('spin-down')
hold on,plot(f(ii),sd(ii),'rO'),grid on

Z(:,1)=f;
Z(:,2)=l;
Z(:,3)=a;
color_points_1(Z),title('lambda vs fr'),xlabel('frequency'),ylabel('lambda')
hold on,plot(f(ii),l(ii),'rO'),grid on

[C,isd,ic] = unique(sd);
figure,hold on,grid on

for i = 1:length(isd)
    j=find(ic == i);
    [tcol colstr colchar]=rotcol(i);
    plot(f(j),a(j),[colchar '.']);
end

[dummy,i]=sort(a,'descend');
A0=a(i(1:m));
F0=f(i(1:m));
L0=l(i(1:m));
B0=b(i(1:m));
SD0=sd(i(1:m));

[C,ia,ic] = unique(F0);
for j = 1:length(ia)
    F(j)=F0(ia(j));
    AF(j)=max(A0(find(ic == j)));
end

minF=min(F);
maxF=max(F);
out.F.x=F;
out.F.y=AF;
if length(F) > 2
    p = polyfit(F-minF,AF,2);
    if p(1) > 0
        disp('   Frequency fit error: check !')
    end
    out.F.max=-p(2)/(2*p(1))+minF;
    x=(0:100)*(maxF-minF)/100;
    y=polyval(p,x);
    figure,plot(f,a,'.'),hold on,plot(F,AF,'r.'),plot(x+minF,y,'g'),grid on
    [dummy,j]=max(y);
    out.F.max1=minF+x(j);
else
    disp('   Frequency no fit')
    [dummy,jj]=max(AF);
    out.F.max=F(jj);
end
out.F.max0=f(ii);

[C,ia,ic] = unique(L0);
for j = 1:length(ia)
    L(j)=L0(ia(j));
    AL(j)=max(A0(find(ic == j)));
end

minL=min(L);
maxL=max(L);
out.L.x=L;
out.L.y=AL;
if length(L) > 2
    p = polyfit(L-minL,AL,2);
    if p(1) > 0
        disp('   Lambda fit error: check !')
    end
    out.L.max=-p(2)/(2*p(1))+minL;
    x=(0:100)*(maxL-minL)/100;
    y=polyval(p,x);
    figure,plot(l,a,'.'),hold on,plot(L,AL,'r.'),plot(x+minL,y,'g'),grid on
    [dummy,j]=max(y);
    out.L.max1=minL+x(j);
else
    disp('   Lambda no fit')
    [dummy,jj]=max(AL);
    out.L.max=L(jj);
end
out.L.max0=l(ii);

[C,ia,ic] = unique(B0);
for j = 1:length(ia)
    B(j)=B0(ia(j));
    AB(j)=max(A0(find(ic == j)));
end

minB=min(B);
maxB=max(B);
out.B.x=B;
out.B.y=AB;
if length(B) > 2
    p = polyfit(B-minB,AB,2);
    if p(1) > 0
        disp('   Beta fit error: check !')
    end
    out.B.max=-p(2)/(2*p(1))+minB;
    x=(0:100)*(maxB-minB)/100;
    y=polyval(p,x);
    figure,plot(b,a,'.'),hold on,plot(B,AB,'r.'),plot(x+minB,y,'g'),grid on
    [dummy,j]=max(y);
    out.B.max1=minB+x(j);
else
    disp('   Beta no fit')
    [dummy,jj]=max(AB);
    out.B.max=B(jj);
end
out.B.max0=b(ii);

[C,ia,ic] = unique(SD0);
for j = 1:length(ia)
    SD(j)=SD0(ia(j));
    ASD(j)=max(A0(find(ic == j)));
end

minSD=min(SD);
maxSD=max(SD);
out.SD.x=SD;
out.SD.y=ASD;
if length(SD) > 2
    p = polyfit(SD-minSD,ASD,2);
    if p(1) > 0
        disp('   Spin-down fit error: check !')
    end
    out.SD.max=-p(2)/(2*p(1))+minSD;
    x=(0:100)*(maxSD-minSD)/100;
    y=polyval(p,x);
    figure,plot(sd,a,'.'),hold on,plot(SD,ASD,'r.'),plot(x+minSD,y,'g'),grid on
    [dummy,j]=max(y);
    out.SD.max1=minSD+x(j);
else
    disp('   Spin-down no fit')
    [dummy,jj]=max(ASD);
    out.SD.max=SD(jj);
end
out.SD.max0=sd(ii);