function psspar=pss_crea_lut(psspar)
%PSS_CREA_LUT  creates a lut for the HM
%
%    psspar.lut   lut sub-structure (0 fixed, 1 input, 2 derived, 3 analysis results):
%
%    The access to the lut can be done in real mode and in virtual
%    mode; in real mode the lut is used as is, in virtual mode it is used
%    by interpolation. The choice is the dband value.
%            THE ANGLES OF THIS STRUCTURE ARE IN DEGREES
%
%  1 lut.dband      lut Doppler band (in frequency bins)
%  2 lut.real       =1 if real mode, otherwise virtual, the ratio between the real
%                   Doppler band and the lut's
%  1 lut.minbeta    minimal HM eclipt. latitude
%  1 lut.betares    ecl. latitude resolution
%  1 lut.nbeta      number of betas
%
%  2 lut.nvb        number of the betas of the detector velocity
%                    (0->0.36 deg; only one half)
%  2 lut.ncosfi     number of cos(fi), i.e. separation lines for the
%                     annuli
%  2 lut.dvb        vb resolution
%  2 lut.dcosfi     cosfi resolution
%
%  2 lut.len(ncosfi,nvb)       length of the lam vector piece (vertical diameter)
%  2 lut.ini(ncosfi,nvb)       beta start index
%  2 lut.pointer(ncosfi,nvb)   pointer to lut
%
%  2 lut.n          Sum(vert. diameters)
%  2 lut.lam(n)     annuli lambda starting points (deg)
%
%  *** This program works only with ecliptical coordinates, full sky search ***
%
% Procedure:
%
% The basic task of the lut is to draw circles on a rectangular map of the
% sky. 
%
% The lut is composed of real numbers that are the lambdas of the countours of 
% the boundaries of the annuli of the biunivocal mapping.
%
% To create and use a lut, the only information derived by the intrinsic parameters
% of the Hough Map is the beta resolution (minimum beta and number of betas is for
% the case of non-full sky).
%
% The access to the lut is by the integer variables kcosfi and kvb:
%    kcosfi (1->ncosfi)
%    kvb    (1->nvb)
% With these values, len, ini and pointer are obtained:
%    len        number of lambda values for that circle
%    ini        the index of the beta for the first lambda
%    pointer    the index of the whole lam vector for the first lambda
% So the lam values (the real number for the lambdas of a circle) are
% accessible.
%
% A lut is defined by ncosfi and nvb, so it works if the investigated f0,
% with the given parameters, gives ncosfi and nvb. When these values
% change, a new lut should be used.
%
% Remember that MatLab stores matrices by columns, so it is important to
% use the column index (the second) for the thing that changes more slowly,
% i.e. the detector velocity.
%
% The lut is created starting from the lower (positive) value of vb and the lower
% value of kcosfi, that is the higher redshift place, so the place at -180^ 
% (the concavity is toward right). The radius is growing at the beginning.


if psspar.hmap.type ~= 1
    disp(' *** This program works only with ecliptical coordinates !');
    return
end

if psspar.hmap.a1 ~= 0 | ...
        psspar.hmap.a2 ~= 360 | ...
        psspar.hmap.d1 ~= -90 | ...
        psspar.hmap.d2 ~= 90
    disp(' *** This program works only with full sky search !');
    return
end

rad2deg=180/pi;
deg2rad=pi/180;

% standard definition of the bets (see pss_hough)
nb=psspar.hmap.nd;    
b1=psspar.hmap.d1*deg2rad;
db=psspar.hmap.dd*deg2rad;
bets=b1+(0:nb-1).*db;  % in rads

lut.dband=round(psspar.band.natb/psspar.fft.df);
lut.real=1.;
lut.minbeta=psspar.hmap.d1;
lut.betares=psspar.hmap.dd;
lut.nbeta=round((psspar.hmap.d2-psspar.hmap.d1)/psspar.hmap.dd);

basvb=0.37*cos(psspar.phys.deg2rad*psspar.antenna.lat); % half band of v_beta
lut.dvb=psspar.hmap.dd/2;  % doubling the resolution to reduce digit. error
nbasvb=floor(basvb/lut.dvb);
lut.nvb=nbasvb+1;
dvb=basvb/lut.nvb;
b0=(0.5:(lut.nvb-0.5))*dvb*deg2rad;
semidband=floor(lut.dband/2);
lut.ncosfi=2*semidband+1;
lut.dcosfi=2/lut.ncosfi;
lut.kcosfi0=semidband+1;

cosfi=((1:lut.ncosfi)-lut.kcosfi0)*lut.dcosfi;

lut.len=zeros(lut.ncosfi,lut.nvb);
lut.ini=zeros(lut.ncosfi,lut.nvb);
lut.pointer=zeros(lut.ncosfi,lut.nvb);
tot=1;
lut.n=0;
graph=0;

for i = 1:lut.nvb
    for j = 1:lut.ncosfi
        [lam,ini]=semicirc(b0(i),cosfi(j),bets,graph);
        len=length(lam);
        lut.len(j,i)=len;
        lut.n=lut.n+len;
        lut.pointer(j,i)=tot;
        lut.ini(j,i)=ini;
        lut.lam(tot:tot+len-1)=lam;
        tot=tot+len;
        if graph ~= 0
            plot(lam,bets(ini:ini+len-1)*rad2deg,'r'),hold on, grid on
        end
    end
end

psspar.lut=lut;