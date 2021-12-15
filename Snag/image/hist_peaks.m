function M=hist_peaks(gA,hpar)
% histogramming peakmaps
%
%    [x y v M]=plot_peaks(gA,iclog,h2,sel,strtit)
%
%  gA      sparse gd2 or peak tern (N,3)
%  hpar    2-D histogram parameters [dt (hours), df, time phase) or 0 for default

% Version 2.0 - October 2012
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

if ~exist('iclog','var')
    iclog=0;
end
if ~exist('hpar','var')
    hpar=0;
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

mint=floor(min(x));
maxt=ceil(max(x));

minf=floor(min(y));
maxf=ceil(max(y));

if length(hpar) == 1
    hpar(1)=12;
    hpar(2)=0.01;
end

if length(hpar) == 2
    hpar(3)=0;
end

dt=hpar(1)/24;
df=hpar(2);
nt=round((maxt-mint)/hpar(1)+0.0001);
nf=round((maxf-minf)/hpar(2)+0.0001);
cont.Dtim=dt;
cont.Dfr=df;
init=mint+0.25+dt/2+hpar(3);  % initial bin centre, default 12 h UTC OK for Virgo) 
                              %    hpar(3) = -7/24 for L and = -9/24 for H
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
% image_gd2(M);title(['Peakmap map (histogram)' strtit]),grid on,xlabel('days'),ylabel('Hz')
% figure,plotyy(xh,h,xh,pint,'semilogy'),title(['Map histogram ' strtit]),grid on