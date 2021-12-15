function [hist1 dist1 xh]=test_chisq(dat,amp)
% TEST_CHISQ  tests a chi-square data set also with non-centrality added
%             the dof number is the lower dimension of dat, multiplied by 2
%
%   [his1t dist1 xh]=test_chisq(dat,amp)
%
%    dat(dof/2,N)    input data (complex,)
%    amp             non-centrality amplitudes (squared, relative)

[dof N]=size(dat);
dof=2*dof;
n=length(amp);
dat1=abs(dat).^2;
if dof == 2
    display(sprintf(' %d dofs',dof))
elseif dof == 4
    display(sprintf(' %d dofs',dof))
    dat1=dat1(1,:)+dat1(2,:);
else
    display(sprintf(' %d dof',dof))
    return
end

me=mean(dat1);
ma=max(dat1);
x2cost=dof/me;

dxh=2.4*ma/200;
xh=(0.5:200)*dxh;
hist1=zeros(n+1,200);
dist1=hist1;
hist1(1,:)=hist(dat1,xh);
dist1(1,:)=ncx2pdf(xh*x2cost,dof,0);
med(1)=me;

ph=exp(1j*rand(1,N)*2*pi);

if dof == 2
    for i = 1:n
        dat1=abs(dat+ph*sqrt(me*amp(i)/dof)).^2;
        med(i+1)=mean(dat1);
        hist1(i+1,:)=hist(dat1,xh);
        dist1(i+1,:)=ncx2pdf(xh*x2cost,dof,amp(i));
    end
else
    for i = 1:n
        dat1=abs(dat(1,:)+ph*sqrt(me*amp(i)/dof)).^2+...
            abs(dat(2,:)).^2;
        med(i+1)=mean(dat1);
        hist1(i+1,:)=hist(dat1,xh);
        dist1(i+1,:)=ncx2pdf(xh*x2cost,dof,amp(i));
    end
end

disp(sprintf('%e excitation, mean %e',0,med(1)));

for i = 1:n
    disp(sprintf('%e excitation, mean %e  r = %e',amp(i),med(i+1),(med(i+1)-med(1))/amp(i)));
end

hist1=hist1/(N*dxh);
dist1=dist1*x2cost;

figure,semilogy(xh,hist1'),grid on
hold on,semilogy(xh,dist1','--'),grid on

