function set_random(typ)
%SET_RANDOM  randomly sets the status of random generators
%
%   typ = 1  only rand
%    "  = 2  only randn

if ~exist('typ')
    typ=0;
end

switch typ
    case 1
        rand('state',sum(100*clock));
    case 2
        randn('state',sum(100*clock));
    otherwise
        rand('state',sum(100*clock));
        randn('state',sum(100*clock));
end