function [sol sid]=solsid_disent(gin)
%
%   works only with 1 s samples, independent of unit

SF=1.002737909350795;
dx=1/86400;
gin=edit_gd(gin,'dx',dx);
n=n_gd(gin);
T=n*dx;
dfr=1/(T*20);
fr=1-40*dfr:dfr:SF+40*dfr; figure,plot(fr,'.')

dfr=SF-1;

fr1=1-dfr;
fr2=1;
fr3=SF;
fr4=SF+dfr;

y=y_gd(gin);
y=y(1:length(y));
y(y~=0)=1;
nn=length(y);
x=dx*(0:nn-1);

y1=cos(x*2*pi).*y';
y2=cos(x*2*pi*SF).*y';

y1=edit_gd(gin,'y',y1);
y2=edit_gd(gin,'y',y2);

par.red=100;

[sp1a sp4 spall ft_1]=gd_nud_spec(y1,fr,4,par);
[sp1a sp4 spall ft_2]=gd_nud_spec(y2,fr,4,par);

figure,plot(real(ft_1)),hold on,plot(imag(ft_1),'r'),plot(abs(ft_1),'g')
plot(real(ft_2),'.'),plot(imag(ft_2),'r.'),plot(abs(ft_2),'g.')

figure,plot(abs(ft_1)./abs(ft_2))

% [sp1a sp4 spall ft_1]=gd_nud_spec(gin,fr1,4,par);
% [sp1a sp4 spall ft_2]=gd_nud_spec(gin,fr2,4,par);
% [sp1a sp4 spall ft_3]=gd_nud_spec(gin,fr3,4,par);
% [sp1a sp4 spall ft_4]=gd_nud_spec(gin,fr4,4,par);
% 
% sol.ft=ft_2+ft_4;
% sol.ft0=ft_2;
% sol.oldamp=abs(sol.ft0);
% sol.newamp=abs(sol.ft);
% sol.dhour=(angle(sol.ft)-angle(sol.ft0))*12/pi;
% sid.ft=ft_3+ft_1;
% sid.ft0=ft_3;
% sid.oldamp=abs(sid.ft0);
% sid.newamp=abs(sid.ft);
% sid.dhour=(angle(sid.ft)-angle(sid.ft0))*12/pi;
% 
