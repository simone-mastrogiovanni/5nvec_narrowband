function [C nrows]=data2cell(title,hcols,A)
% DATA2CELL  put data in cell arrays (for Excel)
%
%  title    cell array with title rows
%  hcols    column headers
%  A        data (rows,cols)

[i1 i2]=size(A);
i3=length(hcols);
i4=length(title);
ir=1;

for i = 1:i4
    ir=blank_cell_34(i2,ir);
    C{i,1}=title{i};
end

ir=blank_cell_34(i2,ir);
ir=blank_cell_34(i2,ir);
for j = 1:min(i2,i3)
    C{ir-1,j}=hcols{j};
end

for i = 1:i1
    for j = 1:i2
        C(i+ir-1,j)=num2cell(A(i,j));
    end
end

nrows=ir+i1-1;



function ir=blank_cell_34(i2,ir)

for j = 1:i2
    C{ir,j}=' ';
end
ir=ir+1;
