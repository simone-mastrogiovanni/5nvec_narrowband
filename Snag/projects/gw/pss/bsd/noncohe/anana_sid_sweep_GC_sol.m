function aasolout=anana_sid_sweep_GC_sol(thr,range,bw)
% analysis after ana_sid_sweep_GC on solar data
%
%   thr     threshold (def 1.e7)
%   range   def 10:10:1000
%   bw      def 10

% Snag Version 2.0 - Mayl 2019
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by O.J.Piccinni and S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

if ~exist('thr','var')
    thr=1e7;
end
if ~exist('range','var')
    range=10:10:1000;
end
if ~exist('bw','var')
    bw=10;
end

N=length(range);
aasolout.solcand=[];

for i = 1:N
    fr1=range(i);
    sidsL=sprintf('sidsGC_%04d_%04d_%d_L',fr1,fr1+10,bw);
    sidsH=sprintf('sidsGC_%04d_%04d_%d_H',fr1,fr1+10,bw);
    
    try
        eval(['load(''' sidsL ''');'])
    catch
        sprintf(' *** %s is not present',sidsL)
        continue
    end
    frL=sidsGCL.fr;
    sidsigL=sidsGCL.solsig;
    sidnoisL=sidsGCL.solnois;
    sidratL=sidsigL./sidnoisL;

    try
        eval(['load(''' sidsH ''');'])
    catch
        sprintf(' *** %s is not present',sidsH)
        continue
    end
    frH=sidsGCH.fr;
    sidsigH=sidsGCH.solsig;
    sidnoisH=sidsGCH.solnois;
    sidratH=sidsigH./sidnoisH;
    out.sidratH=sidratH;
      
    pL=sort_p_rank(sidratL);
    pH=sort_p_rank(sidratH);
    P=1./(pL.*pH);
    
    ii=find(P >= thr);
    if length(ii) > 0
        for j = 1:length(ii)
            fr=frL(ii(j));
            amp=P(ii(j));
            aasolout.solcand=[aasolout.solcand [fr;amp]];
        end
        figure,semilogy(frL,1./pL,'x'),grid on,hold on,plot(frH,1./pH,'gx'),plot(frL,P,'ro'),
        title([sidsL ' - ' sidsH]),xlabel('frequency'),ylabel('Ranking')
    end
end