function [cor acor1 acor2 win1]=ana_corr(g1,g2,sim)
% ana_corr  correlation analysis

% Version 2.0 - August 2010
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

if ~exist('sim','var')
    sim=0;
end

if sim == 1
    y=y_gd(g2);
    j=find(y);
    y(j)=randn(1,length(j));
    g2=edit_gd(g2,'y',y);
end

y=y_gd(g1);
i=find(y);

if sim == 1
    y(i)=randn(1,length(i));
    g1=edit_gd(g1,'y',y);
end

cor=gd_crcorfft(g1,g2,'norm'); disp('cor')
acor1=gd_crcorfft(g1,g1,'norm'); disp('acor1')
acor2=gd_crcorfft(g2,g2,'norm'); disp('acor2')

y(i)=1;
g1=edit_gd(g1,'y',y);
win1=gd_crcorfft(g1,g1,'norm'); disp('win1')