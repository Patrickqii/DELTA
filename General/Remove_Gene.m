function [ess_gene_name,result,Remove_rxns_result,Remove_rxns_name]=Remove_Gene(Model , Path_Used)
%Knockdown of the model using FBA to derive genes that satisfy the knockdown such that the objective function is 0

addpath(Path_Used.raven_core_path);
rmpath(Path_Used.raven_path);
addpath(Path_Used.raven_solver_path);
rmpath(Path_Used.cobra_refine_path);


result=zeros(size(Model.genes,1),1);
Remove_rxns_result=cell(size(Model.genes,1),1);
Remove_rxns_name=cell(size(Model.genes,1),1);
%result2=result;
for i=1:size(Model.genes,1)
    fclose('all');
    Rgene=Model.genes(i,1);
    [Model_reduced,notDeleted,remove_reaction]=removeGenes(Model,Rgene);

    try
        setRavenSolver('mosek');
        solution=solveLPR(Model_reduced);
    catch err
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
