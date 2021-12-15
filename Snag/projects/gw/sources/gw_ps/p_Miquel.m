function sour=p_Miquel(k)
% PULSAR_3  source parameters
%
% ## Parameter file defining actual PULSAR *SOURCE* PARAMETERS
% ## ---------------------------------------------------------
% refTime         = 751680013             ## pulsar reference time in SSB frame
% 
% aPlus           = 8.1915e-24           ## plus-polarization signal amplitude
% aCross          = -1.313e-24           ## cross-polarization signal amplitude
% psi             = 0.444280306           ## polarization angle psi
% phi0            = 5.53                 ## phase at tRef 
% f0              =  108.8571594     	## GW frequency at tRef
% latitude        =  -0.583578803         ## latitude (delta,declination) in radians
% longitude       =  3.113188712          ## longitude (alpha, right ascension) in radians
% 
% f1dot           = -1.46E-17             ## spindown parameters d/dt f0
% f2dot           = 0.0
% f3dot           = 0.0
%
%  refTime  mjd 52944  01-Nov-2003 00:00:00
%  alpha    178.3726
%  delta    -33.4366

if ~exist('k','var')
    k=1;
end

switch k
    case 1
        disp(' *** Not precise frequency')
        sour.a=4.07261*180/pi;
        sour.d=-0.92342*180/pi;
        sour.f0=356.312;
        sour.df0=2.44011e-10;
    case 2
        disp(' *** Not precise frequency')
        sour.a=241.497;
        sour.d=-37.913;
        sour.f0=356.315;
        sour.df0=3.06763e-11;
    case 3
        disp(' *** Not precise frequency')
        sour.a=4.07629*180/pi;
        sour.d=-1.04731*180/pi;
        sour.f0=356.315;
        sour.df0=-2.94752e-10;
    case 4
        sour.a=4.1026935*180/pi; % 235.067
        sour.d=-0.91564*180/pi;  % -52.462
        sour.f0=356.314921884080;
        sour.df0=1.17227653465300e-10;
end
        

sour.v_a=0;   % marcs/y
sour.v_d=0;   % marcs/y
sour.pepoch=57709-370;
sour.pepoch=57340.78;
sour.ddf0=0;
sour.fepoch=57709-370;
sour.fepoch=57340.78;
sour.ecl=[];

sour.t00=v2mjd([2000,1,1,0,0,0]);
sour.eps=1;
sour.eta=1;
sour.psi=25.439;
sour.h=8.2961e-024;
sour.snr=1;
sour.coord=0;
sour.chphase=0;

sour.dfrsim=-0.2;