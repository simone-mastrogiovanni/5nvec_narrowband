function snag_table(A,par)
%SNAG_TABLE  writes a table in a file
% 
%   A(m,n)       the table (n columns, m data each)
%   par          parameter structure (interactive if absent)
%      .fil      filename (absent -> table.txt, 'no' -> on screen)
%      .title    title (or comments); if more lines, a char 10 produces newline 
%                (you may use par.tithe=sprintf('... and \n to go newline)
%      .ictyp    =1 type control on (type(n) must be present)
%      .type(n)  0 (or default) %g, 1 %f.6, 2 %f.9, 3 %e.6, 4 %g.15
%
% To construct the table, e.g., A=[x' y' z'];

% Version 2.0 - January 2006
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

file='table.txt';
notit=1;
nofil=0;
typ=0;

if exist('par')
    if isfield(par,'fil')
        file=par.fil;
    end
    if isfield(par,'ictyp')
        typ=par.ictyp;
    end
    if isfield(par,'title')
        notit=0;
    end
    if strcmp(file,'no')    
        nofil=1;
    end
end

[nr,nc]=size(A);

if typ == 0
    typs=zeros(nc,1);
else
    typs=par.type;
end
%par,typs
if nofil > 0
    disp(par.title)
    for i = 1:nr
        s=' ';
        for j = 1: nc
            switch typs(j)
                case 0
                    s=[s sprintf(' %g ',A(i,j))];
                case 1
                    s=[s sprintf(' %.6f ',A(i,j))];
                case 2
                    s=[s sprintf(' %.9f ',A(i,j))];
                case 3
                    s=[s sprintf(' %.6e ',A(i,j))];
                case 4
                    s=[s sprintf(' %.15g ',A(i,j))];
            end
        end
        disp(s)
    end
else
    fid=fopen(file,'w');
    if notit == 0
        fprintf(fid,'%s \n',par.title);
    end
    for i = 1:nr
        s=' ';
        for j = 1: nc
            switch typs(j)
                case 0
                    s=[s sprintf(' %g ',A(i,j))];
                case 1
                    s=[s sprintf(' %.6f ',A(i,j))];
                case 2
                    s=[s sprintf(' %.9f ',A(i,j))];
                case 3
                    s=[s sprintf(' %.6e ',A(i,j))];
                case 4
                    s=[s sprintf(' %.15g ',A(i,j))];
            end
        end
        fprintf(fid,'%s \n',s);
    end                
    fclose(fid)
end
