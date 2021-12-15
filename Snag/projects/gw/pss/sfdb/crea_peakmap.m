function crea_peakmap(sblfil,thresh,typ)
%CREA_PEAKMAP  creates a peakmap file from a sfdb file
%
%  sblfil    sfdb file
%  thresh    threshold
%   typ      ttype (0 -> normal with amplitude, 1 -> compressed with amplitude),
%                   2 -> normal binary, 3 -> compressed binary)

%% TO BE DONE: AUMENTO RISOLUZIONE e tipi 1,2,3

sbl_=sbl_open(sblfil);
vbl_=sbl_;

vbl_.ch(4).name='peak map';

lenbl=sbl_.blen;
bias0=sbl_.point0;
bias1=zeros(1,4);
for i = 1:4
    bias1(i)=sbl_.ch(i).bias;
end
ndat=sbl_.ch(4).lenx;

if typ == 0
    vbl_.ch(4).type=4;
    vbl_=sbl_openw('peakmap.sbl',vbl_);
else
    vbl_=vbl_openw('peakmap.vbl',vbl_);
end

fid=vbl_.fid;
sbhead=zeros(1,2);

for i = 1%:sbl_.len
    i
    bias01=bias0+(i-1)*lenbl;
    
    bias=bias01+bias1(1);
    fseek(sbl_.fid,bias-24,'bof');
    sbloc=fread(sbl_.fid,8,'char');
    tbl=fread(sbl_.fid,1,'double');
    sbl_headblw(fid,i,tbl);
    
    sbhead=fread(sbl_.fid,2,'double');
    par=fread(sbl_.fid,sbl_.ch(1).lenx,'double');
    sbl_write(fid,sbhead,6,par);
    
    sbhead=fread(sbl_.fid,2,'float');
    ps=fread(sbl_.fid,sbl_.ch(2).lenx,'float');
    sbl_write(fid,sbhead,4,ps);
    
    sbhead=fread(sbl_.fid,2,'float');
    omp=fread(sbl_.fid,sbl_.ch(3).lenx,'float');
    sbl_write(fid,sbhead,4,omp);
    
    b=fread(sbl_.fid,ndat*2,'float');
    b=b(1:2:2*ndat)+j*b(2:2:2*ndat);
    a=b.*conj(b);
    
    b=ps_autoequalize(a.',64,0);plot(b)
    c=zeros(1,ndat); %disp('ok')
    
    for k = 2:(ndat-1)
        if b(k) >= thresh
            if b(k-1) < b(k)
                if b(k+1) < b(k)
                    c(k)=a(k);disp(k)
                end
            end
        end
    end

    sbl_write(fid,sbhead,4,c);
end
