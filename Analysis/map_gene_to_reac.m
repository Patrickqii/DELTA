function [ Reac_output ] = map_gene_to_reac( Gene_input , Background_Model )

addpath('..\General');
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

ReacState=zeros(1,size(Background_Model.rules,1));
for j=1:size(Background_Model.rules,1)
    ReacState(j)=Private_EvalExpEquation(Background_Model.rules{j},GeneState);
end
r_up=find(ReacState>0);
r_up=r_up';


Reac_output=sort(r_up);    

rmpath('..\General');
end

