function k=LM_pallin(p,N,M)
% LM_PALLIN  pallinometro
%
%    p     probabilità di andare a destra
%    N     numero file di chiodi
%    M     numero di palline (def. 1)

% Project LabMec - part of the toolbox Snag - July 2008
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

if ~exist('M','var')
    M=1;
end

x0=N/2;
r=sign(p-rand(N,1));

if M == 1
    figure,stem(r,'MarkerFaceColor','red'),ylim([-2 2])
    title('Successi e Insuccessi (verso destra o verso sinistra)')

    k=length(find(r>0));
    str=sprintf('Prove alla Bernoulli: p = %f, N = %d,  %d successi',p,N,k);
    xlabel(str)
end

figure
for ii = 1:M
    xx=x0+[0 cumsum(r)']*0.5;
    yy=-1:-1:-N-1;

    plot(xx,yy,'r','LineWidth',2),hold on
    for i = 1:N
        x=(2*x0-i+1)*0.5+(0:i-1);
        plot(x,x*0-i,'k.')
    end
    x=(2*x0-N)*0.5+(0:N);
    plot(x,x*0-N-1,'V'),grid on

    k(ii)=length(find(r>0));
    str=sprintf('Pallinometro: p = %f, N = %d, bin k = %d ',p,N,k(ii));
    xlabel(str)
    r=sign(p-rand(N,1));
    pause(1), hold off
end
