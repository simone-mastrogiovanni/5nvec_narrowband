function out_final=generate_data_no_dop(filein,dtout)

sbl_=sbl_open(filein);
sfdb09_us=read_sfdb_userheader(sbl_);

if ~exist('enh','var')
    enh=8;
end
if ~exist('tint','var')
    tint=[0 1e6];
end
if length(tint) == 1
    tint=[0 1e6];
end

k=1;

while 1
    [M,t1]=sbl_read_block(sbl_,[1 2]);
    if k==1
        t0=t1;
    end
    if t1 < tint(1)
        t2=t1;
        continue;
    end
    if t1 > tint(2)
        break;
    end
    
    if t1 == 0
        break
    end
    dfr=sbl_.ch(1).dx;
    lenx=sbl_.ch(1).lenx;
    basefr=sbl_.ch(1).inix;
    lfftin=sfdb09_us.nsamples*2;
    
    ifr1=round(basefr/dfr)+1;
    ifr2=ifr1+lenx-1;
    lmin=ifr2*enh;
    
    lfftout=ceil(lmin/lfftin)*lfftin;
    
    n2=lfftout/2;
    
    dtin=sfdb09_us.tsamplu;
    lfftenh=lfftout/lfftin;
    
    
    dtin1=dtin/lfftenh;
    time=dtin1*(0:n2-1);
    
    sfdb09_us=read_sfdb_userheader(sbl_);
    
    infft=zeros(1,lfftout);
    infft(ifr1:ifr2)=M{1};
    chunk1=2*ifft(infft)*lfftenh;
    out=strobo(chunk1(1:n2),time,dtout);
    if k==1
        out_final=out;
    else
        out_final=[out_final,out];
    end
        k=k+1

 end


end

function out=strobo(x,tt,dtout)
tt=tt/dtout;
tt1=floor(tt);
ii=find(diff(tt1));
out=x(ii+1);
end
