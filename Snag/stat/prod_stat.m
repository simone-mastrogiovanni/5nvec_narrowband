function st=prod_stat(N,sigs,nprod,ic)
% statistics of the spectral products
%
%    st=prod_stat(N,sigs)
%
%   N      simulation dimension
%   sigs   signal amlitudes
%   nprod  number of spctra to be multiplied
%   ic     > 0 -> plot

% Version 2.0 - July 2016
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

n=length(sigs);
st=zeros(2,n);
prc=zeros(5,n);
sigmax=max(sigs);
x=0:0.1:2*sigmax^2;
figure,hold on

for i = 1:n
    R=ones(1,N);
    for j = 1:nprod
        R=R.*ncx2rnd(2,2*sigs(i).^2,1,N)/2;
    end
    R=R.^(1/nprod);
    h=hist(R,x);
%     stairs(x,h)
    semilogy(x,h)
    st(1,i)=mean(R);
    st(2,i)=std(R);
    prc(1,i)=prctile(R,10);
    prc(2,i)=prctile(R,25);
    prc(3,i)=prctile(R,50);
    prc(4,i)=prctile(R,75);
    prc(5,i)=prctile(R,90);
end

if ic > 0
%     figure,plot(sigs,st'),grid on
%     title(sprintf('nprod = %d ',nprod)),xlabel('signal amplitude'),ylabel('mean and st.dev.')
    figure,semilogy(sigs,st'),grid on
    title(sprintf('nprod = %d ',nprod)),xlabel('signal amplitude'),ylabel('mean and st.dev.')
    figure,semilogy(sigs,prc'),grid on
    title(sprintf('nprod = %d ',nprod)),xlabel('signal amplitude'),ylabel('percentiles')
end