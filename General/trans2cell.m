function[ result ] = trans2cell(doublearray)
%��double����תΪstr��ʽ��cellԪ��
%{
  input params:
      doublearray��double��ʽ������
  output params:
      result�������cell��ʽ����

author:�����
create_date:2021-12-08
last_modify_date:2021-12-08
%}

result = cell(size(doublearray,1),1);
for i = 1:size(doublearray,1)
    result{i} = num2str(doublearray(i));
end
end