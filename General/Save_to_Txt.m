function []=Save_to_Txt(filename,cell)

fid=fopen(filename,'w');
if size(cell,1)==1
    cell=cell';
end
for i=1:size(cell,1)
    fprintf(fid,'%s\r\n',cell{i});
end
fclose(fid);
end
