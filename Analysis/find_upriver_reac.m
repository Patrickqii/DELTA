clear
load('C:\Users\Administrator\Desktop\My_Research\data\Recon3D_301\Recon3DModel_301.mat')
WT = ['GSE148697_Lung_infect', 'GSE153218_SmallAirway_infect'];
path = 'C:\Users\Administrator\Desktop\My_Research\data\covid\result\GSE148697_Lung_infect\';
%path = 'C:\Users\Administrator\Desktop\COVID-19\result_gamma\GSE171524_Lung_infect\';

target = load(strcat(path,'target.txt'));
load(strcat(path, 'Specific_Model.mat'))

plpbp = {'11212.1'};
plpbp_index=find(ismember(Specific_Model.genes,'11212.1'));%查看delta中是否存在PLPBP基因，有的话，找到其索引
plpbp_met = 'ala_D[c]';
plpbp_met_index = find(ismember(Specific_Model.mets, plpbp_met));%d-丙氨酸在特异模型中的索引
plpbp_relate_reac = find(Specific_Model.S(plpbp_met_index,:)>0);%找到特异模型中生成d-丙氨酸的反应

%以recon3D模型来映射plpbp的反应
% plpbp_relate_reac = map_gene_to_reac(plpbp, Recon3DModel);
% plpbp_relate_reac = Recon3DModel.rxns(plpbp_relate_reac);%plpbp对应反应名
% plpbp_relate_reac = find(ismember(Specific_Model.rxns, plpbp_relate_reac));
%以Specific_Model来映射plpbp反应
%plpbp_relate_reac = map_gene_to_reac(plpbp, Specific_Model);
%下面需要首先计算出不进行反应敲除时的反应通量
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
    relate_reac_item = map_gene_to_reac(Target(i), Specific_Model);%通过GPRs映射得到该特异性模型靶点相关反应
    relate_reac = [relate_reac; relate_reac_item];
end

%下面需要逐一敲除这些反应，也就是将它们的v设为0
for i=1:length(relate_reac)
   Specific_Model_sqlite = Specific_Model;
   %将反应通量的上下界设0
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
    %对于上游反应的判断
    if isempty(find(solution.x(plpbp_relate_reac)>1e-6))%当前靶点相关基因敲除之后，d-丙氨酸生成反应通量全为0
        upriver_reac = [upriver_reac; relate_reac(i)];
    end
end
%将反应打印出来，后续使用函数操作
upriver_reac_name = Specific_Model.rxns(upriver_reac);
disp('hello world')
