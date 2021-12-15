function [cand,job_info,checkF]=bsd_cand(hmap,proc_info,job_info,kcand)
% finds peaks in the hough map
%
%   [cand,job_info,checkF]=bsd_cand(hmap,proc_info,job_info,kcand)
%
%    hmap        hough map
%    proc_info
%    job_info
%    kcand       number of primary candidates to be found
%
%    cand(9,N)   [fr lam bet sd amp CR dlam dbet typ]
%    job_info    job info structure
%    checkF      service structure for test and debug

% Snag Version 2.0 - January 2017
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by O.J.Piccinni and S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

tic
checkF=struct();

job_info.proc.F_bsd_cand.vers='170230';
job_info.proc.F_bsd_cand.kcand=kcand;
job_info.proc.F_bsd_cand.tim=datestr(now);

mode=proc_info.peak_mode;
job_info.proc.F_bsd_cand.mode=mode;
if mode == 2
    mno=proc_info.hm.fr(3)*4;
    job_info.proc.F_bsd_cand.mno=mno;
end
frini=proc_info.hm.fr(1);
frfin=proc_info.hm.fr(4);
cand=zeros(9,kcand);

g=cut_gd2(hmap,[frini,frfin],[-100,100],1);
y=y_gd2(g);
fr=x_gd2(g);
sd=x2_gd2(g);
[ym,im]=max(y');
N=length(ym);
df=N/kcand;
ix=round(1:df:N);
ix=[ix N+1];
robst=robstat(y(:),0.01);
job_info.robst=robst;
robmedtot=robst(1);
robmed=zeros(1,kcand);
robstd=robmed;

checkF.ix=ix;

for i = 2:kcand-1
%     disp(sprintf('%d %d %d %d',i,ix(i-1),ix(i+2)-1,length(ym)))
    robst=robstat(ym(ix(i-1):ix(i+2)-1),0.01);
    robmed(i)=robst(1);
    robstd(i)=robst(2);
end
robst=robstat(ym(ix(1):ix(3)-1),0.01);
robmed(1)=robst(1);
robstd(1)=robst(2);
ii=length(ix);
robst=robstat(ym(ix(ii-2):ix(ii)-1),0.01);
robmed(kcand)=robst(1);
robstd(kcand)=robst(2);
job_info.robmed=robmed;
job_info.robstd=robstd;

jj=0;
for i = 1:kcand
    if robmed(i) > 0
        ii=ix(i);
        yy=ym(ix(i):ix(i+1)-1);
        [ma,ima]=max(yy);
        if ma > robmed(i) && ma > robmedtot/2
            jj=jj+1;
            iii=ii+ima-1;
            cand(1,jj)=fr(iii);
            cand(2,jj)=job_info.patch(1);
            cand(3,jj)=job_info.patch(2);
            cand(4,jj)=sd(im(iii));
            cand(5,jj)=ma;
            cand(6,jj)=(ma-robmed(i))/robstd(i);
            cand(7,jj)=job_info.patch(3)/2;
            cand(8,jj)=abs(job_info.patch(4)-job_info.patch(5))/4;
            cand(9,jj)=1;
            if mode == 2
                i1=max(ima-mno,1);
                i2=min(ima+mno,length(yy));
                yy(i1:i2)=0;
                [ma1,ima1]=max(yy);
                if abs(ima1-ima) > 2*mno
                    if ma1 > robmed(i)
                        jj=jj+1;
                        iii=ii+ima1-1;
                        cand(1,jj)=fr(iii);
                        cand(2,jj)=job_info.patch(1);
                        cand(3,jj)=job_info.patch(2);
                        cand(4,jj)=sd(im(iii));
                        cand(5,jj)=ma1;
                        cand(6,jj)=(ma1-robmed(i))/robstd(i);
                        cand(7,jj)=job_info.patch(3)/2;
                        cand(8,jj)=abs(job_info.patch(5)-job_info.patch(4))/4;
                        cand(9,jj)=2;
                    end
                end
            end
        end
    end
end

cand(4,:)=correct_sampling(cand(4,:),0,proc_info.hm.sd(2));
job_info.ncand=jj;
job_info.proc.F_bsd_cand.duration=toc;
