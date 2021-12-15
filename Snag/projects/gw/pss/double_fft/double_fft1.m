function out=double_fft1(gin,len,del,thr)
% double fft: 
%            - pieces the data
%            - take the ffts of the pieces
%            - take the ffts of the ffts in the other dimension
%
%   gin   input gd
%   len   fft length (seconds; if negative, samples)
%         if exist len(2) = enlagement factor with zero padded for first ft
%         if exist len(3) = enlagement factor with zero padded for second ft
%   del   pieces delay (seconds; if negative, samples)
%   thr   if exists, statistical threshold to show double fft (typically 0.001)

% Snag Version 2.0 - May 2017
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas 
% by S. Frasca - sergio.frasca@roma1.infn.it 
% Department of Physics - Sapienza University - Rome

y=y_gd(gin);
dt=dx_gd(gin);
n=n_gd(gin);

out.dt=dt;
out.n=n;

ic=is_bsd(gin);
if ic > 0
    cont=ccont_gd(gin);
    out.fr0=cont.inifr;
    out.bandw=cont.bandw;
end

if length(len) == 2
    lenpad=len(2);
    len2pad=1;
elseif length(len) == 3
    lenpad=len(2);
    len2pad=len(3);
else
    lenpad=1;
    len2pad=1;
end

if len > 0
    len0=round(len(1)/dt);
else
    len0=-len(1);
    len=len0*dt;
end

if del > 0
    del0=round(del(1)/dt);
else
    del0=-del(1);
    del=del0*dt;
end

len1=round(len0*lenpad);

out.len=len;
out.len0=len0;
out.del=del;
out.del0=del0;

m=floor((n-len1)/del0)+1;
A=zeros(len1,m);
mb=round(m*len2pad);
B=zeros(len1,mb);
i1=1;

dfr1=1/(dt*len1);
dfr2=1/(dt*del0*m);
out.dfr1=dfr1;
out.dfr2=dfr2;

yy=zeros(1,len1);

for i = 1:m
    yy(1:len1)=y(i1:i1+len1-1);
    A(:,i)=fft(y(i1:i1+len1-1));
    B(:,i)=A(:,i);
    i1=i1+del0;
end

out.A=A;

% for i = 1:len
%     B(i,:)=fft(A(i,:));
% end

B=fft(B')';

out.B=B;

if ~exist('thr','var')
    thr=0;
end
if thr > 0
    thr0=prctile(abs(A(:)),(1-thr)*100);
    
    [ii,jj]=find(A > thr0);
    zz=ii*0;
    for i = 1:length(ii)
        zz(i)=log10(abs(A(ii(i),jj(i))));
    end
    
    xx=(ii-1)*dfr1;
    yy=(jj-1)*dfr2;

    plot_triplets(xx,yy,zz,'.')
end