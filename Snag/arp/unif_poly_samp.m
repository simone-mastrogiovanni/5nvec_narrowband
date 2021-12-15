function out=unif_poly_samp(in,dt,len,deg)
% polynomial uniform sampling
%
%   out=unif_samp(in,dt,len,deg)
%
%   in    input gd or structure (in.t in.s)
%   dt    sampling time
%   len   sub-pieces length
%   deg   degree

% Project LabMec - part of the toolbox Snag - April 2014
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

warning('off','all');

if isstruct(in)
    ic=1;
    t=in.t;
    s=in.s;
else
    ic=2;
    t=x_gd(in);
    s=y_gd(in);
end

if floor(len/4)*4 < len
    len=round(len/4)*4;
    fprintf(' *** New len : %d\n',len);
end

[t,ii]=sort(t);
n=length(t);
s=s(ii);
T=min(t):dt:max(t)+dt;
N=length(T);
S=T*0;

for i = 1:len/2:n-len/2
    ifin=min(n,i+len-1);
    tt=t(i:ifin);
    ss=s(i:ifin);
    ll=length(tt);
    c1=len/4+1;
    c2=min(3*len/4+1,ll);
    if i == 1
        c1=1;
    end
    [mm i1]=min(abs(T-tt(c1)));
    [mm i2]=min(abs(T-tt(c2)));
    p=polyfit(tt,ss,deg);
    S(i1:i2)=polyval(p,T(i1:i2));
    
end

% ff=fft(S);
% fr=[0,0.0004];
% FR=round(fr*N)+1;
% fprintf('N, FR : %d %d %d \n',N,FR);
% 
% if FR(1) > 1
%     ff(1:FR(1))=0;
%     ff(FR(1)+1)=ff(FR(1)+1)/2;
%     ff(N-FR(1)+2:N)=0;
%     ff(N-FR(1)+1)=ff(N-FR(1)+1)/2;
% end
% 
% if FR(2) < N/2
%     ff(FR(2)+1:N+1-FR(2));
%     ff(FR(2))=ff(FR(2))/2;
%     ff(N-FR(2)+2)=ff(N-FR(2)+2)/2;
% end
% 
% S1=ifft(ff);

out.T=T;
out.S=S;

figure,plot(T,S),grid on,hold on,plot(t,s,'r.')%,plot(T,S1,'g')