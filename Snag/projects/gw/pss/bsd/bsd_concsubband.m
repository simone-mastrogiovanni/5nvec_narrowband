function [bsd_sb,pars]=bsd_concsubband(addr,BSD_tab_out,bandin,modif)
% sub-band of concatenated bsds
%
%     [bsd_sb,pars]=bsd_concsubband(addr,BSD_tab_out,bandin,modif)
%
%    addr         path that contains BSD data master directory without the final dirsep
%    BSD_tab_out  operative file table
%    bandin       requested band
%    modif        modif structure (or cell array) for bsd_acc_modif

% Snag Version 2.0 - November 2016
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by O.J.Piccinni and S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

bsd_out=0;

if ~exist('modif','var')
    modif=[];
end

out=check_bsd_table(BSD_tab_out);

for i = 1:out.N
    [in, name]=load_tab_bsd(addr,BSD_tab_out,i);
%     [in, name]=load_tab_bsd(addr,BSD_tab_out,i,modif);
%     sb=bsd_subband(in,BSD_tab_out,band-out.frange(1));
    if i == 1
        bsd_out=in; 
    else
        bsd_out=conc_bsd(bsd_out,in)
    end
end

bsd_out=bsd_acc_modif(bsd_out,modif);

st=1/(bandin(2)-bandin(1)); % bandin,st,out.frange,modif
[bsd_sb,pars]=bsd_subband(bsd_out,[],bandin-out.frange(1),st);