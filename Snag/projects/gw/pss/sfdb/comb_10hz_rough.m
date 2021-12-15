function y=comb_10hz_rough(x,par)
%COMB_10HZ  applies a comb filter at 10 Hz and multiples
%
%      x          input gd
%      par        parameters
%        .no50    1 -> no 50 Hz and multiples
%        .lowfr   low frequency (lower freq are cut)

if ~exist('par','var')
    par.no50=1
    par.lowfr=200;
end

len=n_gd(x);
dt=dx_gd(x);
x=y_gd(x);

dfr=1/(len*dt);
nn=10/dfr;
ii=round(1:nn:len/2);
ii(1)=0;

if par.no50 > 0
    ii(6:5:length(ii))=0;
    [a,b,ii]=find(ii);
end

ii=ii(find(ii>par.lowfr/dfr));

x=fft(x);
len1=length(x);
x=x(1:len1/2);
big=10^9;

for i = ii
    x(i-1:i+1)=x(i-1:i+1)*big;
    x(i-2)=x(i-2)*big/2;
    x(i+2)=x(i+2)*big/2;
end

x=x/big;
x(len1:-1:len1/2+2)=x(2:len1/2);
x(len1/2+1)=0;
x=ifft(x);

y=gd(x);
y=edit_gd(y,'dx',dt,'capt','combed signal');