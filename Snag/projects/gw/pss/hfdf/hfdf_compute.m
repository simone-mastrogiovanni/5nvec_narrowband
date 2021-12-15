function out=hfdf_compute(run,par)
% computing evaluation for hfdf
%
%  run     run structure (ex.: VSR2(1))
%  par     parameters [N t icpl]:
%           N: total number of candidates (def 100 M)
%           frenh: frequency enhancemet (def 10)
%           t: basic computation time in s (1 Hz, 1 sky point, def. 10)
%           icpl: =1 plots (def 1)

% Version 2.0 - October 2013 
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "La Sapienza" - Rome

if ~exist('par','var')
    par=[100000000 10 10 1];
end
fr=run.anaband(1):run.anaband(3):run.anaband(2);
nfr=length(fr);
Nd=ceil(1.06e-4*(fr+run.anaband(3))/run.fr.dnat); % NOTA: forse 2e-4

nskypoint=fr*0;
maxbeta=nskypoint;
minbeta=nskypoint;
ncandtot=par(1);
nskymin=1000;
njob=nskypoint;
jjj=0;

for i = 1:nfr
%     [x,b]=pss_optmap_1(Nd(i));
    [x,b,index,nlon]=pss_optmap(Nd(i));
    nskypoint(i)=length(x);
    nbeta(i)=length(b);
    x2=diff(sort(x(:,2)));
    ii=find(abs(x2)>1.e-8);
    x2=x2(ii);
    maxbeta(i)=max(x2);
    minbeta(i)=min(x2);
    
    n1=1;
    k=0;
    n2=0;
    jj=0;

    while n2 < nskypoint(i)
        jj=jj+1;
        jjj=jjj+1;
        n=0;
        while n < nskymin && k < nbeta(i)  % Da sistemare per ridurre il numero di skypoint
            k=k+1;
            n=n+nlon(k);
        end
        n2=n2+n;
        if n2 >= nskypoint(i)
            n2=nskypoint(i);
        end
        lenjob(jjj)=n2-n1+1;
    %     patches=x(n1:n2,:);
    %     job=sprintf('%s_%04d_%03d_%07.3f_%07.3f_',runstr.run,frmin,jj,x(n1,2),x(n2,2));
    %     disp(sprintf('job %d  %s %d %d  npoint = %d',jj,job,n1,n2,n2-n1+1))
    %     job_pack=struct();
    %     job_pack.job=job;
    %     job_pack.patches=patches;
    %     jobname=['in_' job '.mat'];
    %     save(jobname,'job_pack')
    %     pause(0.5)
        n1=n2+1;
    end
    njob(i)=jj;
end

M=length(fr);

out.nband=M;
out.nfrperband=run.anaband(3)*par(2)/run.fr.dnat;
out.Ndoppler=Nd;
out.nskypoint=nskypoint;
out.tot=sum(nskypoint);
out.tot=sum(nskypoint);
out.nbeta=nbeta;
out.fr=fr;
out.nsubjobs=nbeta;
out.subjobstime=par(2)*out.nskypoint./(out.nbeta*60);
out.totsubjobs=sum(nbeta);
out.totbands=nfr;
out.tothours=par(2)*out.tot/3600;
out.njob=njob;
out.totjobs=sum(njob);
out.lenjob=lenjob;

lowfrenh=(1./fr)/(1/fr(nfr));
%lowfrenh=lowfrenh/sum(lowfrenh);
ncand=lowfrenh.*nskypoint;
ncand=ncandtot*ncand/sum(ncand);
out.ncandtot=sum(ncand);
kcand=round(ncand./nskypoint);
out.ncand=round(ncand);
out.kcand=kcand;

if par(3)  
    figure,plot(fr,Nd),grid on,title('Number of frequency bins in the Doppler band')
    hold on,plot(fr,Nd,'r.')
    xlabel('Hz')

    if nskypoint(M)/nskypoint(1) > 40
        figure,semilogy(fr,nskypoint),grid on,title('Number of sky points');
        hold on,semilogy(fr,nskypoint,'r.')
    else
        figure,plot(fr,nskypoint),grid on,title('Number of sky points');
        hold on,plot(fr,nskypoint,'r.')
    end
    xlabel('Hz')

    figure,plot(fr,minbeta),grid on
    hold on,plot(fr,maxbeta,'r'),grid on,title('Min, Max dbeta');
    xlabel('Hz')

    figure,plot(fr,out.subjobstime),grid on,title('Sub-job time');
    hold on,plot(fr,out.subjobstime,'r.')
    xlabel('Hz'),ylabel('minutes')

    figure,plot(fr,out.ncand),grid on,title(sprintf('candidates per %d Hz',run.anaband(3)));
    hold on,plot(fr,out.ncand,'r.')
    xlabel('Hz')

    figure,plot(fr,kcand),grid on,title('candidates per hm');
    xlabel('Hz'),hold on,plot(fr,kcand,'r.')
    
    figure,plot(fr,njob),grid on,title(sprintf('jobs per %d Hz',run.anaband(3)));
    xlabel('Hz'),hold on,plot(fr,njob,'r.')
    
    figure,hist(lenjob,50),title('hist of length of the jobs')
    
    figure,plot(lenjob,'.'),grid on,title('length of the jobs')
end