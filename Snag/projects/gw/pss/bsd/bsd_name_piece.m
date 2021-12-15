function name_piece=bsd_name_piece(name,prot)
% decodes bsd name pieces
%
%   name_pieces=bsd_name_pieces(name)
%

% Version 2.0 - October 2016
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by O.J.Piccinni and S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

if ~exist('prot','var')
    prot=1;
end

switch prot
    case 1
        ii=strfind(name,'_');
        iii=strfind(name,'_20');
        name_piece.ant=name(1:ii(1)-1);
        name_piece.cal=name(ii(1)+1:ii(2)-1);
        name_piece.date=name(ii(2)+1:ii(3)-1);
        name_piece.fr1=name(ii(3)+1:ii(4)-1);
        name_piece.fr2=name(ii(4)+1:ii(5)-1);
        name_piece.suffix=name(ii(5)+1:length(name));
end