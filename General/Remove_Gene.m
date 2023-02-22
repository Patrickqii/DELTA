function [ess_gene_name,result,Remove_rxns_result,Remove_rxns_name]=Remove_Gene(Model , Path_Used)
% Remove_Gene������FBA��ģ�ͽ��л����ó����ó��ó�������ʹĿ�꺯��Ϊ0�Ļ���.
%{
  input params:
      Specific_Model�������Դ�л����ģ��
      Path_Used��������ʹ�õ��ĺ������ļ�·��
  output params:
      ess_gene_name����Ҫ�����б�
      result:�������ó����Ŀ�꺯��ֵ
      Remove_rxns_result���������ó���ɾ���ķ�Ӧ
      Remove_rxns_name���������ó���ɾ���ķ�Ӧ��

author:�����
create_date:2018-04-12
last_modify_date:2022-01-03
%}

addpath(Path_Used.raven_core_path);
rmpath(Path_Used.raven_path);
addpath(Path_Used.raven_solver_path);
rmpath(Path_Used.cobra_refine_path);

%%%%%%%�ó���һЩ�ı䣬������Ϊ�ó��û���󽵵͵�ԭ20%���µĻ���Ϊ��Ҫ����
% try
%     setRavenSolver('mosek');
%     solutionCtr=solveLPR(Model);
% catch err
%     %���Ĭ���������������ø������
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
    
    %������Ҳ��������������
    %changeCobraSolver('gurobi','LP');
    %solution2=optimizeCbModel(modelConsistent,'max',1e-6)
    try
        setRavenSolver('mosek');
        solution=solveLPR(Model_reduced);
    catch err
        %���Ĭ���������������ø������
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