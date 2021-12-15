function gout=change_tasc(gin,typ)
%CHANGE_TASC  changes the time abscissa
%
%  gin,gout    input, output gd
%  typ         type of conversion (0 or absent -> interactive choice)
%
%  output types:
%     1    s from natural beginning
%     2    s from the beginning of the century
%     3    s from the beginning of the year
%     4    s from the beginning of the day
%     5    s from the beginning of the hour
%     6    s from the beginning of the minute
%     7    s from 0
%    11    d from natural beginning
%    12    d from the beginning of the century
%    13    d from the beginning of the year
%    14    d from the beginning of the day
%    17    d from 0
%
%  type   bias   
%    1      +0    input time is mjd
%    2    +100    input time is gps s
%
% The leapsecond correction for gps time is not done
%
% P.G.:
%   inptyp,outyp = (1,2) --> (s,d)

% Version 2.0 - June 2003
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

gpsmjd=44244;
t2000=51544;

if ~exist('typ')
    typ=0;
end

if typ == 0
    inptyp=1;
    bias=0;
    if ini_gd(gin) < 1000000
        inptyp=2;
        bias=100;
    end
else
    inptyp=ceil(typ/100);
    bias=(inptyp-1)*100;
end

dt=dx_gd(gin);
ini=ini_gd(gin);
td=ini;
ts=ini;

strbutt='Is the input data in gps seconds ?';
if inptyp == 2
    strbutt='Is the input data in mjd (modified juliane date) ?';
end

butt=questdlg(strbutt,'Type of input time abscissa','Yes','No','Yes');
if strcmp(butt,'No')
   disp('Default changed');
   inptyp=3-inptyp;
   bias=(inptyp-1)*100;
end

if inptyp == 1
    td=td/86400+gpsmjd;
    ts=ts+gpsmjd*86400;
elseif inptyp == 2
    ts=ts*86400;
end

outtyp=1;
if typ == 0
    s = listdlg('PromptString','Output time abcissa :',...
                'SelectionMode','single',...
                'ListString',{ ...
                    's - natural beginning' ...
                    's - beginning of the century' ...
                    's - beginning of the year' ...
                    's - beginning of the day' ...
                    's - beginning of the hour' ...
                    's - beginning of the minute' ...
                    's - init at 0' ...
                    'd - natural beginning' ...
                    'd - beginning of the century' ...
                    'd - beginning of the year' ...
                    'd - beginning of the day' ...
                    'd - init at 0'});
    typ=s;
    switch s
        case 8
            typ=11;
        case 9
            typ=12;
        case 10
            typ=13;
        case 11
            typ=14;
        case 12
            typ=17;
    end
else
    typ=typ-bias;
end

if typ > 10
    outtyp=2;
end

if inptyp > outtyp
    dt=dt*86400;
elseif inptyp < outtyp
    dt=dt/86400;
end

gout=gin;

switch typ
    case 1
        if inptyp == 2
            ini=ini*86400;
        end
    case 2
        ini=ts-t2000*86400;
    case 3
        ye=mjd2v(td);
        ini=ts-mjdyear(ye(1))*86400;
    case 4
        ye=mjd2v(td);
        ini=ts-v2mjd([ye(1) ye(2) ye(3) 0 0 0])*86400;
    case 5
        ye=mjd2v(td);
        ini=ts-v2mjd([ye(1) ye(2) ye(3) ye(4) 0 0])*86400;
    case 6
        ye=mjd2v(td);
        ini=ts-v2mjd([ye(1) ye(2) ye(3) ye(4) ye(5) 0])*86400;
    case 7
        ini=0;
    case 11
        ini=td;
    case 12
        ini=td-t2000;
    case 13
        ye=mjd2v(td);
        ini=td-mjdyear(ye(1));
    case 14
        ini=td-floor(td);
    case 17
        ini=0;
end

gout=edit_gd(gout,'dx',dt,'ini',ini,'addcapt','change time abscissa on:');