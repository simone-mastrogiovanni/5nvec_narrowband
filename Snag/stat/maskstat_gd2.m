function gout2=maskstat_gd2(gin2,const,thrmin,thrmax,thrtyp)
% maskstat_gd2  masks a gd2 with a constant value with certain thresholds
%
%       gin2           input gd2
%       const          constant (def = 0)
%       thrmin,thrmax  thresholds (if absent, interactive
%       thrtyp         threshold type (1 amp (def), 2 prob)

if ~exist('const','var')
    const=0;
end

if ~exist('thrtyp','var')
    thrtyp=1;
end

if ~exist('thrmax','var')
    M=y_gd2(gin2);
    [h,xout] = hist(M(:),200);
    figure,plot(xout,h),grid on
    answ=inputdlg({'thrmin' 'thrmax' 'thrtype (1 amp, 2 prob)'},'Thresholds and threshold type',1,{num2str(min(xout)) num2str(max(xout)) '1'});
    thrmin=eval(answ{1});
    thrmax=eval(answ{2});
    thrtyp=eval(answ{3});
end

if thrtyp == 2
    MM=sort(M(:));
    nn=length(MM);
    thrmin=max(1,MM(round(thrmin*nn)));
    thrmin=MM(thrmin);
    thrmax=max(1,MM(round(thrmax*nn)));
    thrmax=MM(thrmax);
end
thrmin,thrmax
[i1 i2]=find(M < thrmin | M > thrmax);
M(i1,i2)=const;

gout2=edit_gd2(gin2,'y',M);