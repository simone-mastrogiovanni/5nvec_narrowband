function [ps prob]=lombscargle(gin,red,res,frmax,conv)
% lombscargle  driver for lomb function (Dmitry Savransky)
%
%    gin    input gd (type 2 or type 1 with zeros)
%    red    reduction factor (integer, subsampling with mean, respect to dx_gd)
%    res    resolution (typically at least 4)
%    frmax  maximum frequency
%    conv   =1 conversion s -> days, using cont.T0;
%           =2 adds cont.T0

x=x_gd(gin);
y=y_gd(gin)-mean(gin);

if type_gd(gin) == 1
    i=find(y);
    x=x(i);
    y=y(i);
end

if conv == 1
    cont=cont_gd(gin);
    x=(x-x(1))/86400+cont.t0;
%     fprintf(' times 1,2,n : %f %f %f \n',x(1),x(2),x(length(x)));
end
if conv == 2
    cont=cont_gd(gin);
    x=(x-x(1))+cont.t0;
%     fprintf(' times 1,2,n : %f %f %f \n',x(1),x(2),x(length(x)));
end

n=length(y);
N=n;

if red > 1
    N=0;
    for i=1:red:n-red+1
        N=N+1;
        x(N)=mean(x(i:i+red-1));
        y(N)=mean(y(i:i+red-1));
    end
    x=x(1:N);
    y=y(1:N);
end

T=x(N)-x(1);%figure,plot(x)
hifac=2*T*frmax/N;
dfr=1/(T*res);
fprintf(' T = %f  dfr = %f  nfreq = %d  hifac = %f \n',T,dfr,hifac*N*res/2,hifac)

[f,ps,prob] = lomb(x,y,res,hifac);

ps=gd(ps);
ps=edit_gd(ps,'ini',dfr,'dx',dfr);
prob=edit_gd(ps,'y',prob);