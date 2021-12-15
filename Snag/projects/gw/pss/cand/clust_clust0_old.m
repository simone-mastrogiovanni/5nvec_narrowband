function out=clust_clust0(in,par,res)
%
%   out=clust_clust(in,par,res)
%
%   in   input cluster structure array
%   par  natural resolutions [dfr dsd]
%   res  resolutions (in natural units)
%
%   out  output structure array

% Version 2.0 - July 2012
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

[n1 n2]=size(in);
II=sparse(n2,1);

N=0;
out=struct('frmin',0,'frmax',0,'fr',0,...
    'lammin',0,'lammax',0,'lam',0,'dlam',0,...
    'betmin',0,'betmax',0,'bet',0,'dbet',0,...
    'sdmin',0,'sdmax',0,'sd',0,...
    'ampmax',0,'cr',0,'num',0);

    
for i = 1:n2
    newclust=1;
    if floor(i/1000)*1000 == i
        cl=clock;
        fprintf('%d %d  %d:%d:%f \n',i,N,cl(4:6))
    end
    in1=in(i);
    III=find(II);
    
    if ~isempty(III)
        for jj = 1:length(III)
            ii=III(jj);
            clust1=out(ii);
            if clust1.frmax < in1.frmin-res(1)*par(1)
                II(ii)=0;
                continue
            end
            dlam=res(2)*in1.dlam; dlam=0;
            dbet=res(3)*in1.dbet; dbet=0;
            dsd=res(4)*par(2);    dsd=0;
%             secante([clust1.lammin clust1.lammax],[in1.lammin] in1.lammax]])
            if secante([clust1.lammin clust1.lammax],[in1.lammin-res(2)*in1.dlam in1.lammax+dlam]) * ...
                    secante([clust1.betmin clust1.betmax],[in1.betmin-dbet in1.betmax+dbet]) * ...
                    secante([clust1.sdmin clust1.sdmax],[in1.sdmin-dsd in1.sdmax+dsd]) > 0
                out(ii).frmin=min(out(ii).frmin,in1.frmin);
                out(ii).frmax=max(out(ii).frmax,in1.frmax);
                out(ii).lammin=min(out(ii).lammin,in1.lammin);
                out(ii).lammax=max(out(ii).lammax,in1.lammax);
                out(ii).betmin=min(out(ii).betmin,in1.betmin);
                out(ii).betmax=max(out(ii).betmax,in1.betmax);
                out(ii).sdmin=min(out(ii).sdmin,in1.sdmin);
                out(ii).sdmax=max(out(ii).sdmax,in1.sdmax);
                
                out(ii).num=out(ii).num+in1.num;
                if in1.ampmax > out(ii).ampmax
                    out(ii).ampmax=in1.ampmax;
                    out(ii).fr=in1.fr;
                    out(ii).lam=in1.lam;
                    out(ii).bet=in1.bet;
                    out(ii).sd=in1.sd;
                    out(ii).cr=in1.cr;
                end
                newclust=0;
                break
            end
        end
    end
    
    if newclust == 1
        N=N+1;
        out(N)=in1;
        II(N)=1;
    end
end


function ii=secante(a,b)

ii=0;
if a(1) >= b(1) & a(1) <= b(2) || ...
        a(2) >= b(1) & a(2) <= b(2) || ...
        b(1) >= a(1) & b(1) <= a(2) || ...
        b(2) >= a(1) & b(2) <= a(2)
    ii=1;
end
    