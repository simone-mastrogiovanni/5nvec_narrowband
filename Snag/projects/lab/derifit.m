function data=derifit(x,y,unc,ord)
% derivata col fit
%
%   x,y     input data
%   unc     uncertainty on y data (costant)
%   ord     order of derivative (def 1)
% 
%   data(i).iclog    iclog
%   data(i).x        the x of the selection
%   data(i).y        the y      
%   data(i).a        the polynomial coefficients (starting from higher power)  
%   data(i).aunc     uncertainty on the polynomial coefficients
%   data(i).F        base functions
%   data(i).res      the residuals
%   data(i).err      the mean square error
%   data(i).errel    the relative error
%   data(i).chiq     chi square
%   data(i).ndof     number of degrees of freedom
%
%   data(i).dord     order of derivative
%   data(i).dy       derivative of y
%   data(i).da       coefficients of the derivative

if ~exist('ord','var')
    ord=1;
end

str=sprintf('Derivata di ordine %d',ord);

figure,plot(x,y),str
data = data_polyfit(x,y,unc);

[n,nn]=size(data);

for i = 1:n
    data(i).dord=ord;
    a=data(i).a;
    x=data(i).x;
    for j = 1:ord
        a=polyder(a);
    end
    data(i).da=a;
    dy=polyval(a,x);
    data(i).dy=dy;
    figure;plot(x,dy),hold on,grid on,plot(x,dy,'r.'),title(str)
end

