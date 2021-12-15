function plot_peaks2(peaks,iclog,cellab)
% plot of peaks - mainly for candidates
%
%    M=plot_peaks(peaks,iclog,cellab)
%
%  peaks   peak tern (N,3) or quatern (N,4)
%          1st column is x, 2nd is y, 3rd is color, 4th size 
%  iclog   =1 logaritmic color (3rd components)
%  cellab  cell array with the title, the x and y labels

% Version 2.0 - October 2012
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

sel=1; % da capire
[n1,n2]=size(peaks);

if ~exist('iclog','var')
    iclog=0;
end
if ~exist('cellab','var')
    cellab={' ',' ',' '};
end
% if ~exist('cont','var')
%     cont.tim0=0;
% end
% if ~exist('icplot','var')
%     icplot=1;
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

if n2 == 4
    mi4=min(peaks(:,4));
    ma4=max(peaks(:,4));
    hres4=12;
    iv4=floor(hres4*(peaks(:,4)-mi4)*0.9999/(ma4-mi4))+1;
else
    hres4=1;
    iv4=ones(n1,1);
end

figure,hold on

res=50;
lsel=length(sel);
i=floor((0:res-1)*lsel/res)+1;
sel1=sel(i);
for j = 1:hres4
    jj=find(iv4==j);
    iv1=iv(jj);
    x=peaks(jj,1);
    y=peaks(jj,2);
    for i = 1:res
        rgb=p2rgb((i-0.5)/res);
        ii=find(iv1 < i/res & iv1 > (i-1)/res);
        if ~isempty(ii) & sel1(i) == 1
%             plot(peaks(ii,1),peaks(ii,2),'.','Color',rgb)
            plot(x(ii),y(ii),'.','Color',rgb,'MarkerSize',j+6)
        end
    end
end

title(cellab{1}),grid on,xlabel(cellab{2}),ylabel(cellab{3})

% mint=floor(min(peaks(:,1)));
% maxt=ceil(max(peaks(:,1)));
% 
% minf=floor(min(peaks(:,2)));
% maxf=ceil(max(peaks(:,2)));
% 
% if length(h2) == 1
%     h2(1)=(maxt-mint)*2;
%     h2(2)=(maxf-minf)/0.01;
% end
% 
% dt=(maxt-mint)/h2(1);
% df=(maxf-minf)/h2(2);
% cont.Dtim=dt;
% cont.Dfr=df;
% init=mint+0.25+dt/2;
% inif=df/2;
% cont.initcent=init;
% cont.inifcent0=inif;
% 
% ctrs{1}=init:dt:maxt; % start at 6 UT
% ctrs{2}=minf+df/2:df:maxf;
% M=hist3(peaks(:,1:2),ctrs);
% maxM=max(M(:));
% xh=(0:100)*maxM/100;
% h=hist(M(:),xh);
% pint=integralF_fromhist(h);
% 
% M=gd2(M);
% M=edit_gd2(M,'ini',init,'dx',dt,'ini2',minf+df,'dx2',df,'cont',cont); memory
% if icplot > 0
%     image_gd2(M);title(['Peakmap map (histogram)' strtit]),grid on,xlabel('days'),ylabel('Hz')
%     figure,plotyy(xh,h,xh,pint,'semilogy'),title(['Map histogram ' strtit]),grid on
% end