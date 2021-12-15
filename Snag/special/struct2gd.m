function g=struct2gd(s)
% STRUCT2GD  creates a gd from a structure
%
%      g=struct2gd(s)

g=gd(s.y);
g=edit_gd(g,'ini',s.ini,'dx',s.dx,'cont',s.cont,'capt',s.capt);

if s.type == 2
    g=edit_gd(g,'x',s.x);
end