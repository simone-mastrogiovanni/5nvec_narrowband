function cell_out=compute_thr(filename,composed_file,FAP)

% This function compute the detection threshold for candidate selection
% interpolating the tail of the distribution and possibly compute the
% candidates
%
% Input:
% filename: Name of the file where to find a computed detection statistic
% composed_file:Name of the file computed with the composed script, don't
% put if you want just the threshold
% FAP: False alarm probability
%
%
% Output:
% Value of the detection statistic displayed on the terminal
% cell_out: 1 ) Interpolation results, 2) Candidates


load(filename); % Load file containing detection statistic
Sfft=Sfftshifted;
S_step=input('Select a step for the detection statistic histogram \n');
S_histo=min(Sfft):S_step:max(Sfft);
hist(Sfft,S_histo); % Show the histogram to the user
[ncount,center]=hist(Sfft,S_histo); % Show the log histogram to the user
figure; plot(center,log(ncount));
scelta=input('Is the bin width ok? (yes or no) \n','s');
%%%%%%%% CYCLE to find the optimal step %%%%%%%%%
while 1
    switch scelta
        case 'no'
            close all
            S_step=input('Select a step for the detection statistic histogram \n');
            S_histo=min(Sfft):S_step:max(Sfft);
            hist(Sfft,S_histo);
            [ncount,center]=hist(Sfft,S_histo);
            figure; plot(center,log(ncount));
            scelta=input('Is the bin width ok? (yes or no) \n','s');
        case 'yes'
            break
        otherwise
            scelta=input('Please digit yes or no \n','s');
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if exist('composed_file','var')
    load(composed_file);
    Nsd=size(fra_full);
    disp('Number of sd bins');
    Nsd=Nsd(1)
    disp('Frequency widht');
    swid=max(max(fra_full))-min(min(fra_full))
    
    
    
end

%% Start and end point to use for the exponential interpolation%%%%
S_min=input('Select the Detection statistic start point for the interpoletion \n');
S_max=input('Select the Detection statistic end point for the interpoletion \n');
is=find(center>S_min & center<S_max);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%% Perform the exponential fit and merge it with the DS real distribution %%%%%%
fity=ncount(is);
fitx=center(is);
f=fit(fitx.',fity.','exp1');
figure; plot(f,fitx,fity);
S_plot_max=input('Insert the maximum value to compute for the interpolation \n');
x1=center(1:is(1));
y1=ncount(1:is(1));

x2=center(is(2)):S_plot_max/1e5:S_plot_max; % Step in DS, check for cumulative step
y2=f.a*exp(f.b*x2);
S_final=[x1,x2];
fS=[y1,y2];
prob=fS/sum(fS);
figure;plot(S_final,prob);
cum_prob=1-cumsum(prob);

%Nsd=input('Insert the number of spin-down you have been compouted \n');
%swid=input('Insert the sud-bands width \n');
Nf=swid/info.binfsid;
p_look_elsewhere=1-(1-FAP)^(1/(Nf*Nsd))
iprob=find(cum_prob<p_look_elsewhere);
cum_prob(iprob(1))   % Controls on the probability step
cum_prob(iprob(1)-1) % Controls on the probability step
cum_prob(iprob(1)+1) % Controls on the probability step
Sthr=S_final(iprob(1)) % Value of the thr
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if exist('composed_file','var')
    load(composed_file);
    close all
    i_cand=find(r_Sfft>Sthr);
    figure;plot_triplets(r_fra,r_sd,r_Sfft);
    hold on
    plot(r_fra(i_cand),r_sd(i_cand),'rd','MarkerSize',8,'MarkerFaceColor','r')
    xlabel('Frequency [Hz]','FontSize',14)
    ylabel('Spin-down[Hz/s]','FontSize',14)
    set(gca,'FontSize',14)
    hold off
    candidates.frequency=r_fra(i_cand);
    candidates.spindown=r_sd(i_cand);
    candidates.count_sd=r_count_sd(i_cand);
    candidates.Sthr=Sthr;
    candidates.rcountsd=r_count_sd(i_cand);
    
    hold off
    for j=1:1:length(i_cand)
        c_s=find(S_final>=r_Sfft(i_cand(j)));
        candidates.pvalue(j)=1-(1-cum_prob(c_s(1)))^(Nf*Nsd);
        candidates.over_pvalue(j)=cum_prob(c_s(1));
    end
    over_pvalue_plot=zeros(size(r_fra));
    pvalue_plot=zeros(size(r_fra));
    for j=1:1:length(r_Sfft)
        c_s=find(S_final>=r_Sfft(j));
        pvalue_plot(j)=1-(1-cum_prob(c_s(1)))^(Nf*Nsd);
        over_pvalue_plot(j)=cum_prob(c_s(1));
        j
    end
        saveas(gcf,'candidates_plot.fig');
    figure;
    subplot(2,1,1)
    semilogy(r_fra,pvalue_plot)
    set(gca,'FontSize',14)
    xlim([r_fra(1),r_fra(end)])
    ylabel('p-value','FontSize',14)
    hold on
    for j=1:1:length(i_cand)
        plot(candidates.frequency(j),candidates.pvalue(j),'rd','MarkerFaceColor','r','MarkerSize',8)
    end
    hold off    
    subplot(2,1,2)
    semilogy(r_fra,over_pvalue_plot)
    ylabel('overall p-value','FontSize',14)
    xlabel('Frequency [Hz]','FontSize',14)
    xlim([r_fra(1),r_fra(end)])
    set(gca,'FontSize',14)
    
    hold on
    for j=1:1:length(i_cand)
        plot(candidates.frequency(j),candidates.over_pvalue(j),'rd','MarkerFaceColor','r','MarkerSize',8)
    end
    hold off
    saveas(gcf,'candidates_pvalues.fig');

    
    
    cell_out{2}=candidates;
end
cell_out{1}=f;
end
