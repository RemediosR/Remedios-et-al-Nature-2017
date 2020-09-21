%Load the original .mat file with the IC Filters, and then load the Excel
%file with the good ICs. This will output a new .mat file with the suffix
%'_GoodICs' attached containing only the ICs that were listed in the Excel
%file.

[ICFiltersFile,ICFiltersFilePath]=uigetfile('*.mat');
[ICGoodFile,ICGoodFilePath]=uigetfile([ICFiltersFilePath,'*.xlsx']);

ICFiltersFile=[ICFiltersFilePath,ICFiltersFile];
ICGoodFile=[ICGoodFilePath,ICGoodFile];

ICFilters=load(ICFiltersFile);
IcaFilters=ICFilters.IcaFilters;

ICGood=xlsread(ICGoodFile);

IcaFilters=IcaFilters(ICGood,:,:);

[pn,fn,en]=fileparts(ICFiltersFile);

fn=[fn,'_GoodICs'];
if ~strcmpi(pn(end),filesep)
    pn=[pn,filesep];
end
outFileName=[pn,fn,en];

save(outFileName,'IcaFilters');
