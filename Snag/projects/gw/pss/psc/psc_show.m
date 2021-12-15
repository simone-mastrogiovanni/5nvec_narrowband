function out=psc_show(cand,typ,pars)
%PSC_SHOW  shows PSS candidates; the data can be previously selected with psc_sel 
%
%      out=psc_show(cand,typ,pars)
%
%  cand    candidate (7,n) matrix
%  typ     type of show: 'freq','freq0','sky','sd','cr','mh'
%  pars    parameter structure, depending on type
%
%  out     output result, depending on type

% Version 2.0 - February 2006
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

icstr=0;
if isstruct(cand)
    icstr=1;
    cand=cand.cand;
end

icst=0;
nclass=7;
if exist('pars','var')
    if isfield(pars,'subtype')
        icst=pars.subtype;
    end
    minsd=min(cand(4,:));
    maxsd=max(cand(4,:));
    if isfield(pars,'nclass')
        nclass=pars.nclass;
    end
end
    
switch typ
    case 'sky'
        switch icst
            case 0 
                figure,plot(cand(2,:),cand(3,:),'.'),grid on
            case 1
                dsd=1.000001*(maxsd-minsd)/nclass;
                figure
                for i = 1:nclass
                    i1=find(cand(4,:)>=minsd & cand(4,:)<=minsd+dsd);
                    minsd=minsd+dsd;
                    cand2(1:length(i1))=cand(2,i1);
                    cand3(1:length(i1))=cand(3,i1);
                    col=rotcol(i);
                    plot(cand2,cand3,'.','color',col), hold on
                end
            case 2
                minfr=min(cand(1,:));
                maxfr=max(cand(1,:));
                dfr=1.000001*(maxfr-minfr)/nclass;
                figure
                for i = 1:nclass
                    i1=find(cand(1,:)>=minfr & cand(1,:)<=minfr+dfr);
                    minfr=minfr+dfr;
                    cand2(1:length(i1))=cand(2,i1);
                    cand3(1:length(i1))=cand(3,i1);
                    col=rotcol(i);
                    plot(cand2,cand3,'.','color',col), hold on
                end
            case 3
                mincr=min(cand(1,:));
                maxcr=max(cand(1,:));
                dcr=1.000001*(maxcr-mincr)/nclass;
                figure
                for i = 1:nclass
                    i1=find(cand(1,:)>=mincr & cand(1,:)<=mincr+dcr);
                    mincr=mincr+dcr;
                    cand2(1:length(i1))=cand(2,i1);
                    cand3(1:length(i1))=cand(3,i1);
                    col=rotcol(i);
                    plot(cand2,cand3,'.','color',col), hold on
                end
        end
    case 'freq' 
        freq0=cand(1,:);
        if nclass <= 10
            nclass=10000;
        end
        figure,hist(freq0,nclass), grid on
        out=gd(freq0);
    case 'freq0' % should be present pars.time0; to obtain it:
                 %  head=check_psc_file; pars.time0=head.initim
        disp(sprintf('run start at %s ',mjd2s(pars.time0)))
        dtim=(pars.time0-51554);
        freq0=cand(1,:)-cand(4,:)*dtim;
        figure,hist(freq0,nclass), grid on
        out=gd(freq0);
    case 'sd' 
        sd=cand(4,:);
        figure,hist(sd,nclass), grid on
        out=gd(sd);
    case 'cr' 
        cr=cand(5,:);
        figure,hist(cr,nclass), grid on
        out=gd(cr);
    case 'mh' 
        mh=cand(6,:);
        figure,hist(mh,nclass), grid on
        out=gd(mh);
end
                
        