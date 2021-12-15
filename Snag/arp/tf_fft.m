function out=tf_fft(gin,len,del)
% time-frequency fft
%
%   gin   input gd
%   len   fft length
%   del   pieces delay

y=y_gd(gin);
dt=dx_gd(gin);
n=n_gd(gin);

m=floor((n-len)/del)+1;
A=zeros(len,m);
i1=1;

for i = 1:m
    A(:,i)=fft(y(i1:i1+len-1));
    i1=i1+del;
end

out.A=A;