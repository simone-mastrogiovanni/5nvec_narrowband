% check_noncohe_pos_sid_error

bsd_block_0
bsd_block_1

% bsd_glob_noplot=1

target0=target;

da=0.01;
dd=0.01;
na=2;
nd=2;
frout=zeros((2*na+1),(2*nd+1));
sdout=frout;
snrout=frout;
snrout2=frout;
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
        bsd_block_noncohe_frsd
        frout(ii,jj)=out_nc.fr-target0.f0;
        sdout(ii,jj)=out_nc.sd-target0.df0;
        snrout(ii,jj)=sid.datrat;
        snrout2(ii,jj)=sid.gendatrat;
        pause(2)
    end
end

bsd_glob_noplot=0
figure,imagesc(frout),title('frequency error'),ylabel('r.a. error'),xlabel('dec. error')
figure,plot(as,frout),grid on,xlabel('r.a. error'),title('frequency error')
figure,plot(ds,frout'),grid on,xlabel('dec. error'),title('frequency error')
figure,imagesc(sdout),title('spin down error'),ylabel('r.a. error'),xlabel('dec. error')
figure,plot(as,sdout),grid on,xlabel('r.a. error'),title('spin down error')
figure,plot(ds,sdout'),grid on,xlabel('dec. error'),title('spin down error')