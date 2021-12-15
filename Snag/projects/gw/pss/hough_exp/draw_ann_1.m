function preHM=draw_ann(psspar,preHM,lutlam,kcosfi,kvbet,vlam,ksign)
%DRAW_ANN  draws an annulus in the preHM
%
%     preHM=draw_ann(psspar,preHM,lutlam,kcosfi,kvbet,vlam,ksign)
%
%   preHM    the pre-Hough map: a matrix with dimension (nlam*1.5, nbet)
%
%   psspar   the psspar structure
%   lutlam   the lut
%   kcosfi   the index of the lut
%   kvbet    index of the lut for the v_beta
%   vlam     lambda of the detector velocity
%   ksign    sign of v_beta (1 or -1)

indlut=psspar.lut.pointer(kcosfi,kvbet);
lenlut=psspar.lut.len(kcosfi,kvbet);
betinilut=psspar.lut.ini(kcosfi,kvbet)-1;
res=psspar.hmap.da;vlam;
lambias=ceil(psspar.hmap.na/4);
a360=360;
finlut=indlut+lenlut-1;

klam=ceil((lutlam(indlut:finlut)+vlam)/res)+lambias;
klam1=ceil((-lutlam(indlut:finlut)+vlam)/res)+lambias+floor(lutlam(indlut:finlut)/90)*a360;

if ksign > 0
    for i = 1:lenlut
        preHM(klam(i),betinilut+i)=preHM(klam(i),betinilut+i)-1;
        preHM(klam1(i),betinilut+i)=preHM(klam1(i),betinilut+i)+1;
    end
else
    j=lenlut;
    for i = 1:lenlut
        j=j-1;
        preHM(klam(i),betinilut+j)=preHM(klam(i),betinilut+j)-1;
        preHM(klam1(i),betinilut+j)=preHM(klam1(i),betinilut+j)+1;
    end
end

if kcosfi < psspar.lut.ncosfi
    kcosfi=kcosfi+1;
    indlut=psspar.lut.pointer(kcosfi,kvbet);
    lenlut=psspar.lut.len(kcosfi,kvbet);
    betinilut=psspar.lut.ini(kcosfi,kvbet)-1;
    res=psspar.hmap.da;vlam;
    lambias=ceil(psspar.hmap.na/4);
    finlut=indlut+lenlut-1;
    
    klam=ceil((lutlam(indlut:finlut)+vlam)/res)+lambias;
    klam1=ceil((-lutlam(indlut:finlut)+vlam)/res)+lambias+floor(lutlam(indlut:finlut)/90)*a360;

    if ksign > 0
        for i = 1:lenlut
            preHM(klam(i),betinilut+i)=preHM(klam(i),betinilut+i)+1;
            preHM(klam1(i),betinilut+i)=preHM(klam1(i),betinilut+i)-1;
        end
    else
        j=lenlut;
        for i = 1:lenlut
            j=j-1;
            preHM(klam(i),betinilut+j)=preHM(klam(i),betinilut+j)+1;
            preHM(klam1(i),betinilut+j)=preHM(klam1(i),betinilut+j)-1;
        end
    end
end
