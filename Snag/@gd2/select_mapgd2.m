function select_mapgd2(img)

[sel ok]=listdlg('PromptString','Select Map Type',...
        'Name','Map Type',...
        'SelectionMode','single',...
        'ListSize',[160 150],...
        'Liststring',{'Map_gd2' 'Map_gd2 with Data Range'});

if sel == 1
    map_gd2(img);
elseif sel == 2
    map_gd2_rng(img);
end

