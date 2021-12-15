function lin_roc(gn,gs,nbins,nl)
%LIN_ROC  draws the Receiver Operating Characteristic (ROC) curve 
%         and the noise distribution normalized to the signal in case
%         of linear filters
%
%      gn      a gd (or an array) containing the noise after the filter
%      gs      a gd (or an array) containing the signal after the filter
%               (it uses only the maximum)
%      nbins   number of bins
%      nl      number of lines (for multiple amplitudes of the signal)

% Version 2.0 - May 2003
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

if isa(gn,'gd')
    gn=y_gd(gn);
end
if isa(gs,'gd')
    gs=y_gd(gs);
end

m=mean(gn);
mi=min(gn);
ma=max(gn);
gs=max(gs);

dx=(ma-mi)/(nbins-1);
hx=mi+(0:nbins-1)*dx;
h=histc(gn,hx);
h=cumsum(h);
h=1-h/h(nbins);
y=h;
[X,Y]=tostairs(hx,h);
figure
semilogy(X,Y), grid on, zoom on
title('False alarm probability')

figure, plot(y,y,'-r'), hold on
for i = 1:nl
    dk=round(i*gs/dx);
    x(1:nbins-dk)=h(dk+1:nbins);
    x(nbins-dk+1:nbins)=0;
    plot(x,y), hold on, grid on
end

title('ROC - receiver operating characteristic')
xlabel('False alarm probability')
ylabel('Detection probability')
hold off