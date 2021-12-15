function [g2st gmean gstd]=gd2_stat(g2,nbin,icabsc,dim,labels)
% gd2_stat  statistics on a gd2 - only for non-zero data
%
%    [g2st gmean gstd]=gd2_stat(g2,nbin,icabsc,dim)
%
%   g2      input gd2
%   nbin    number of bins of the histograms
%   icabsc  1 linear scale, 2 log, 0 auto-choice
%   dim     dimension (1 primary abscissa, default, 2 secondary)
%   capt    cell array of strings with "what" and "abscissa label"

% Version 2.0 - March 2011
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

[n ini dx m ini2 dx2 type capt]=par_gd2(g2);
n1=n/m;
n2=m;
M=y_gd2(g2);

if ~exist('nbin','var')
    nbin=200;
end

if ~exist('icabsc','var')
    icabsc=0;
end

if ~exist('dim','var')
    dim=1;
end

if dim == 2
    M=M.';
    n1=n/m;
    n2=m;
    ini2=ini;
    dx2=dx;
end

if ~exist('labels','var')
    labels={' ',' '};
end

what=underscore_man(labels{1});
absclab=labels{2};

g2st=zeros(nbin,n2);
gmean=zeros(1,n2);
gstd=gmean;

M1=M(:);
ii=find(M1);
M1=M1(ii);
mmin=min(M1);
mmax=max(M1);
    
if icabsc == 0
    if mmax/mmin > 10 & mmin > 0
        icabsc=2;
    else
        icabsc=1;
    end
end

if icabsc == 2
    mmin=log10(mmin);
    mmax=log10(mmax);
    strsc=' - log10 z-scale';
    op=1;
else
    strsc=' - linear z-scale';
    op=0;
end

dxh=(mmax-mmin)/(nbin-1);
xh=mmin+(0:nbin-1)*dxh;

for i = 1:n2
    M1=M(:,i);
    ii=find(M1);
    M1=M1(ii);
    gmean(i)=mean(M1);
    gstd(i)=std(M1);
    if icabsc == 2
        M1=log10(M1);
    end
    h=hist(M1,xh);
    g2st(:,i)=h;
end

scmean=max(gmean)/min(gmean);
scstd=max(gstd)/min(gstd);
g2st=gd2(g2st');
g2st=edit_gd2(g2st,'ini',ini2,'dx',dx2,'ini2',mmin,'dx2',dxh);
gmean=gd(gmean);
gmean=edit_gd(gmean,'ini',ini2,'dx',dx2);
gstd=gd(gstd);
gstd=edit_gd(gstd,'ini',ini2,'dx',dx2);

if type == 2 & dim == 2
    g2st=edit_gd2(g2st,'x',x_gd2(g2));
    gmean=edit_gd(gmean,'x',x_gd2(g2));
    gstd=edit_gd(gstd,'x',x_gd2(g2));
end

image_gd2(g2st,0,op),title(['Map of histograms of ' what strsc]),xlabel(absclab)
if scmean > 10
    figure,semilogy(gmean),xlim([ini2 max(x_gd(gmean))]),title(['Means of ' what]),xlabel(absclab)
else 
    figure,plot(gmean),xlim([ini2 max(x_gd(gmean))]),title(['Means of ' what]),xlabel(absclab)
end
grid on
if scstd > 10
    figure,semilogy(gstd),xlim([ini2 max(x_gd(gmean))]),title(['St.Dev. of ' what]),xlabel(absclab)
else
    figure,plot(gstd),xlim([ini2 max(x_gd(gmean))]),title(['St.Dev. of ' what]),xlabel(absclab)
end
grid on