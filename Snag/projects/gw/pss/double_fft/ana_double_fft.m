function out=ana_double_fft(dfft_str,minsd,sdres,nsd)
% analyzes a double_fft output
%
%        out=ana_double_fft(dfft_str,minsd,sdres,nsd)
%
%    dfft_str   double_fft output structure
%    minsd      minimum sd value (in units of natural step)
%    sdres      sd resolution (in units of natural step)
%    nsd        number of sd resolution steps

% Snag Version 2.0 - May 2017
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas 
% by S. Frasca - sergio.frasca@roma1.infn.it 
% Department of Physics - Sapienza University - Rome

out=dfft_str;
T0=out.dt*out.n;

aa=sum(abs(dfft_str.B(:,:)').^2);
figure,plot(aa),grid on,title('sum on vertical frequencies')

[mm,ii]=max(aa);
out.ifr1=ii;
out.fr1=out.fr0+(ii-1)*out.dfr1;

vvt=dfft_str.A(ii,:);
vv=dfft_str.B(ii,:);
spz=abs(vv).^2;
out.vvt=vvt;
N=length(vvt);
out.vv=vv;
out.spzoom=spz;

[mm,ii]=max(spz);
out.fr2=out.fr1+(ii-1)*out.dfr2;

dsd0=out.dfr1/T0;
dsd=dsd0/sdres;
out.dsd0=dsd0;
out.dsd=dsd;
DT=out.del;

disp(sprintf(' min, max, step = %f  %f  %f ',minsd,minsd+nsd/sdres, 1/sdres))
disp(sprintf(' min, max, step = %e  %e  %e ',dsd0*minsd,dsd0*(minsd+nsd/sdres), dsd0/sdres))

figure,semilogy(spz),grid on,title('zoom spectrum of max spectr')

DSD=dsd*((0:N-1)*DT);
sd1=minsd*dsd0*((0:N-1)*DT);
dph=cumsum(DSD)*DT*2*pi;
ph1=cumsum(sd1)*DT*2*pi;
corr1=exp(-1j*ph1);
dcorr=exp(-1j*dph);

C=zeros(nsd,N);
corr=corr1;

for i = 1:nsd
    C(i,:)=vvt.*corr;
    corr=corr.*dcorr;
end

C=fft(C')';

out.C=C;

aC=abs(C).^2;
figure,plot(aC'),grid on

[aa,ii]=max(aC');
figure,plot(aa),grid on,hold on,plot(aa,'r.')
[aaa,iii]=max(aa);
figure,plot(aC(iii,:))

[aa,ii]=max(aa);

out.sd=minsd*dsd0+(ii-1)*dsd;

if isfield(out,'typesid')
    Tsid=86164.090530833; % at epoch2000
    ksid=out.ksid;
    ksid5=5*ksid;
    mb1=out.mb+ksid5;
    vv(out.mb+1:mb1)=vv(1:ksid5);
    b=zeros(1,4*ksid+1);
    b(1)=1;
    b(1+493)=1;
    b(1+2*493)=1;
    b(1+3*493)=1;
    b(1+4*493)=1;
    avv=abs(vv).^2;
    y=filter(b,1,avv);
    y=y(2*ksid+1:2*ksid+out.mb);
    figure,plot(y),grid on
    [mm,ii]=max(y);
    out.fr3=(ii-1)*out.dfr2+out.fr1;
end

if isfield(out,'bsdin')
%     bsd0=out.bsdin;
%     
%     sd=vfs_spindown(gdpar,sdpar,1);
% 
%     out=vfs_subhet(out,sd);
end