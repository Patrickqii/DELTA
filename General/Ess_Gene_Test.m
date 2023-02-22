function [ ess_gene_name ] = Ess_Gene_Test( Specific_Model , Path_Used , Save_Path , Output_File_Name)
%ESS_GENE_TEST 使用基因敲除检测必要基因
%{
  input params:
      Specific_Model：特异性代谢网络模型
      Path_Used：函数中使用到的函数和文件路径
      Save_Path：输出文件的路径
      Output_File_Name：生成的模型的文件名（不含后缀）
  output params:
      ess_gene_name：必要基因列表

author:冯昌奇
create_date:2021-12-08
last_modify_date:2021-12-17
%}

if nargin < 4 || ~exist('Output_File_Name','var')
    Output_File_Name = 'ess_gene_name';
end
if ~exist(Save_Path,'dir')
    mkdir(Save_Path);
end

[ess_gene_name,result,Remove_rxns_result,Remove_rxns_name]=Remove_Gene(Specific_Model , Path_Used);
if size(ess_gene_name,1)==1
    ess_gene_name=ess_gene_name';
end
save(strcat(Save_Path,'\',Output_File_Name,'.mat'),'ess_gene_name');
Save_to_Txt(strcat(Save_Path,'\',Output_File_Name,'.txt'),ess_gene_name);
end

