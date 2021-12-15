function data=data_polyfit(x,y,unc,iclog,deg,ii)
% DATA_POLYFIT  analyzes x-y data
%
%     data=data_polyfit(x,y,iclog,deg,ii)
%
%   x,y     input data
%   unc     uncertainty on y data
%   iclog   0,1,2,3 -> lin, x-log, y-log, xy-log
%   deg     polynomial degree (if absent, interactive; < 0 -> deg=-deg, use external ii)
%
%   data(i).iclog    iclog
%   data(i).x        the x of the selection
%   data(i).y        the y      
%   data(i).a        the polynomial coefficients 
%   data(i).aunc     uncertainty on the polynomial coefficients
%   data(i).F        base functions
%   data(i).res      the residuals
%   data(i).errel    the relative error
%   data(i).chiq     chi square
%   data(i).ndof     number of degrees of freedom

% Project LabMec - part of the toolbox Snag - April 2008
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

[x ix]=sort(x);
y=y(ix);
x1=x;
y1=y;
if ~exist('iclog','var')
    iclog=0;
end
icdeg=1; % fixed deg, period choice
if ~exist('deg','var')
    icdeg=0; % deg and period choice
else
    if deg < 0
        icdeg=2; % fixed deg and period
        deg=-deg;
    end
end
switch iclog
    case 1
        x=log10(x);
    case 2
        y=log10(y);
    case 3
        x=log10(x);
        y=log10(y);
end

if icdeg < 2 
    [xx ii]=sel_absc(0,y,x);
end

[i1 i2]=size(ii);

for i = 1:i1
    data(i).iclog=iclog;
    data(i).x=x1(ii(i,1):ii(i,2));
    data(i).y=y1(ii(i,1):ii(i,2));
    x2=x(ii(i,1):ii(i,2));
    y2=y(ii(i,1):ii(i,2));
    if icdeg == 0  
        fig=figure,plot(x2,y2,'.'),grid on,
        ans=inputdlg('Polynomial degree ?');
        par=eval(ans{1});
        close(fig);
        deg=par;
    else
        par=deg;
    end
    [a,covar,F,res,chiq,ndof,err,errel]=gen_lin_fit(x2,y2,unc,1,par,0);
    polyfit_res_plot(x2,y2,a,res,deg)
    data(i).a=a;siz=size(res)
    for j = 1:length(a)
        data(i).aunc(j)=sqrt(covar(j,j));
    end
    data(i).covar=covar;
    data(i).F=F;
    data(i).unc=unc;
    data(i).meanres=mean(res);
    data(i).stdres=std(res);
    data(i).res=res;
    data(i).err=err;
    data(i).errel=errel;
    data(i).chiq=chiq;
    data(i).ndof=ndof;
end