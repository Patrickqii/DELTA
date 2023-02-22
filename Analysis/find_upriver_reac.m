clear
load('..\Data\Recon3D_301\Recon3DModel_301.mat')
path = '..\Data\result\GSE148697_Lung_infect\';

target = load(strcat(path,'target.txt'));
load(strcat(path, 'Specific_Model.mat'))

plpbp = {'11212.1'};
plpbp_index=find(ismember(Specific_Model.genes,'11212.1'));
plpbp_met = 'ala_D[c]';
plpbp_met_index = find(ismember(Specific_Model.mets, plpbp_met));
plpbp_relate_reac = find(Specific_Model.S(plpbp_met_index,:)>0);


try
    setRavenSolver('mosek')
    solution = solveLPR(Specific_Model);
catch err
   disp(err);
   disp('Use alternate slover');
   changeCobraSolver('ibm_cplex', 'LP',0);
   solution = optimizeCbModel(Specific_Model, 'max');
   solution.f = -solution.f;
end
solution_init = solution;

plpbp_relate_reac = plpbp_relate_reac(find(solution.x(plpbp_relate_reac)>1e-6));%找到初始求解结果中生成d-丙氨酸且通量不为0的反应
%plpbp_flux = solution.x(plpbp_relate_reac);%plpbp相关反应通量,类型为cell数组
plpbp_relate_reac_name=Specific_Model.rxns(plpbp_relate_reac);

upriver_reac = [];

for i=1:length(target)
    Target{i,1} = num2str(target(i));
end
relate_reac = [];
for i=1:length(Target)
    relate_reac_item = map_gene_to_reac(Target(i), Specific_Model);
    relate_reac = [relate_reac; relate_reac_item];
end


for i=1:length(relate_reac)
   Specific_Model_sqlite = Specific_Model;

   Specific_Model_sqlite.lb(relate_reac(i)) = 0;
   Specific_Model_sqlite.ub(relate_reac(i)) = 0;
   try
    setRavenSolver('mosek')
    solution = solveLPR(Specific_Model_sqlite);
    catch err
       disp(err);
       disp('Use alternate slover');
       changeCobraSolver('ibm_cplex', 'LP',0);
       solution = optimizeCbModel(Specific_Model_sqlite, 'max');
       solution.f = -solution.f;
    end

    if isempty(find(solution.x(plpbp_relate_reac)>1e-6))
        upriver_reac = [upriver_reac; relate_reac(i)];
    end
end

upriver_reac_name = Specific_Model.rxns(upriver_reac);
disp('hello world')
