function thr=final_clean(gin,ein)

%load(eval('inputname'));
%filname=fliplr(strtok(fliplr(inputname),'/'));
%gdname=strtok(filname,'.')
if ein == 1
    xr1=-7;
    xr2=3;
elseif ein == 0
    xr1=-27;
    xr2=-7;
else
    fprintf('Error in ein. Choose ein=1 (data are in units of 10^(-20) or ein=0 (data are in natural units)\n');
end
%y=y_gd(eval(gdname));
y=y_gd(gin);
yy=log10(abs(real(y)));
if ~exist('xrange','var');
    dxrange=0.01;
    xrange=xr1:dxrange:xr2;
end
[hist_value hist_pos]=hist(yy,xrange);
hist_value=hist_value(2:length(hist_value)-1);
hist_pos=hist_pos(2:length(hist_pos)-1);
figure;plot(hist_pos,hist_value);

[max_value max_pos]=max(hist_value);

diff_value=diff(hist_value(max_pos:length(hist_value)));
%figure;plot(diff_value);

[min_diff_value min_diff_pos]=min(diff_value);


final_pos=xrange(1)+(max_pos+min_diff_pos)*dxrange;
if ein == 1
    logthr=final_pos+.15*abs(final_pos);
elseif ein == 0
    logthr=final_pos+.01*abs(final_pos);
    %logthr=final_pos;
end
thr=10^logthr;

%gdname = varname(gin)
%filnamfull=strcat(gdname,'_ampdist.mat');
%save(filnamfull,'hist_pos','hist_value','diff_value','thr');
