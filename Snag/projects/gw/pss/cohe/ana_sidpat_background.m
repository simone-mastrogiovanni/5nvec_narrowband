function [spb_bg_mean,spb_bg_std_r,spb_bg_std_i]=ana_sidpat_background(sidpat_base,N,icpl)
% computes the background bias for ana_sidpat
%
%   sidpat_base  sidpat_base 
%   N            montecarlo dimensionality
%   icpl         > 0 plot; def 0

% Snag Version 2.0 - January 2019
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by O.J.Piccinni and S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

if ~exist('icpl','var')
    icpl=0;
end
[ne,np]=size(sidpat_base.s0);
spb_bg_mean=zeros(ne,np);
spb_bg_std=zeros(ne,np);
spb_fitn=zeros(ne,np,N);

s0=sidpat_base.s0;
s1=sidpat_base.s1;
s2=sidpat_base.s2;
s3=sidpat_base.s3;
s4=sidpat_base.s4;

s1n=sidpat_base.s1n;
s2n=sidpat_base.s2n;
s3n=sidpat_base.s3n;
s4n=sidpat_base.s4n;

for k = 1:N
    R=exprnd(1,1,100);
    ff=fft(R);
    sidpat0=ff(1:5);
    for i = 1:ne
        for j = 1:np
            sidpatn=[1,s1n(i,j),s2n(i,j),s3n(i,j),s4n(i,j)];
            spb_fitn(i,j,k)=sidpat0(2:5)*sidpatn(2:5)';
        end
    end
end

for i = 1:ne
    for j = 1:np
        spb_bg_mean(i,j)=mean(spb_fitn(i,j,:));
        spb_bg_std_r(i,j)=std(real(spb_fitn(i,j,:)));
        spb_bg_std_i(i,j)=std(imag(spb_fitn(i,j,:)));
    end
end

if icpl > 0
    figure,imagesc(real(spb_bg_mean)),title('background mean real') 
    figure,imagesc(spb_bg_std_r),title('background std real') 
    figure,hist(real(spb_bg_mean(:)),200),title('background mean real') 
    figure,hist(spb_bg_std_r(:),200),title('background std real') 
    
    figure,imagesc(imag(spb_bg_mean)),title('background mean imag')  
    figure,imagesc(spb_bg_std_i),title('background std imag') 
    figure,hist(imag(spb_bg_mean(:)),200),title('background mean imag') 
    figure,hist(spb_bg_std_i(:),200),title('background std imag') 
end