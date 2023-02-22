function [ Path_Used ] = Create_Path_Used()
%Create_Path_Used %save paths of functions and files thst used in functions

Path_Used=struct();
Path_Used.map_path='..\Data\Recon3D_301\map_ENSG_to_Entrez.xlsx';
Path_Used.cobra_refine_path='I:\MATLAB\toolbox\cobratoolbox\src\reconstruction\refinement';
Path_Used.raven_path='I:\MATLAB\toolbox\RAVEN';
Path_Used.raven_core_path='I:\MATLAB\toolbox\RAVEN-master\core';
Path_Used.raven_solver_path='I:\MATLAB\toolbox\RAVEN-master\solver';
Path_Used.healthy_path='..\Data\Healthy';
Path_Used.acknow_path='..\Data\Recon3D_301\Acknow.mat';
end
