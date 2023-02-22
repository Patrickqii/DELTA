function [ess_gene_name,result,Remove_rxns_result,Remove_rxns_name]=Remove_Gene(Model , Path_Used)
% Remove_Gene：利用FBA对模型进行基因敲除，得出敲除后满足使目标函数为0的基因.
%{
  input params:
      Specific_Model：特异性代谢网络模型
      Path_Used：函数中使用到的函数和文件路径
  output params:
      ess_gene_name：必要基因列表
      result:各基因敲除后的目标函数值
      Remove_rxns_result：各基因敲除后被删除的反应
      Remove_rxns_name：各基因敲除后被删除的反应名

author:熊宇峰
create_date:2018-04-12
last_modify_date:2022-01-03
%}

addpath(Path_Used.raven_core_path);
rmpath(Path_Used.raven_path);
addpath(Path_Used.raven_solver_path);
rmpath(Path_Used.cobra_refine_path);

%%%%%%%敲除的一些改变，我们认为敲除该基因后降低到原20%以下的基因为必要基因
% try
%     setRavenSolver('mosek');
%     solutionCtr=solveLPR(Model);
% catch err
%     %如果默认求解器出错，则调用该求解器
%     disp(err);
%     disp('Use alternate solver');
%     changeCobraSolver('ibm_cplex', 'LP', 0);
%     solutionCtr = optimizeCbModel(Model, 'max');
%     solutionCtr.f = -solutionCtr.f;
% end
%%%%%%%
result=zeros(size(Model.genes,1),1);
Remove_rxns_result=cell(size(Model.genes,1),1);
Remove_rxns_name=cell(size(Model.genes,1),1);
%result2=result;
for i=1:size(Model.genes,1)
    fclose('all');
    Rgene=Model.genes(i,1);
    [Model_reduced,notDeleted,remove_reaction]=removeGenes(Model,Rgene);
    %[model, hasEffect, constrRxnNames, deletedGenes] = deleteModelGenes(t, Rgene);
    %solution_Cobra = optimizeCbModel(Model_reduced, 'max');
    
    %在这里也可以用其它方法
    %changeCobraSolver('gurobi','LP');
    %solution2=optimizeCbModel(modelConsistent,'max',1e-6)
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
   
%   solution2=solveLPR(model);
    result(i,1)=solution.f;
    Remove_rxns_result{i,1}=remove_reaction;
    Remove_rxns_name{i,1}=Model.rxns(remove_reaction);
    %result2(i,1)=solution2.f;
    %result(i,2)=solution_Cobra.obj;
 
end
addpath(Path_Used.raven_path);
rmpath(Path_Used.raven_core_path);
rmpath(Path_Used.raven_solver_path);
addpath(Path_Used.cobra_refine_path);
result=-result;
ess_gene1=find(result<1e-6);
%ess_gene1=find(result<abs(0.2*solutionCtr.f));
ess_gene_name=Model.genes(ess_gene1);
Remove_rxns_result=Remove_rxns_result(ess_gene1);
Remove_rxns_name= Remove_rxns_name(ess_gene1);