function [ Model ] = Delete_Gene_Version( Model )
%DELETE_GENE_VERSION ɾ��ģ�͵Ļ���汾��
%{
  input params:
      Model��ɾ������汾��֮ǰ��ģ��
  output params:
      Model��ɾ������汾��֮���ģ��

author:�����
create_date:2021-12-08
last_modify_date:2021-12-08
%}

genes = Model.genes;
for i=1:numel(genes)
    x = strsplit(table2array(genes(i,1)),'.');
    genes(i,1) = cellstr(x(1,1));
end
Model.genes = genes;

end

