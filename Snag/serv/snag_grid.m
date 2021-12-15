function handl=snag_grid(data,par)
% SNAG_GRID  creates a data grid
%
%     data         data (matrix)
%     par          parameter structure
%        .title
%        .rows     rows names (cell array) 
%        .cols     columns names (cell array)
%        .noedit
%        .check    check box (= true or false for base setting)
%
%     handl        handle
%
%  after modifing data, clic elsewhere
%  to access modified data:   dataout=get(handl,'Data');

% Version 2.0 - May 2008
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

[nr,nc]=size(data);

title=0;
cols=0;
rows=0;
edits=logical(ones(1,nc));
if exist('par','var')
    if isfield(par,'title')
        title=par.title;
    end
    if isfield(par,'rows')
        rows=par.rows;
    end
    if isfield(par,'cols')
        cols=par.cols;
    end 
    if isfield(par,'noedit')
        edits=~edits;
    end
    if isfield(par,'check')
        check=par.check;
        edits=[edits true];
        datc=cell(nr,nc+1);
        for ir = 1:nr
            for ic = 1:nc
                datc{ir,ic}=data(ir,ic);
            end
        end
        for ir = 1:nr
            datc{ir,nc+1}=true;
        end
        data=datc;
    end
end

str='fig=figure';
if isstr(title)
    str=[str '(''Name'',''' title ''')'];
end
eval(str);

str='handl=uitable(''Data'',data,''ColumnEditable'',edits';
if iscell(cols)
    str=[str ',''ColumnName'',cols'];
end
if iscell(rows)
    str=[str ',''RowName'',rows'];
end

eval([str ');']);