function p=rank_v(ra,rp,vals)
% ranking based on v_ranking
%
%   ra,rp   data computed by v_ranking 

% Version 2.0 - March 2019
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

vals=vals(:)';
n=length(vals);
ranks=vals*0;
p=vals*0;

for i = 1:n
    if vals >= ra(1) & vals <= ra(end)
        [aa,ii]=min(abs(ra-vals(i)));
        p(i)=rp(ii);
    end
end