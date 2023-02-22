
addpath('..\General');
load('..\Data\equation_WT_new.mat');%SARS-CoV-2 VBOF
Recon3DModel_inf = addReaction( Recon3DModel,'biomass_virus',cell2mat(equation));

covid_path ='..\Data\result\';
if exist(covid_path)==0
    mkdir(covid_path);
end
dirs = dir(covid_path);
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

rmpath('..\General');
