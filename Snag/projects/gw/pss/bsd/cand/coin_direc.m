function out=coin_direc(varargin)
% coincidences between candidates for candidates
%
%    par    search parameters (.typ, .dist, .amp, .cr, .mincr, .maxcr, .delay)
%    in1    cand1 structure (.cand,.tab)
%    in2    cand2 structure
%     .........

% Snag Version 2.0 - March 2019
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by O.J.Piccinni and S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

band10=10;
i1000=1000;

par=varargin{1};

if isfield(par,'type')
    typ=par.type;
else
    typ=nargin-1;
end

mindist=0;
icauto=0;

dist=par.dist; % max coin distance

if isfield(par,'mincr')
    mincr=par.mincr;
else
    mincr=0;
end

if isfield(par,'maxcr')
    maxcr=par.maxcr;
else
    maxcr=1e40;
end

if isfield(par,'delay')
    delay=par.delay;
else
    delay=0;
end

if isfield(par,'thresh')
    thresh=par.thresh;
else
    thresh=2.5;
end
pteor_=hough_peak_prob(0,thresh,0.01);

in1=varargin{2};
frs=in1.cand(1,:);
[frs,ii]=sort(frs);
cand1=in1.cand(:,ii);
epoch1=in1.epoch;
tab1=table2array(in1.tab);
[ra1,rp1]=v_ranking(in1.cand(6,:),mincr,maxcr);

if nargin > 2
    in2=varargin{3};
    frs=in2.cand(1,:);
    [frs,ii]=sort(frs);
    cand2=in2.cand(:,ii);
    epoch2=in2.epoch;
    tab2=table2array(in2.tab);
    [ra2,rp2]=v_ranking(in2.cand(6,:),mincr,maxcr);
end
if nargin > 3
    in3=varargin{4};
    frs=in3.cand(1,:);
    [frs,ii]=sort(frs);
    cand3=in3.cand(:,ii);
    epoch3=in3.epoch;
    tab3=table2array(in3.tab);
    [ra3,rp3]=v_ranking(in3.cand(6,:),mincr,maxcr);
end
if nargin  > 4
    in4=varargin{5};
    frs=in4.cand(1,:);
    [frs,ii]=sort(frs);
    cand4=in4.cand(:,ii);
    epoch4=in4.epoch;
    tab4=in4.tab;
end
if nargin > 5
    in5=varargin{6};
    frs=in5.cand(1,:);
    [frs,ii]=sort(frs);
    cand5=in5.cand(:,ii);
    epoch5=in5.epoch;
    tab5=table2array(in5.tab);
end
if nargin > 6
    in6=varargin{7};
    frs=in6.cand(1,:);
    [frs,ii]=sort(frs);
    cand6=in6.cand(:,ii);
    epoch6=in6.epoch;
    tab6=table2array(in6.tab);
end

tit='Coincidences';
if typ == 1
    cand2=cand1;
    epoch2=epoch1;
    tab2=tab1;
    typ=2;
    mindist=eps;
    ra2=ra1;
    rp2=rp1;
    icauto=1;
    tit='Auto-coincidences';
end

if typ == 2
    cand2=new_cand(cand2,epoch2,epoch1); % update cand2 epoch to epoch1
    if delay ~= 0
        minf2=min(cand2(1,:));
        maxf2=max(cand2(1,:));
        cand2(1,:)=mod(cand2(1,:)+delay-minf2,maxf2-minf2)+minf2;
    end

    [out,ncoin,mu1,mu2,sig1,sig2,dista]=coin_direc_base(cand1,cand2,tab1,tab2,dist,mindist,pteor_);
end

if isfield(par,'analysis') & ncoin > 0
    co1=[out.coin.in1];
    co2=[out.coin.in2];
    fr1=co1(1,:);
    sd1=co1(4,:);
    A1=co1(5,:);
    CR1=co1(6,:);
    fr2=co2(1,:);
    sd2=co2(4,:);
    A2=co2(5,:);
    CR2=co2(6,:);
    cr1=(A1-mu1)./sig1;
    cr2=(A2-mu2)./sig2;
    frs=(fr1+fr2)/2;
    sds=(sd1+sd2)/2;
    figure,plot(frs,sds,'.'),grid on,title(tit),xlabel('frequency'),ylabel('spin-down')
    figure,plot(frs,A1./A2,'.'),grid on,title(tit),xlabel('frequency'),ylabel('A1/A2')
    figure,plot(frs,A1,'o'),grid on,hold on,plot(frs,A2,'ro'),plot(frs,(A1+A2)/2,'gx'),
    title(tit),xlabel('frequency'),ylabel('A1 & A2')
    figure,plot(frs,CR1,'o'),grid on,hold on,plot(frs,CR2,'ro'),plot(frs,(CR1+CR2)/2,'gx'),
    title(tit),xlabel('frequency'),ylabel('CR1 & CR2')
    figure,plot(frs,mu1,'o'),grid on,hold on,plot(frs,mu2,'ro'),
    title(tit),xlabel('frequency'),ylabel('mu1 & mu2')
    figure,plot(frs,sig1,'o'),grid on,hold on,plot(frs,sig2,'ro'),
    title(tit),xlabel('frequency'),ylabel('sig1 & sig2')
    figure,plot(frs,cr1,'o'),grid on,hold on,plot(frs,cr2,'ro'),plot(frs,(cr1+cr2)/2,'gx'),
    title(tit),xlabel('frequency'),ylabel('cr1 & cr2')
    
    figure,plot(CR1,CR2,'x'),grid on,title('CR2 vs CR1')
    figure,plot(cr1,cr2,'rx'),grid on,title('cr2 vs cr1')
    
    dfrs=fr2-fr1;
    dsds=sd2-sd1;
    
    figure,plot(dfrs,dsds,'.'),grid on,title(tit),xlabel('dfrs'),ylabel('dsds')
    figure,hist(sds,20),title('spin-down histogram')
    figure,hist(dfrs,20),title('d frequency histogram')
    figure,hist(dsds,20),title('d spin-down histogram')
    
    p1=rank_v(ra1,rp1,CR1); 
    p2=rank_v(ra2,rp2,CR2);
    P=1./(p1.*p2);
    
    figure,semilogy(frs,1./p1,'x'),grid on,hold on,plot(frs,1./p2,'gx'),plot(frs,P,'ro'),
    title(tit),xlabel('frequency'),ylabel('Ranking')
    
    fprintf('\n     %s \n\n',tit)
    fprintf(' i fr1 sd1 dfr dsd | dist A1 A2 CR1 CR2 \n\n')
    
    nccoin=0;
    for i = 1:ncoin
        fprintf('%d %10f %e  %.4e %.3e | %.3f  %.1f %.1f  %.1f %.1f  %.1f %.1f\n',i,...
            fr1(i),sd1(i),dfrs(i),dsds(i),dista(i),A1(i),A2(i),CR1(i),CR2(i),cr1(i),cr2(i));
%         fprintf('%d %10f %e  %10f %e  %.3f  %.1f %.1f \n',i,fr1(i),sd1(i),fr2(i),sd2(i),dista(i),A1(i),A2(i));
        if P(i) > ncoin*3
            nccoin=nccoin+1;
            fprintf('    %d  p1 = %e   p2 = %e   1/P = %e \n',nccoin,p1(i),p2(i),P(i))
        end
    end
    out.mu1=mu1;
    out.sig1=sig1;
    out.mu2=mu2;
    out.sig2=sig2;
    out.cr1=cr1;
    out.cr2=cr2;
    out.p1=p1;
    out.p2=p2;
    out.P=P;
end