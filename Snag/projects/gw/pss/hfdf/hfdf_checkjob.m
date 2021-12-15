function out=hfdf_checkjob(folder,out_0)
% checks output files created by HFDF_JOB
%
%   folder     jobs output folders
%   out_0      output structure created by hfdf_checkjob_0
%              if present, checks the presence of all the due files

if ~exist('out_0','var')
    icbj=0;
else
    icbj=1;
end
missing={};
icmiss=0;
folder=uigetdir(folder);
cd(folder)

list=dir('job_summary*');

out.folder=folder;
out.list=list;

nfil=length(list);
ncand=zeros(1,nfil);
npatches=ncand;
band=ncand;
tottim=ncand;
vkjob=ncand;
jnamekjob1=0;
totjob=0;

for i = 1:nfil
    if floor(i/100)*100 == i
        fprintf('%d files read \n',i)
    end
    name=list(i).name;
    jname=dec_jobname(name,12);
    jnamefrin=jname.frin;
    jnamekjob=jname.kjob;
    vkjob(i)=jnamekjob;
    a=load(name);
    fiel=fieldnames(a);
    fiel=fiel{1};
    eval(['struc=a.' fiel ';']);
    if i == 1
        jobname=struc.jobname;
        vrun=jobname(1:4);
%         setpp=str2num(jobname(6:7));
        eval(['run=' vrun '(' jobname(6:7) ');']);
        anaband=run.anaband;
        comp=hfdf_compute(VSR4(1),[100 10 0]);
        fr=comp.fr;
%         if icbj == 0 & isfield(struc,'bandjobs')
%             icbj=2;
%         endif 
        if icbj == 1
            frin=out_0.fr(1)-1;
            ifrin=0;
            alljobs=sum(out_0.bandjobs);
        end
    end
    
    if icbj == 1
        while jnamefrin > frin
            if jnamekjob1 < totjob
                s=sprintf(' *** job with frin < %d missing ',jnamefrin);
                disp(s)
                icmiss=icmiss+1;
                missing{icmiss}=s;
            end
            ifrin=ifrin+1;
            frin=out_0.fr(ifrin);
            totjob=out_0.bandjobs(ifrin);
            kjob=0;
        end
        jnamekjob1=jnamekjob;
        kjob=kjob+1;
        if kjob < jnamekjob
            s=sprintf('band %d : jobs %d - %d missed ',frin,kjob,jnamekjob-1);
            disp(s)
            icmiss=icmiss+1;
            missing{icmiss}=s;
            kjob=jnamekjob;
        end
        if kjob > jnamekjob
            s=sprintf('band %d : problems with job %d  (%d) ',frin,kjob,jnamekjob);
            disp(s)
            icmiss=icmiss+1;
            missing{icmiss}=s;
        end
    end
        
    ncand(i)=struc.ncand;
    npatches(i)=struc.npatches;
    band(i)=struc.band(1);
    tottim(i)=struc.proctim.HFDF_JOB.duration;
end

out.ncand=ncand;
out.npatches=npatches;
out.band=band;
out.kjob=vkjob;
out.tottim=tottim;
out.missing=missing;

figure,plot(band,ncand,'.'),title('ncand vs band'),grid on
figure,plot(band,tottim./npatches,'.'),title('tottim/npatch vs band'),grid on
figure,plot(ncand,tottim./npatches,'.'),title('tottim/npatch vs ncand'),grid on

if icbj == 1
    nmiss=alljobs-nfil;

    fprintf('\n  %d jobs done;  %d missing \n\n',nfil,nmiss)
    for i = 1:icmiss
        disp(missing{i})
    end
end

[bband,ia,ic]=unique(band);
ia=[ia; length(band)+1];
nncand=bband*0;
for i = 1:length(bband)
    nncand(i)=sum(ncand(ia(i):ia(i+1)-1));
    ttottim(i)=sum(tottim(ia(i):ia(i+1)-1));
    nnpatches(i)=sum(npatches(ia(i):ia(i+1)-1));
end

figure,plot(band,tottim,'.'),title('job times vs frequency'),grid on
figure,plot(bband,nncand,'.'),title('ncand vs band'),grid on
figure,plot(bband,ttottim,'.'),title('time vs band'),grid on
figure,plot(bband,nnpatches,'.'),title('patches vs band'),grid on
figure,plot(bband,ttottim./nnpatches,'.'),title('time/patch vs band'),grid on

out.bband=bband;    
out.nncand=nncand;
out.nnpatches=nnpatches;
out.ttottim=ttottim;
