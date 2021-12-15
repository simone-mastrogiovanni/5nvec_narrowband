function [mis el es ec tr dist]=LM_misure(valv,errlet,errsist,errcas,trend,pr_dist,amp_dist)
% LM_MISURE  simulazione misure
%
%    [mis el es ec tr dist]=LM_misure(valv,errlet,errsist,errcas,trend,pr_dist,amp_dist)
%
%   valv      valore vero (array; se 2 elementi, primo valv, secondo numero
%             di misure)
%   errlet    errore di lettura (p. es. 0.001)
%   errsist   errore sistematico (di taratura) [b a]: b*vv+a
%   errcas    deviazione standard del rumore casuale
%   trend     trend (aumento del valore per misura)
%   pr_dist   probabilità dei disturbi occasionali
%   amp_dist  ampiezza media disturbi occasionali

% Project LabMec - part of the toolbox Snag - July 2008
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

if length(valv) == 2
    valv=valv(1)*ones(valv(2),1);
end

n=length(valv);
tr=(0:n-1)'*trend;
es=(valv+tr).*errsist(1)+errsist(2);
ec=errcas*randn(n,1);
i=find(rand(n,1)<pr_dist);
dist=zeros(n,1);
dist(i)=laplrnd(amp_dist,length(i),1);

mis0=valv+tr+es+ec+dist;
mis=round(mis0/errlet)*errlet;
el=mis-mis0;