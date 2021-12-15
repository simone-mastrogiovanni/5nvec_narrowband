function M=plot_peaks1(peaks,iclog,h2,sel,strtit,cont,icplot)
% plot of peaks - mainly for peak maps
%
%    M=plot_peaks(peaks,iclog,h2,sel,strtit,cont,icplot)
%
%  peaks   peak tern (N,3)
%  iclog   =1 logaritmic color
%  h2      2-D histogram dimension or 0 for default
%  sel     amplitude selection vector (e.g. [0 0 0 1 1 0 1 1 1] 
%  strtit  string for the title
%  icplot  = 0 no plot; default 1

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
if ~exist('cont','var')
    cont.tim0=0;
end
if ~exist('icplot','var')
    icplot=1;
end
% if ~isnumeric(gA)
%     A=y_gd2(gA);
%     x=x_gd2(gA);
%     y=x2_gd2(gA);
%     [ix iy v]=find(A);
%     x=x(ix);
%     y=y(iy);
%     cont=cont_gd2(gA);
% else
%     x=gA(:,1);
%     y=gA(:,2);
%     v=gA(:,3);
%     cont.tim0=0;
% end

miv=min(peaks(:,3));
mav=max(peaks(:,3));
hres=100;

if iclog == 1
    miv=log10(miv);
    mav=log10(mav);
    iv=(log10(peaks(:,3))-miv)/(mav-miv);
    hx=(0:hres)*(mav-miv)/hres+miv;
    h=hist(log10(peaks(:,3)),hx);
    hx=10.^hx;
else
    iv=(peaks(:,3)-miv)/(mav-miv);
    hx=(0:hres)*(mav-miv)/hres+miv;
    h=hist(peaks(:,3),hx);
end

if icplot > 0
    figure,hold on

    res=50;
    lsel=length(sel);
    i=floor((0:res-1)*lsel/res)+1;
    sel1=sel(i);
    for i = 1:res
        rgb=p2rgb((i-0.5)/res);
        ii=find(iv < i/res & iv > (i-1)/res);
        if ~isempty(ii) & sel1(i) == 1
            plot(peaks(ii,1),peaks(ii,2),'.','Color',rgb)
        end
    end

    title(['Peakmap ' strtit]),grid on,xlabel('days'),ylabel('Hz')

    figure,loglog(hx,h),grid on,title(['Peakmap CR histogram ' strtit]),xlabel('CR')
end

mint=floor(min(peaks(:,1)));
maxt=ceil(max(peaks(:,1)));

minf=floor(min(peaks(:,2)));
maxf=ceil(max(peaks(:,2)));

if length(h2) == 1
    h2(1)=(maxt-mint)*2;
    h2(2)=(maxf-minf)/0.01;
end

dt=(maxt-mint)/h2(1);
df=(maxf-minf)/h2(2);
cont.Dtim=dt;
cont.Dfr=df;
init=mint+0.25+dt/2;
inif=df/2;
cont.initcent=init;
cont.inifcent0=inif;

ctrs{1}=init:dt:maxt; % start at 6 UT
ctrs{2}=minf+df/2:df:maxf;
M=hist3(peaks(:,1:2),ctrs);
maxM=max(M(:));
xh=(0:100)*maxM/100;
h=hist(M(:),xh);
pint=integralF_fromhist(h);

M=gd2(M);
M=edit_gd2(M,'ini',init,'dx',dt,'ini2',minf+df,'dx2',df,'cont',cont); memory
if icplot > 0
    image_gd2(M);title(['Peakmap map (histogram)' strtit]),grid on,xlabel('days'),ylabel('Hz')
    figure,plotyy(xh,h,xh,pint,'semilogy'),title(['Map histogram ' strtit]),grid on
end