function out=add_zeros2tfstr(in,addr)
% adds zeros info to tfstr
%   start from a non-BSD directory
%
%    in    input bsd or table
%    addr  address of the table (in the case of table, e.g. 'I:')
%
%    out   output bsd or number of saved bsd

if istable(in)
    N=length(in.name);
    
    for k = 1:N
        name=in.name{k}; 
        path=in.path{k};
        fprintf('%d  %s \n',k,name)
        
        str=['load(''' addr path name ''')'];
        eval(str)

        path=cpath(path);

        str=['load(''' addr path name ''')'];

        eval(['cont=cont_gd(' name ');'])

        eval(['[zhole, shole]=bsd_holes(' name ');'])
        
        cont.tfstr.zeros=shole;

        eval([name '=edit_gd(' name ',''cont'',cont);'])

        eval(['save('' ' name ''',''' name ''',''-v7.3'')'])
        
        eval(['clear ' name])
    end
    
    out=N;
else
    cont=cont_gd(in);

    [zhole, shole]=bsd_holes(in);

    cont.tfstr.zeros=shole;

    out=edit_gd(in,'cont',cont);
end