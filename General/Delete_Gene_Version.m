function [ Model ] = Delete_Gene_Version( Model )
%DELETE_GENE_VERSION 删除模型的基因版本号
%{
  input params:
      Model：删除基因版本号之前的模型
  output params:
      Model：删除基因版本号之后的模型

author:冯昌奇
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

