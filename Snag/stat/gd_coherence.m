function c=gd_coherence(d1,d2,n,res)
% GD_COHERENCE  coherence function for equisampled (and equi-length) data
%               if the data are real, only positive frequency
%
%       c=gd_coherence(d1,d2,n)
%
% Computes  c=S_xy/sqrt(S_x*S_y)
%
%   d1,d2   input equisampled data (gds or arrays)
%   n       number of subsets (default 16)
%   res     resolution (def 1)
%
%   c       coherence (gd)

% Version 2.0 - January 2007
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

if ~exist('n','var')
    n=16;
end

if ~exist('res','var')
    res=1;
end

dx1=1;
dx2=1;
if isa(d1,'gd')
    dx1=dx_gd(d1);
    d1=y_gd(d1);
    dx2=dx_gd(d2);
    d2=y_gd(d2);
end

% d1=d1(:);
% d2=d2(:);

if dx1 ~= dx2
    disp('*** different sampling time')
    return
end

l1=length(d1);
l2=length(d2);
l=min(l1,l2);

ll=floor(l/n);

icreal=isreal(d1)*isreal(d2);

llr=ll*res;
s1=zeros(llr,1);
s2=s1;
s12=s1;

for i = 1:n
    x1=d1((i-1)*ll+1:i*ll);
    x2=d2((i-1)*ll+1:i*ll);
    x1(ll+1:llr)=0;
    x2(ll+1:llr)=0;
    f1=fft(x1);
    f2=fft(x2);%size(s1),size(f1)
    s1=s1+abs(f1).^2;
    s2=s2+abs(f2).^2;
    s12=s12+conj(f1).*f2;
end
s1=s1/n;
s2=s2/n;
s12=abs(s12)/n;

%figure,semilogy(s1,'b'),hold on,semilogy(s2,'r'),semilogy(s12,'g')
c=real(s12)./sqrt(s1.*s2);
if icreal > 0
    c=c(1:floor(length(c)/2));
end

c=gd(c);
df=1/(llr*dx1);
c=edit_gd(c,'dx',df,'capt','coherence');
figure,plot(c)
