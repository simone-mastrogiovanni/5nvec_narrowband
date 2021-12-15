function [t,s,dt,n,file,comm]=leggi_pasco(file)
% LEGGI_PASCO  legge file testo con dati Pasco

% Project LabMec - part of the toolbox Snag - April 2008
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

if ~exist('file','var')
    file=selfile(' ','*.txt','File pasco txt da aprire ?');
end

[A comm]=readascii_comma(file,2,2);

t=A(:,1);
s=A(:,2);
n=length(t);
dt=(t(n)-t(1))/(n-1);