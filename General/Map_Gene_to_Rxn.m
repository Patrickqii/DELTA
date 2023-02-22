function [ Reac_up ] = Map_Gene_to_Rxn( Gene_up , Background_Model , Target_Object , Save_Path , Output_File_Name )
%MAP_GENE_TO_RXN ������ӳ�䵽��л��Ӧ
%{
  input params:
      Gene_up��Ŀ���л����
      Background_Model��ʹ�õı�����л����ģ�ͣ���ģ���еĻ��������л��صĻ���
      Target_Object��Ŀ�꺯��
      Save_Path������ļ���·��
      Output_File_Name������ļ����ļ�����������׺��
  output params:
      Reac_up��Ŀ���л��Ӧ

author:�����
create_date:2021-12-08
last_modify_date:2021-12-08
%}

if nargin < 5 || ~exist('Output_File_Name','var')
    Output_File_Name = 'Reac_up';
end
if ~exist(Save_Path,'dir')
    mkdir(Save_Path);
end

g_up=Gene_up;
GeneState=zeros(1,size(Background_Model.genes,1));
genes=Background_Model.genes;
for j=1:size(genes,1)
    current=genes{j};
    [tf,~]=ismember(current,g_up);
    if tf==1
        GeneState(j)=1;
    end
end
%Expression State��1 for DEG��0 else
ReacState=zeros(1,size(Background_Model.rules,1));
for j=1:size(Background_Model.rules,1)
    ReacState(j)=Private_EvalExpEquation(Background_Model.rules{j},GeneState);
end
r_up=find(ReacState>0);
r_up=r_up';

id=find(ismember(Background_Model.rxns,Target_Object));
r_up=[r_up;id];
Reac_up=sort(r_up);    
save(strcat(Save_Path,'\',Output_File_Name,'.mat'),'Reac_up');
f=fopen(strcat(Save_Path,'\',Output_File_Name,'.txt'),'w');
for j=1:size(Reac_up,1)
    fprintf(f,'%d\r\n',Reac_up(j));
end
fclose(f);
end

