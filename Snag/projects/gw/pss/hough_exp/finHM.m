function HM=finHM(psspar,preHM)
%FINHM  finalize the HM starting from the preHM

preHM=cumsum(preHM);

na=ceil(psspar.hmap.na);
nd=psspar.hmap.nd;
lambias=ceil(psspar.hmap.na/4);
lamb2=na-lambias;
lamb1=psspar.lut.dim_preHM-na-lambias;

HM=preHM(lambias+1:lambias+na,:);
HM(1:lamb1,:)=HM(1:lamb1,:)+preHM(lambias+na+1:psspar.lut.dim_preHM,:);
HM(lamb2+1:na,:)=HM(lamb2+1:na,:)+preHM(1:lambias,:);