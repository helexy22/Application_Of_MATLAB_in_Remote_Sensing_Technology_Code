clear;
path = fullfile(toolboxdir('matlab'),'iofun');
cd(path);

fileList = ls('file*.m')

fileListInfo = dir('file*.m')