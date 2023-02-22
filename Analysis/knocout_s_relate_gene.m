clear
%敲除S蛋白相关基因，分析变异对VBOF以及靶点预测的影响
%load('C:\Users\Administrator\Desktop\test1\result\Specific_Model.mat')%根据蛋白相互作用关系数据所重建的特异性代谢网络模型
root_path='C:\Users\Administrator\Desktop\My_Research\data\covid\result';
knoc_gene_path='C:\Users\Administrator\Desktop\test1\result\s.txt';
Srelategene=load(knoc_gene_path);
dirs = dir(root_path);
file_list={};
for j=1:size(dirs,1)
    isdir=dirs(j).isdir;
    if isdir==1
        name=dirs(j).name;
        if strfind(name,'_')>0
            file_list=[file_list;name];
        end
    end
end

if size(file_list,1)==1
    file_list=file_list';
end
Result=zeros(size(Srelategene,1)+1,size(file_list,1));
for i = 1:size(file_list,1)
    load(strcat(root_path,'\',file_list{i},'\Specific_Model.mat'))
    Specific_Model=Delete_Gene_Version(Specific_Model);
    
    for j=1:size(Srelategene,1)
        S_relate_gene{j,1}=num2str(Srelategene(j,1));
    end
    result=zeros(size(S_relate_gene,1)+1,1);
    try
        setRavenSolver('mosek');
        solution=solveLPR(Specific_Model);
    catch err
        %如果默认求解器出错，则调用该求解器
        disp(err);
        disp('Use alternate solver');
        changeCobraSolver('ibm_cplex', 'LP', 0);
        solution = optimizeCbModel(Specific_Model, 'max');
        solution.f = -solution.f;
    end
    result(1,1)=solution.f;
    for j=1:size(S_relate_gene,1)
        fclose('all');
        Rgene=S_relate_gene(j,1);
        %需要判断待敲除基因是否存在于模型的基因集中，若不存在，则无影响
        if isempty(find(ismember(Specific_Model.genes,Rgene)))
           result(j+1,1)=result(1,1); 
        else
            [Model_reduced,notDeleted,remove_reaction]=removeGenes(Specific_Model,Rgene);
            try
                setRavenSolver('mosek');
                solution=solveLPR(Model_reduced);
            catch err
                %如果默认求解器出错，则调用该求解器
                disp(Rgene);
                disp(err);
                disp('Use alternate solver');
                changeCobraSolver('ibm_cplex', 'LP', 0);
                solution = optimizeCbModel(Model_reduced, 'max');
                solution.f = -solution.f;
            end
            result(j+1,1)=solution.f;
        end

    end
    Result(:,i)=result;
end
