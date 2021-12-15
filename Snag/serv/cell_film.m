function cell_film(cin,paus,typ)
% shows images in cell array
%
%   cin    input cell array
%   paus   pause (s)
%   typ    type (1 log)

% Version 2.0 - September 2016
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

if ~exist('typ','var')
    typ=0;
end
typ
n=length(cin);
figure

for i = 1:n
    cc=cin{i};
    if isa(cc,'gd2')
        op=0;
        if typ == 1
            op=1;
        end
        image_gd2(cc,0,op)
    else
        if typ == 0
            plot(cc);
        else
            semilogy(cc);
        end
    end
    grid on;title(sprintf('item %d',i));
    pause(paus)
end