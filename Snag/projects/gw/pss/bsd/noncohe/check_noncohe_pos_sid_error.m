% check_noncohe_pos_sid_error

bsd_block_0
bsd_block_1

bsd_glob_noplot=1

target0=target;

da=0.1;
dd=0.1;
na=5;
nd=4;
snrout=zeros((2*na+1),(2*nd+1));
snrout2=snrout;
maxout=snrout;
as=(-na:na)*da;
ds=(-nd:nd)*dd;

ii=0;
for i = -na:na
    ii=ii+1;
    jj=0;
    for j= -nd:nd
        jj=jj+1;
        target.a=target0.a+da*i;
        target.d=target0.d+dd*j;
        bsd_block_sid_ana
        snrout(ii,jj)=sid.datrat;
        snrout2(ii,jj)=sid.gendatrat;
        maxout(ii,jj)=max(sid.pow);
    end
end

bsd_glob_noplot=0

figure,imagesc(maxout),title('sid.pat. max'),ylabel('r.a. error'),xlabel('dec. error')
figure,plot(as,maxout),grid on,xlabel('r.a. error'),title('sid.pat. max')
figure,plot(ds,maxout'),grid on,xlabel('dec. error'),title('sid.pat. max')
figure,imagesc(snrout),title('sid.pat. snr'),ylabel('r.a. error'),xlabel('dec. error')
figure,plot(as,snrout),grid on,xlabel('r.a. error'),title('sid.pat. snr')
figure,plot(ds,snrout'),grid on,xlabel('dec. error'),title('sid.pat. snr')