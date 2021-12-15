function rgb=p2rgb(p,typ)
% creates an rgb terne
%
%    rgb=p2rgb(p)
%
%   p     0->1
%   typ   type

% Version 2.0 - October 2012
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

if ~exist('typ','var')
    typ=0;
end

switch typ
    case 0
        r=0;g=0;b=0;
        if p < 1/8
            b=0.5*(1+8*p);
        elseif p >= 1/8 && p < 3/8
            b=1;
            g=4*(p-1/8);
        elseif p >= 3/8 && p < 5/8
            b=1-4*(p-3/8);
            g=1;
            r=4*(p-3/8);
        elseif p >= 5/8 && p < 7/8
            r=1;
            g=1-4*(p-5/8);
        else
            r=1-4*(p-7/8);
        end
        
        rgb=[r g b];
    case 1
        redg=0.75;
        if p > 1
            fprintf('rgb %f value not valid \n',p);
            p=1;
        end
        if p < 0
            fprintf('rgb %f value not valid \n',p);
            p=0;
        end
        if p <= 0.5
            r=0;
            g=p*2*redg;
            b=1-g;
        else
            r=(p-0.5)*2;
            g=(1-r)*redg;
            b=0;
        end

        rgb=[r g b];
        rgb=rgb/max(rgb);
        % red=((p*(1-p))^0.25+1)/2;
        red=1;
        if p < 1/8
            red=0.5+p*4;
        end
        if p > 7/8
            red=0.5+(1-p)*4;
        end
        rgb=rgb*red;
end