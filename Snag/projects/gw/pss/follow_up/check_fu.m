function out=check_fu(full_fu)
% checks full follow-up analysis
%   
%      out=check_fu(full_fu) 
%
%   full_fu      as created by fu_full

% Snag Version 2.0 - December 2014 
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

out=struct();
inp1=tit_underscore(inputname(1));

pm1=full_fu.fu1.pm;
pm2=full_fu.fu2.pm;
pmcorr1=full_fu.fu1.pmcorr;
pmcorr2=full_fu.fu2.pmcorr;
[dum,n1]=size(pm1);
[dum,n2]=size(pm2);

f=pm1(2,:);
f(n1+1:n1+n2)=pm2(2,:);
fc=pmcorr1(2,:);
fc(n1+1:n1+n2)=pmcorr2(2,:);
A=pm1(3,:);
A(n1+1:n1+n2)=pm2(3,:);

[wwh,outwh]=ww_hist(4,0.0001,f,A,1);
[wwhc,outwhc]=ww_hist(4,0.0001,fc,A,1);

fprintf('step1 mu = %f  sigma = %f   step2 mu = %f  sigma = %f \n',outwh.mu,outwh.sigma,outwhc.mu,outwhc.sigma)

fig1=figure;plot(wwh);hold on,plot(wwhc,'r'),xlabel('Hz'),title(inp1)
out.fig1=fig1;

[wwh1,out1]=ww_hist_2D(4,[2,0.0002],full_fu.fu1.pm(1:2,:),full_fu.fu1.pm(3,:));title([inp1 ' 1 ']);
xlabel('MJD'),ylabel('Hz')
[wwh2,out2]=ww_hist_2D(4,[2,0.0002],full_fu.fu1.pmcorr(1:2,:),full_fu.fu1.pm(3,:));title([inp1 ' 1 corr']);
xlabel('MJD'),ylabel('Hz')

% [wwh3,out3]=ww_hist_2D(4,[2,0.00002],full_fu.fu2.pm(1:2,:),full_fu.fu2.pm(3,:));title([inp1 ' 2 ']);
% xlabel('MJD'),ylabel('Hz')
% [wwh4,out4]=ww_hist_2D(4,[2,0.00002],full_fu.fu2.pmcorr(1:2,:),full_fu.fu2.pm(3,:));title([inp1 ' 2 corr']);
% xlabel('MJD'),ylabel('Hz')