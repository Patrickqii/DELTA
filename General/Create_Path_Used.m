function [ Path_Used ] = Create_Path_Used()
%Create_Path_Used ���溯����ʹ�õ��ĺ������ļ�·��
%{
  input params:

  output params:
      Path_Used:�ṹ�壬���������õ���·��

author:�����
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