function [x y v M]=plot_peaks(gA,iclog,h2,sel,strtit)
% image of sparse matrix
%
%    [x y v M]=plot_peaks(gA,iclog,h2,sel,strtit)
%
%  gA      sparse gd2 or peak tern (N,3)
%  iclog   =1 logarithmic color
%  h2      2-D histogram dimension (h2(3) time phase) or 0 for default
%  sel     amplitude selection vector (e.g. [0 0 0 1 1 0 1 1 1] 
%  strtit  string for the title

% Version 2.0 - October 2012
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

if ~exist('iclog','var')
    iclog=0;
end
if ~exist('h2','var')
    h2=0;
end
if ~exist('sel','var')
    sel=1;
end
if ~exist('strtit','var')
    strtit=' ';
end
if ~isnumeric(gA)
    A=y_gd2(gA);
    x=x_gd2(gA);
    y=x2_gd2(gA);
    [ix iy v]=find(A);
    x=x(ix);
    y=y(iy);
    cont=cont_gd2(gA);
else
    x=gA(:,1);
    y=gA(:,2);
    v=gA(:,3);
    cont.tim0=0;
end

miv=min(v);
mav=max(v);
hres=100;

if iclog == 1
    miv=log10(miv);
    mav=log10(mav);
    iv=(log10(v)-miv)/(mav-miv);
    hx=(0:hres)*(mav-miv)/hres+miv;
    h=hist(log10(v),hx);
    hx=10.^hx;
else
    iv=(v-miv)/(mav-miv);
    hx=(0:hres)*(mav-miv)/hres+miv;
    h=hist(v,hx);
end
figure,hold on

res=50;
lsel=length(sel);
i=floor((0:res-1)*lsel/res)+1;
sel1=sel(i);
for i = 1:res
    rgb=p2rgb((i-0.5)/res);
    ii=find(iv < i/res & iv > (i-1)/res);
    if ~isempty(ii) & sel1(i) == 1
        plot(x(ii),y(ii),'.','Color',rgb)
    end
end

title(['Peakmap ' strtit]),grid on,xlabel('days'),ylabel('Hz')

figure,loglog(hx,h),grid on,title(['Peakmap CR histogram ' strtit]),xlabel('CR')

mint=floor(min(x));
maxt=ceil(max(x));

minf=floor(min(y));
maxf=ceil(max(y));

if length(h2) == 1
    h2(1)=(maxt-mint)*2;
    h2(2)=(maxf-minf)/0.01;
end

if length(h2) == 2
    h2(3)=0;
end

dt=(maxt-mint)/h2(1);
df=(maxf-minf)/h2(2);
cont.Dtim=dt;
cont.Dfr=df;
init=mint+0.25+dt/2+h2(3);  % initial bin centre, default 12 h UTC OK for Virgo) 
                            %    h2(3) = -7/24 for L and = -9/24 for H
inif=df/2;
cont.initcent=init;
cont.inifcent0=inif;

ctrs{1}=init:dt:maxt; % start at 6 UT in default
ctrs{2}=minf+df/2:df:maxf;
X(:,1)=x;
X(:,2)=y;
M=hist3(X,ctrs);
maxM=max(M(:));
xh=(0:100)*maxM/100;
h=hist(M(:),xh);
pint=integralF_fromhist(h);

M=gd2(M);
M=edit_gd2(M,'ini',init,'dx',dt,'ini2',minf+df,'dx2',df,'cont',cont);
image_gd2(M);title(['Peakmap map (histogram)' strtit]),grid on,xlabel('days'),ylabel('Hz')
figure,plotyy(xh,h,xh,pint,'semilogy'),title(['Map histogram ' strtit]),grid on