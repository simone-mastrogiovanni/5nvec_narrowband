function [m m1]=lin_rocfromfap(fap,sig,lab)
%LIN_ROC  draws the Receiver Operating Characteristic (ROC) curves from false alarm probability
%
%     m=lin_rocfromfap(fap,sig)
%
%      fap     a gd containing the false alarm probability
%      sig     an array containing the signals
%      lab     label

% Version 2.0 - January 2007
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

if ~exist('lab','var')
    lab=' ';
end
nl=length(sig);
dx=dx_gd(fap);
ini=ini_gd(fap);
n=n_gd(fap);
fap=y_gd(fap);
ymin=min(fap(find(fap)));
y=[ymin 1];
m=crea_mp(nl);
m1=m;

figure, loglog(y,y,'r--'), hold on,grid on
for i = 1:nl
    nsh=round(sig(i)/dx);
    loglog(fap(nsh+1:n),fap(1:n-nsh));
    m.ch(i).x=fap(nsh+1:n);
    m.ch(i).y=fap(1:n-nsh);
end

title(['ROC - receiver operating characteristic : ' lab])
xlabel('False alarm probability')
ylabel('Detection probability')
hold off

figure, hold on,grid on
for i = 1:nl
    nsh=round(sig(i)/dx);
    x0=ini+dx*nsh;
    y=(fap(1:n-nsh)-fap(nsh+1:n))./sqrt(fap(nsh+1:n).*(1-fap(nsh+1:n)));
    x=x0+(0:n-nsh-1)*dx;
    semilogy(x,y);
    m1.ch(i).x=x;
    m1.ch(i).y=y;
end

title(['Detection parameter : ' lab])
xlabel('threshold')
ylabel('Detection parameter')
hold off