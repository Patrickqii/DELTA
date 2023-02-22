function []=Save_to_Txt(filename,cell)
%将cell元组内容保存到txt文件中
%{
  input params:
      filename：输出的文件位置和文件名
      cell：要输出的数据，cell格式
  output params:

author:冯昌奇
create_date:2021-12-08
last_modify_date:2021-12-08
%}

fid=fopen(filename,'w');
if size(cell,1)==1
    cell=cell';
end
for i=1:size(cell,1)
    fprintf(fid,'%s\r\n',cell{i});
end
fclose(fid);
end