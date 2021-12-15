function top_can=top_list_candidates(composed_file,pthr,pthrtotal)

load(composed_file);
N_trials=length(r_Sfft);
pd = makedist('Binomial','N',N_trials,'p',pthr);
FAP_success=(0:1:N_trials).';
pdf_binomial=pdf(pd,FAP_success);
cum_pdf_bin=cumsum(pdf_binomial);
i_find=find(cum_pdf_bin>=pthrtotal);
exp_n_cand=FAP_success(i_find(1));
if exp_n_cand==0
    exp_n_cand=1;
end

for i=1:1:exp_n_cand
   [Smax,ii]=max(r_Sfft);
   top_can.frequency(i)=r_fra(ii);
   top_can.spindown(i)=r_sd(ii);
   top_can.count_sd(i)=r_count_sd(ii);
   top_can.Scand(i)=Smax;
   r_Sfft(ii)=[];
   r_fra(ii)=[];
   r_sd(ii)=[];
   r_count_sd(ii)=[];
end
top_can.Sthr=min(top_can.Scand);


end