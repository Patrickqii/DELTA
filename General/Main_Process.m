function [ ] = Main_Process( Background_Model , Path , Input_File_Name , Target_Object , Need_Map_Gup , Need_Map_Toxicity , Need_Split_Gup , Need_Split_Toxicity )
%MAIN_PROCESS 主流程
%{
  input params:
      Background_Model：使用的背景代谢网络模型，该模型中的基因是与代谢相关的基因
      Path：路径
      Input_File_Name：输入基因文件的文件名，txt格式
      Target_Object：设置的目标函数
      Need_Map_Gup：是否需要在Select_Gene_Up时将ENSG格式的基因映射到Entrez，1-需要，0-不需要，默认为0
      Need_Map_Toxicity：是否需要在Toxicity_Test时将Entrez格式的基因映射到ENSG，1-需要，0-不需要，默认为1
      Need_Split_Gup：是否需要在Select_Gene_Up时切割基因版本号，1-需要，0-不需要，默认为0
      Need_Split_Toxicity：是否需要在Toxicity_Test时切割基因版本号，1-需要，0-不需要，默认为1
  output params:

author:冯昌奇
create_date:2021-12-08
last_modify_date:2022-01-03
%}

if nargin < 8 || ~exist('Need_Split_Toxicity','var')%exist('x','var')表示存在x这个变量
    Need_Split_Toxicity = 1;
end
if nargin < 7 || ~exist('Need_Split_Gup','var')
    Need_Split_Gup = 0;
end
if nargin < 6 || ~exist('Need_Map_Toxicity','var')
    Need_Map_Toxicity = 1;
end
if nargin < 5 || ~exist('Need_Map_Gup','var')
    Need_Map_Gup = 0;
end

%保存函数中使用到的函数和文件路径
Path_Used = Create_Path_Used();


%删除模型基因的版本号
Background_Model_splite = Delete_Gene_Version(Background_Model);

%筛选代谢基因
Map=struct();
Map.bool=0;
if Need_Map_Gup == 1
   [Entrez,ENSG] = xlsread(Path_Used.map_path); 
   Map.bool=1;
   Map.Entrez=Entrez;
   Map.ENSG=ENSG;
end
Gene_up=Select_Gene_Up(Background_Model_splite , Path , Input_File_Name , Path , 'Gene_up' , Map , Need_Split_Gup);

%基因映射到反应
Reac_up=Map_Gene_to_Rxn( Gene_up , Background_Model_splite , Target_Object , Path , 'Reac_up' );

%代谢网络重构
Specific_Model=Reconstruction( Reac_up , Background_Model , Target_Object , Path_Used , Path );

%基因敲除
ess_gene_name=Ess_Gene_Test( Specific_Model , Path_Used , Path , 'ess_gene_name');

%毒性测试
Map=struct();
Map.bool=0;
if Need_Map_Toxicity == 1
   [Entrez,ENSG] = xlsread(Path_Used.map_path); 
   Map.bool=1;
   Map.Entrez=Entrez;
   Map.ENSG=ENSG;
end
target=Toxicity_Test( ess_gene_name , Path_Used , Path , 'Toxicity' , 'Target' , Map , Need_Split_Toxicity );

end

