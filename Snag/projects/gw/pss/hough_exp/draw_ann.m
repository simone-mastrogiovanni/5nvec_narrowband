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
betinilut=psspar.lut.ini(kcosfi,kvbet);
res=psspar.hmap.da;vlam;
lambias=ceil(psspar.hmap.na/4);
a360=360;

if ksign > 0
    for i = 0:lenlut-1
        lutval=lutlam(indlut+i);
        klam=ceil((lutval+vlam)/res)+lambias;
        preHM(klam,betinilut+i)=preHM(klam,betinilut+i)-1;
        klam=floor((-lutval+vlam)/res)+lambias+fix(lutval/90)*a360;
        preHM(klam,betinilut+i)=preHM(klam,betinilut+i)+1;
    end
else
    j=lenlut;
    for i = 0:lenlut-1
        j=j-1;
        lutval=lutlam(indlut+i);
        klam=ceil((lutval+vlam)/res)+lambias;
        preHM(klam,betinilut+j)=preHM(klam,betinilut+j)-1;
        klam=floor((-lutval+vlam)/res)+lambias+fix(lutval/90)*a360;
        preHM(klam,betinilut+j)=preHM(klam,betinilut+j)+1;
    end
end

if kcosfi < psspar.lut.ncosfi
    kcosfi=kcosfi+1;
    indlut=psspar.lut.pointer(kcosfi,kvbet);
    lenlut=psspar.lut.len(kcosfi,kvbet);
    betinilut=psspar.lut.ini(kcosfi,kvbet);
    res=psspar.hmap.da;vlam;
    lambias=ceil(psspar.hmap.na/4);

    if ksign > 0
        for i = 0:lenlut-1
            lutval=lutlam(indlut+i);
            klam=floor((lutval+vlam)/res)+lambias;
            preHM(klam,betinilut+i)=preHM(klam,betinilut+i)+1;
            klam=ceil((-lutval+vlam)/res)+lambias+fix(lutval/90)*a360;
            preHM(klam,betinilut+i)=preHM(klam,betinilut+i)-1;
        end
    else
        j=lenlut;
        for i = 0:lenlut-1
            j=j-1;
            lutval=lutlam(indlut+i);
            klam=floor((lutval+vlam)/res)+lambias;
            preHM(klam,betinilut+j)=preHM(klam,betinilut+j)+1;
            klam=ceil((-lutval+vlam)/res)+lambias+fix(lutval/90)*a360;
            preHM(klam,betinilut+j)=preHM(klam,betinilut+j)-1;
        end
    end
end
