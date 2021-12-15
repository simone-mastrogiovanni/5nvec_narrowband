function [gout his xhis]=rough_nonstat(gin,ss,typ)
% rough_nonstat  rough non-stationarity analysis
%
%    gout=rough_nonstat(gin,ss)
%
%  gin   input gd
%  ss    subsampling factor
%  typ   1 = mean(abs), 2 = stdev

ss2=2*ss;
y=y_gd(gin);
n=n_gd(gin);
dx=dx_gd(gin);
ini=ini_gd(gin);
ii=0;

switch typ
    case 1
        for i = 1:ss:n-ss2
            jj=find(y(i:i+ss2-1));
            ii=ii+1;
            if ~isempty(jj)
                y(ii)=mean(abs(y(i+jj-1)));
            else
                y(ii)=0;
            end
        end
    case 2
        for i = 1:ss:n-ss2
            jj=find(y(i:i+ss2-1));
            ii=ii+1;
            if ~isempty(jj)
                y(ii)=std(y(i+jj-1));
            else
                y(ii)=0;
            end
        end
end
   
y=y(1:ii);
gout=edit_gd(gin,'y',y,'dx',dx*ss,'ini',ini+ss*dx);
[his xhis]=hist(y,200);
