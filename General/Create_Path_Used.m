function [ Path_Used ] = Create_Path_Used()
%Create_Path_Used 保存函数中使用到的函数和文件路径
%{
  input params:

  output params:
      Path_Used:结构体，保存所有用到的路径

author:冯昌奇
create_date:2022-01-03
last_modify_date:2022-01-03
%}

Path_Used=struct();
Path_Used.map_path='C:\Users\Administrator\Desktop\My_Research\data\Recon3D_301\map_ENSG_to_Entrez.xlsx';
Path_Used.cobra_refine_path='D:\MATLAB\toolbox\cobratoolbox\src\reconstruction\refinement';
Path_Used.raven_path='D:\MATLAB\toolbox\RAVEN';
Path_Used.raven_core_path='D:\MATLAB\toolbox\RAVEN-master\core';
Path_Used.raven_solver_path='D:\MATLAB\toolbox\RAVEN-master\solver';
Path_Used.healthy_path='C:\Users\Administrator\Desktop\My_Research\data\Healthy';
Path_Used.acknow_path='C:\Users\Administrator\Desktop\My_Research\data\Recon3D_301\Acknow.mat';
end