function out=unif_fft_samp(in,dt,fr)
% uniform sampling
%
%   out=unif_samp(in,dt,maxfr)
%
%   in    input gd or structure (in.t in.s)
%   dt    sampling time
%   fr    [min,max] frequency in natural scale (def [0 0.125])

% Project LabMec - part of the toolbox Snag - April 2014
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

if ~exist('fr','var')
    fr=[0 0.125];
end

if isstruct(in)
    ic=1;
    t=in.t;
    s=in.s;
else
    ic=2;
    t=x_gd(in);
    s=y_gd(in);
end

[t,ii]=sort(t);
n=length(t);
s=s(ii);
T=min(t):dt:max(t)+dt;
N=length(T);
if floor(N/2)*2 < N
    N=N-1;
    T=T(1:N);
end

N2=N/2;

ss=spline(t'+(0:n-1)*0.01*dt/n,s,T); figure,plot(ss)

ff=fft(ss);

FR=round(fr*N)+1;
fprintf('N, FR : %d %d %d \n',N,FR);

if FR(1) > 1
    ff(1:FR(1))=0;
    ff(FR(1)+1)=ff(FR(1)+1)/2;
    ff(N-FR(1)+2:N)=0;
    ff(N-FR(1)+1)=ff(N-FR(1)+1)/2;
end

if FR(2) < N2
    ff(FR(2)+1:N+1-FR(2));
    ff(FR(2))=ff(FR(2))/2;
    ff(N-FR(2)+2)=ff(N-FR(2)+2)/2;
end

S=ifft(ff);

if ic == 1
    out.t=T;
    out.s=S;
    out.ss=ss;
else
    out=gd(S);
    out=edit_gd(out,'ini',T(1),'dx',dt);
end

figure,plot(T,ss),grid on,hold on,plot(T,S,'g'),plot(t,s,'r.')