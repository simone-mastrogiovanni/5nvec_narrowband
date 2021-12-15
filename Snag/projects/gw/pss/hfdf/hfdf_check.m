function out = hfdf_check()
% various checks

out=struct();

listprg={...
   'Source' 'Antenna' 'Run' 'Mode'...
   ' ' 'Peak table (show_ptable)' 'Peak table (plot_ptable)' ...
   ' ' 'Hough map (check_hmap)' 'Refinment (hfdf_showref,hfdf_showskyref)' ...
   ' ' 'HFDF structures (ana_hfdf_proc)' ...
   ' ' 'Candidates (hfdf_anacand)' ...
   ' ' 'Jobs (hfdf_checkjob)' 'Prep jobs (hfdf_checkjob_0)' ...
   ' ' 'End'};

cap(1)=0;
j1=1;
n=length(listprg);

for i = 1:n
    lis=listprg{i};
    if lis == ' '
        j1=j1+1;
        cap(j1)=i;
    end
end

out.cap=cap;

cap=[cap n+1];

[sel,ok]=listdlg('PromptString','Check what ?',...
   'Name','hfdf procedure check',...
   'ListSize',[300 300],...
   'SelectionMode','single',...
   'ListString',listprg);

out.sel=sel;

if sel == n
    return
end

for i =1:length(cap)
    if sel < cap(i+1)
        cap1=i;
        sel1=sel-cap(i);
        break
    end
end

out.cap=[cap1 sel1];

switch cap1
    case 1
        switch sel1
            case 1
            case 2
            case 3
            case 4
        end      
    case 2
        switch sel1
            case 1
            case 2
            case 3
            case 4
        end      
    case 3
        switch sel1
            case 1
            case 2
            case 3
            case 4
        end      
    case 4
        switch sel1
            case 1
            case 2
            case 3
            case 4
        end      
    case 5
        switch sel1
            case 1
            case 2
            case 3
            case 4
        end      
    case 6
        switch sel1
            case 1
            case 2
            case 3
            case 4
        end      
end

out1 = hfdf_check();
