function [ Reac_output ] = map_gene_to_reac( Gene_input , Background_Model )
%MAP_GENE_TO_RXN ������ӳ�䵽��л��Ӧ
%{
  input params:
      Gene_input��Ŀ���л����,����Ϊcell
      Background_Model��ʹ�õı�����л����ģ�ͣ���ģ���еĻ��������л��صĻ���
 
  output params:
      Reac_output��Ŀ���л��Ӧ

author:patrick qi
create_date:2022-7-28
last_modify_date:2022-7-28
%}
addpath('C:\Users\Administrator\Desktop\My_Research\code\General');
g_up=Gene_input;
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

%id=find(ismember(Background_Model.rxns,Target_Object));
%r_up=[r_up;id];
Reac_output=sort(r_up);    
%save(strcat(Save_Path,'\',Output_File_Name,'.mat'),'Reac_output');
%f=fopen(strcat(Save_Path,'\',Output_File_Name,'.txt'),'w');
%for j=1:size(Reac_output,1)
%    fprintf(f,'%d\r\n',Reac_output(j));
%end
%fclose(f);
rmpath('C:\Users\Administrator\Desktop\My_Research\code\General');
end

