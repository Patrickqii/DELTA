function [ ] = Main_Process( Background_Model , Path , Input_File_Name , Target_Object , Need_Map_Gup , Need_Map_Toxicity , Need_Split_Gup , Need_Split_Toxicity )
%MAIN_PROCESS ������
%{
  input params:
      Background_Model��ʹ�õı�����л����ģ�ͣ���ģ���еĻ��������л��صĻ���
      Path��·��
      Input_File_Name����������ļ����ļ�����txt��ʽ
      Target_Object�����õ�Ŀ�꺯��
      Need_Map_Gup���Ƿ���Ҫ��Select_Gene_Upʱ��ENSG��ʽ�Ļ���ӳ�䵽Entrez��1-��Ҫ��0-����Ҫ��Ĭ��Ϊ0
      Need_Map_Toxicity���Ƿ���Ҫ��Toxicity_Testʱ��Entrez��ʽ�Ļ���ӳ�䵽ENSG��1-��Ҫ��0-����Ҫ��Ĭ��Ϊ1
      Need_Split_Gup���Ƿ���Ҫ��Select_Gene_Upʱ�и����汾�ţ�1-��Ҫ��0-����Ҫ��Ĭ��Ϊ0
      Need_Split_Toxicity���Ƿ���Ҫ��Toxicity_Testʱ�и����汾�ţ�1-��Ҫ��0-����Ҫ��Ĭ��Ϊ1
  output params:

author:�����
create_date:2021-12-08
last_modify_date:2022-01-03
%}

if nargin < 8 || ~exist('Need_Split_Toxicity','var')%exist('x','var')��ʾ����x�������
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

%���溯����ʹ�õ��ĺ������ļ�·��
Path_Used = Create_Path_Used();


%ɾ��ģ�ͻ���İ汾��
Background_Model_splite = Delete_Gene_Version(Background_Model);

%ɸѡ��л����
Map=struct();
Map.bool=0;
if Need_Map_Gup == 1
   [Entrez,ENSG] = xlsread(Path_Used.map_path); 
   Map.bool=1;
   Map.Entrez=Entrez;
   Map.ENSG=ENSG;
end
Gene_up=Select_Gene_Up(Background_Model_splite , Path , Input_File_Name , Path , 'Gene_up' , Map , Need_Split_Gup);

%����ӳ�䵽��Ӧ
Reac_up=Map_Gene_to_Rxn( Gene_up , Background_Model_splite , Target_Object , Path , 'Reac_up' );

%��л�����ع�
Specific_Model=Reconstruction( Reac_up , Background_Model , Target_Object , Path_Used , Path );

%�����ó�
ess_gene_name=Ess_Gene_Test( Specific_Model , Path_Used , Path , 'ess_gene_name');

%���Բ���
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

