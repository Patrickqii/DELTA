function [ Gene_up ] = Select_Gene_Up( Background_Model , Load_Path , Input_File_Name , Save_Path , Output_File_Name , Need_Map , Need_Split )
%SELECT_GENE_UP 从基因集合中提取出与代谢相关的基因
%{
  input params:
      Background_Model：使用的背景代谢网络模型，该模型中的基因是与代谢相关的基因
      Load_Path：输入文件的路径
      Input_File_Name：输入文件的文件名
      Save_Path：输出文件的路径
      Output_File_Name：输出文件的文件名（不含后缀）
      Need_Map：结构体，bool属性表示是否需要将ENSG格式的基因映射到Entrez，1-需要，0-不需要，默认为0。ENSG和Entrez为映射关系，若bool=0则无该属性。
      Need_Split：基因是否需要切割版本号，1-需要，0-不需要，默认为0
  output params:
      Gene_up：目标代谢基因

author:冯昌奇
create_date:2021-12-08
last_modify_date:2022-01-03
%}

if nargin < 7 || ~exist('Need_Split','var')
    Need_Split = 0;
end
if nargin < 6 || ~exist('Need_Map','var')
    Need_Map = struct();
    Need_Map.bool = 0;
end
if nargin < 5 || ~exist('Output_File_Name','var')
    Output_File_Name = 'Gene_up';
end
if ~exist(Save_Path,'dir')
    mkdir(Save_Path);
end

up_file = strcat(Load_Path,'\',Input_File_Name);
fid=fopen(up_file);
tline = fgetl(fid);

up_gene = {};

while(ischar(tline))
    str=tline;
    if Need_Split==1
        str=regexp( str, '\w+',  'match' );%\w寻找a-z、A-Z、0-9及下划线等单词字符
        str=str(1);
    end
    up_gene=[up_gene;str];
    tline=fgetl(fid);%读取下一行
end
fclose(fid);
genes=Background_Model.genes;
if Need_Map.bool==1
    ENSG=Need_Map.ENSG;
    Entrez=Need_Map.Entrez;
    [~,loc]=ismember(up_gene,ENSG);
    r=find(loc>0);
    up_gene=Entrez(loc(r));
    up_gene=trans2cell(up_gene);
    clear r
end

[tf,~] = ismember(up_gene,genes);
r=find(tf>0);
Gene_up = up_gene(r);

save(strcat(Save_Path,'\',Output_File_Name,'.mat'),'Gene_up');
Save_to_Txt(strcat(Save_Path,'\',Output_File_Name,'.txt'),Gene_up);
end

