clear
load('C:\Users\Administrator\Desktop\My_Research\data\Recon3D_301\Recon3DModel_301.mat')
WT = ['GSE148697_Lung_infect', 'GSE153218_SmallAirway_infect'];
path = 'C:\Users\Administrator\Desktop\My_Research\data\covid\result\GSE148697_Lung_infect\';
%path = 'C:\Users\Administrator\Desktop\COVID-19\result_gamma\GSE171524_Lung_infect\';

target = load(strcat(path,'target.txt'));
load(strcat(path, 'Specific_Model.mat'))

plpbp = {'11212.1'};
plpbp_index=find(ismember(Specific_Model.genes,'11212.1'));%�鿴delta���Ƿ����PLPBP�����еĻ����ҵ�������
plpbp_met = 'ala_D[c]';
plpbp_met_index = find(ismember(Specific_Model.mets, plpbp_met));%d-������������ģ���е�����
plpbp_relate_reac = find(Specific_Model.S(plpbp_met_index,:)>0);%�ҵ�����ģ��������d-������ķ�Ӧ

%��recon3Dģ����ӳ��plpbp�ķ�Ӧ
% plpbp_relate_reac = map_gene_to_reac(plpbp, Recon3DModel);
% plpbp_relate_reac = Recon3DModel.rxns(plpbp_relate_reac);%plpbp��Ӧ��Ӧ��
% plpbp_relate_reac = find(ismember(Specific_Model.rxns, plpbp_relate_reac));
%��Specific_Model��ӳ��plpbp��Ӧ
%plpbp_relate_reac = map_gene_to_reac(plpbp, Specific_Model);
%������Ҫ���ȼ���������з�Ӧ�ó�ʱ�ķ�Ӧͨ��
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

plpbp_relate_reac = plpbp_relate_reac(find(solution.x(plpbp_relate_reac)>1e-6));%�ҵ���ʼ�����������d-��������ͨ����Ϊ0�ķ�Ӧ
%plpbp_flux = solution.x(plpbp_relate_reac);%plpbp��ط�Ӧͨ��,����Ϊcell����
plpbp_relate_reac_name=Specific_Model.rxns(plpbp_relate_reac);

upriver_reac = [];

for i=1:length(target)
    Target{i,1} = num2str(target(i));
end
relate_reac = [];
for i=1:length(Target)
    relate_reac_item = map_gene_to_reac(Target(i), Specific_Model);%ͨ��GPRsӳ��õ���������ģ�Ͱе���ط�Ӧ
    relate_reac = [relate_reac; relate_reac_item];
end

%������Ҫ��һ�ó���Щ��Ӧ��Ҳ���ǽ����ǵ�v��Ϊ0
for i=1:length(relate_reac)
   Specific_Model_sqlite = Specific_Model;
   %����Ӧͨ�������½���0
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
    %�������η�Ӧ���ж�
    if isempty(find(solution.x(plpbp_relate_reac)>1e-6))%��ǰ�е���ػ����ó�֮��d-���������ɷ�Ӧͨ��ȫΪ0
        upriver_reac = [upriver_reac; relate_reac(i)];
    end
end
%����Ӧ��ӡ����������ʹ�ú�������
upriver_reac_name = Specific_Model.rxns(upriver_reac);
disp('hello world')
