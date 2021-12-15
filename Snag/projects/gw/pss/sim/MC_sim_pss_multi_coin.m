% MC_sim_pss_multi_coin

n=4;
N=1000000;

ga=randn(N,n);
coin=min(ga');
mu=mean(coin)
sig=std(coin)
[hcoin,hx]=hist(coin,500);hcoin=hcoin/(N*(hx(2)-hx(1)));sum(hcoin)
figure,semilogy(hx,hcoin),grid on
