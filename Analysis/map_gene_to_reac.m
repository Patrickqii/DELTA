function [ Reac_output ] = map_gene_to_reac( Gene_input , Background_Model )
%MAP_GENE_TO_RXN 将基因映射到代谢反应
%{
  input params:
      Gene_input：目标代谢基因,类型为cell
      Background_Model：使用的背景代谢网络模型，该模型中的基因是与代谢相关的基因
 
  output params:
      Reac_output：目标代谢反应

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
%Expression State锟斤拷1 for DEG锟斤拷0 else
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

