function candstat=psc_candstat(cand,head,typ)
%PSC_CANDSTAT  computes statistics for cand vector
%
%     candstat=psc_candstat(cand,typ)
%
%   cand       cand vector (8*n)
%   head       candidate header
%   typ        type (0 only min,max, nofreq)
%
%   candstat   output structure


cand=reshape(cand,8,length(cand)/8);

maxc=max(cand');
minc=min(cand');

maxc(3)=maxc(3)*head.dlam;
maxc(4)=maxc(4)*head.dbet-90;
maxc(5)=maxc(5)*head.dsd1;
maxc(6)=maxc(6)*head.dcr;
maxc(7)=maxc(7)*head.dmh;
maxc(8)=maxc(8)*head.dh;

minc(3)=minc(3)*head.dlam;
minc(4)=minc(4)*head.dbet-90;
minc(5)=minc(5)*head.dsd1;
minc(6)=minc(6)*head.dcr;
minc(7)=minc(7)*head.dmh;
minc(8)=minc(8)*head.dh;

switch typ
    case 0
        candstat.min=minc(3:8);
        candstat.max=maxc(3:8);
end