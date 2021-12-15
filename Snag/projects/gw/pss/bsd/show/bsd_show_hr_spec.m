function [out,tab_out]=bsd_show_hr_spec(addr,tab,fr0,npiece,res)
% shows high res spectral characteristics of the bsds in a table 
%
%   addr   BSD address
%   tab    BSD table
%   fr0    a frequency inside the frequency band
%          or [page fritem1 fritem2]
%          (typically serial numbers for month, first band, last band)
%
% example single band:  [out,tab_out]=bsd_show_hr_spec('I:\',BSD_tab_O1_H,100,20,2)
% example single time, some subbands:  [out,tab_out]=bsd_show_hr_spec('I:\',BSD_tab_O1_H,[2,2,5],20,2)

% Snag Version 2.0 - August 2017
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by O.J.Piccinni and S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

tic

if length(fr0) == 1
    [tab_out,epoch0,maxt]=bsd_extr_subtab(tab,0,fr0);
else
    outch=check_bsd_table(tab);
    i1=(fr0(1)-1)*outch.n_f+fr0(2);
    i2=(fr0(1)-1)*outch.n_f+fr0(3);
    tab_out=bsd_seltab(tab,i1:i2);
end

tab_out,pause(1)

n_t=height(tab_out);

figure

for i = 1:n_t
    [bsd, name]=load_tab_bsd(addr,tab_out,i); name
    cont=cont_gd(bsd);
    out{i}=bsd_pows(bsd,res,npiece);
    [tcol colstr colchar]=rotcol(i);
    semilogy(out{i},colchar),hold on
end

grid on

toc