function gout=show_phase_diagram(gin,convx,col,wid)
%
%   convx  conversion factor
%          e.g. =15  deg to hour
%   col    a string with 'r', or 'g.', etc. (can be absent)

if ~exist('convx','var')
    convx=1;
end

if ~exist('wid','var')
    wid=1;
end

gout=edit_gd(gin,'dx',dx_gd(gin)/convx);

if ~exist('col','var')
    plot(gout),xlim([0 max(x_gd(gout))]);
else
%     str=sprintf('plot(gout,''%s'',''LineWidth'',%d)',col,wid)
%     str=['plot(gout,''' col ''',''LineWidth'',' num2str(wid) ')']
    str=['p=plot(gout,''' col ''')'];
    eval(str),xlim([0 max(x_gd(gout))]);
    eval(['set(p,''LineWidth'',' num2str(wid) ')']);
end

switch convx
    case 15
        xlabel('Hours'),xlim([0 24])
    case 1
        xlabel('Degrees'),xlim([0 360])
end

