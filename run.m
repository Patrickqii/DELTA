
addpath('C:\Users\Administrator\Desktop\My_Research\code\General');
load('C:\Users\Administrator\Desktop\My_Research\data\Recon3D_301\Recon3DModel_301.mat');
%load('C:\Users\Administrator\Desktop\My_Research\data\Recon3D_301\equation.mat');%病毒的生物量合成反应
load('C:\Users\Administrator\Desktop\biomass_covid\biomass\WT\equation_WT_new.mat');%病毒的生物量合成反应
Recon3DModel_inf = addReaction( Recon3DModel,'biomass_virus',cell2mat(equation));

covid_path ='C:\Users\Administrator\Desktop\My_Research\data\covid\result\';
dirs = dir(covid_path);
%读取所有样本目录
file_list={};
for i=1:size(dirs,1)
    isdir=dirs(i).isdir;
    if isdir==1
        name=dirs(i).name;
        if ~isempty(strfind(name,'GSE'))             
            file_list=[file_list;name];
        end
    end
end

if size(file_list,1)==1
    file_list=file_list';
end

for i = 1:size(file_list,1)
    series_name = file_list{i};
    cur_path = strcat(covid_path,series_name,'\');
    disp(cur_path);
    Main_Process( Recon3DModel_inf , cur_path , 'all_Gene-Entrez_up.txt' , 'biomass_virus' , 0 , 1 , 0 , 1 )
end

rmpath('C:\Users\Administrator\Desktop\My_Research\code\General');