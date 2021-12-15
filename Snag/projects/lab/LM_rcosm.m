function k=LM_rcosm(lambda,Dt,M)
% LM_RCOSM  simulazione raggi cosmici
%
%    lambda   densità eventi
%    Dt       intervallo di tempo
%    M        numero di palline (def. 1)

% Project LabMec - part of the toolbox Snag - July 2008
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

mu=lambda*Dt;

k=poissrnd(mu,1,M);
figure

for i = 1:M
    t=Dt*rand(k(i),1);
    t=sort(t);
    stem(t,t*0+1),xlim([0 Dt]),ylim([-0.5 2]);
    str=sprintf('Raggi cosmici: mu = %f  rivelati %d',mu,k(i));
    title(str)
    xlabel('s')
    pause(2)
end

