function []=Save_to_Txt(filename,cell)
%��cellԪ�����ݱ��浽txt�ļ���
%{
  input params:
      filename��������ļ�λ�ú��ļ���
      cell��Ҫ��������ݣ�cell��ʽ
  output params:

author:�����
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