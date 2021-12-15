function HM=finHM(psspar,preHM)
%FINHM  finalize the HM starting from the preHM

preHM=cumsum(preHM);

na=ceil(psspar.hmap.na);
nd=psspar.hmap.nd;
lambias=ceil(psspar.hmap.na/2);
lamb2=na-lambias;

HM=preHM(lambias+1:lambias+na,:);
HM(1:lamb2,:)=HM(1:lamb2,:)+preHM(lambias+na+1:2*na,:);
HM(lamb2+1:na,:)=HM(lamb2+1:na,:)+preHM(1:lambias,:);