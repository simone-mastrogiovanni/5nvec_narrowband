function out=show_ptable(pt,basic_info,job_info)
% info about a peak table
%
%   pt          peak table
%   basic_info  basic run info
%   job_info    peak table info (if exist)

if exist('job_info','var')
    icjob=1;
else
    icjob=0;
end

out=struct();

t0=floor(pt(1,1));
figure,plot(pt(1,:)-t0,pt(2,:),'.')
hold on,grid on
ii=find(pt(4,:)>0);
plot(pt(1,ii)-t0,pt(2,ii),'r.')
title('peaks (red non-zero)')
xlabel('days'),ylabel('Hz')

N=length(pt);
out.npeaks=N;
pt1=zeros(N,3);
pt1(:,1)=pt(1,:)-floor(pt(1,1));
pt1(:,2)=pt(2,:);

pt1(:,3)=pt(5,:);
color_points(pt1,0,{'Wiener weights' 'days' 'Hz'})
pt1(:,3)=pt(3,:);
color_points(pt1,0,{'CR' 'days' 'Hz'})
pt1(:,3)=pt(4,:);
color_points(pt1,0,{'Noise weights' 'days' 'Hz'})

minfr=min(pt(2,:));
maxfr=max(pt(2,:));
dfr=basic_info.run.fr.dnat/basic_info.mode.hm_job.frenh;
xfr=minfr:dfr:maxfr;
hfr=hist(pt(2,:),xfr);
figure,stairs(xfr,hfr),grid on,title('frequency distribution'),xlabel('Hz')
xlim([minfr maxfr]);
hfr=gd(hfr);
hfr=edit_gd(hfr,'ini',minfr,'dx',dfr);
out.hfr=hfr;

ii=find(pt(4,:));
N=length(ii);
out.nonzeropeaks=N;
out.meanwienerweights=mean(pt(5,:));
pt1=zeros(N,3);
pt1(:,1)=gmst(pt(1,ii));
pt1(:,2)=pt(2,ii);
pt1(:,3)=pt(5,ii);
color_points(pt1,0,{'Wiener' 'sid hours' 'Hz'})

ii=find(pt(5,:) == 0);
N=length(ii);
out.zeropeaks=N;
if N > 0
    pt1=zeros(N,3);
    pt1(:,1)=pt(1,ii)-floor(pt(1,1));
    pt1(:,2)=pt(2,ii);
    pt1(:,3)=pt(3,ii);
    color_points(pt1,0,{'Zeroes' 'days' 'Hz'})
end

nfr=diff(basic_info.index);
figure,stairs(nfr),title('number of peaks for fft')
[hnfr xnfr]=hist(nfr,200);
figure,plot(xnfr,hnfr,'.'),grid on,title('number of peaks for fft')
% figure,stairs(xnfr,hnfr),grid on,title('number of peaks for fft')
[h2 x2]=hist(pt(2,:),100);
figure,stairs(x2,h2),grid on,title('frequencies distribution')
[h3 x3]=hist(pt(3,:),100);
figure,stairs(x3,log10(h3)),grid on,title('CR distribution (log10)')
[h4 x4]=hist(pt(4,:),100);
figure,stairs(x4,h4),grid on,title('noise weights distribution')
[h5 x5]=hist(pt(5,:),100);
figure,stairs(x5,h5),grid on,title('wiener weights distribution')

plot(basic_info.gsp),title('Very short power spectrum'),xlabel('days'),ylabel('Hz')

if icjob == 1
    figure,plot(job_info.sidpat),title('Received power'),xlabel('Greenwich sidereal hours')
    xlim([0 24])
end