function [ ess_gene_name ] = Ess_Gene_Test( Specific_Model , Path_Used , Save_Path , Output_File_Name)
%ESS_GENE_TEST ʹ�û����ó�����Ҫ����
%{
  input params:
      Specific_Model�������Դ�л����ģ��
      Path_Used��������ʹ�õ��ĺ������ļ�·��
      Save_Path������ļ���·��
      Output_File_Name�����ɵ�ģ�͵��ļ�����������׺��
  output params:
      ess_gene_name����Ҫ�����б�

author:�����
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

