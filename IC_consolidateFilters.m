%% This part merges filters into one folder called 'Objxx_merged'.

% when asked select the folder that contains the individual IC subfolders.
if ~exist('superRootFolder','var')
    superRootFolder=pwd;
end

rootFolder=uigetdir(superRootFolder);
rootSubdirs=dir(rootFolder);
rootSubdirInds=[rootSubdirs.isdir];
rootSubdirs={rootSubdirs.name};
rootSubdirInds=rootSubdirInds&~(strcmpi(rootSubdirs,'.')|strcmpi(rootSubdirs,'..'));
rootSubdirs=rootSubdirs(rootSubdirInds);

if strcmpi(rootFolder(end),filesep)
    superRootFolder=fileparts(rootFolder(1:end-1));
    
else
    superRootFolder=fileparts(rootFolder);
    rootFolder=[rootFolder,filesep];
end

rootSubdirs=strcat(rootFolder,rootSubdirs, filesep)';

outDir=[rootFolder(1:end-1),'_merged',filesep];

if ~exist(outDir,'dir')
    mkdir(outDir);
end
for i=1:length(rootSubdirs)
    subdirContents=dir(rootSubdirs{i});
    subdirFiles={subdirContents(:).name}';
    subdirFiles=subdirFiles(~[subdirContents.isdir]);
    subdirFilePaths=strcat(rootSubdirs{i},subdirFiles);
    outdirFilePaths=strcat(outDir,subdirFiles);
    for j=1:length(subdirFiles)
        copyfile(subdirFilePaths{j},outdirFilePaths{j});
    end
end

% comment all above if only to consolicate filters

%% this part consolidates filters into a single .mat file.

[ICFilterFile, ICFilterPath]=uigetfile('*.mat');

% when asked select the first '_ICimage' file in the '_merged' folder.

% [ICFilterDir, ICFileName, ICFileExt]=fileparts(ICFilterFilePath);

if isnumeric(ICFilterPath)
    return
end

searchToken=[ICFilterPath,filesep,regexprep(ICFilterFile,'\d+','*')];
% fileList=dir(searchToken);
% fileList={fileList(:).name}';

if strcmpi(ICFilterPath(end),filesep)
    searchToken=[ICFilterPath,regexprep(ICFilterFile,'\d+','*')];
    fileList=dir(searchToken);
    fileList={fileList(:).name}';
    fileList=strcat(ICFilterPath,fileList);
    if length(ICFilterPath)>3
        ICFilterPath=ICFilterPath(1:(end-1));
    end
else
    searchToken=[ICFilterPath,filesep,regexprep(ICFilterFile,'\d+','*')];
    fileList=dir(searchToken);
    fileList={fileList(:).name}';
    fileList=strcat([ICFilterPath,filesep],fileList);
end

if isempty(fileList) || isnumeric(fileList)
    return
end

[ICSuperDir, ICDirName, ~]=fileparts(ICFilterPath);

if ~strcmpi(ICSuperDir(end),filesep)
    ICSuperDir=[ICSuperDir, filesep];
end

outFileName=[ICSuperDir, 'ICFilters_',ICDirName, '_consolidated.mat'];

nFiles=length(fileList);

inStruct=load(fileList{1});
dataSize=size(inStruct.Object.Data);

IcaFilters=zeros([nFiles, dataSize]);

for i=1:nFiles
    inStruct=load(fileList{i});
    IcaFilters(i,:,:)=inStruct.Object.Data;
end

save(outFileName,'IcaFilters');


% 
% 
% 
% [superDir, dirName, ~]=fileparts(ICFilterDir);
% 
% 
% ICSuperDir=fileparts(ICFilterDir);
% 
% if ~strcmpi(ICSuperDir(end),filesep)
%     ICSuperDir=[ICSuperDir, filesep];
% end
% 
% outFileName=[ICSuperDir, filesep,'ICFilters_',dirName, '.mat'];
% 
% fileStruct=dir(ICFilterDir);
% 
% 
% 
% 
