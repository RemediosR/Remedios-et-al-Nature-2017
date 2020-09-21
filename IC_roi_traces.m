
% Extracts traces by drawing ROIs on the HDF5 data file

% requires 1)ICFilters.mat,  2).h5 file
%NOTE: Requires that XY dimensions of the .mat and .h5 files are identical.

clear   %useful to purge any .h5 hogging the memory

rootDirectory='G:\ox01\day1 b\concat\ROItraces';  %change for every experiment
IC_filters_file='ICFilters_consolidated.mat';
h5_movie_file='dFF_concat.h5';
roiHalfWidth=3; % (+-) this sets the number of pixels for the ROI

roi_traces_file='ROI_traces.mat';
roi_position_file='ROI_rectangle_positions.mat';

if ~strcmpi(rootDirectory(end),filesep)
    rootDirectory=[rootDirectory,filesep];
end
IC_filters_file=[rootDirectory,IC_filters_file];
h5_movie_file=[rootDirectory,h5_movie_file];
roi_traces_file=[rootDirectory,roi_traces_file];
roi_position_file=[rootDirectory,roi_position_file];


IcaFilters=load(IC_filters_file);
IcaFilters=IcaFilters.IcaFilters;
try
    h5Movie=h5read(h5_movie_file,'/Object'); % Mosaic data under '/Object', controller_Preprocess under '/1'.
catch
    h5Movie=hdf5read(h5_movie_file,'/Object'); % Mosaic data under '/Object', controller_Preprocess under '/1'.
end
IcaFilters=permute(IcaFilters,[3,2,1]); %restructuring (orig 2,3,1)

nFrames=size(h5Movie,3);
nFilters=size(IcaFilters,3);
xMax=size(IcaFilters,1); % if dimensions mismatch error change to 2
yMax=size(IcaFilters,2); % if dimensions mismatch error change to 1
xMin=1;
yMin=1;

[xCoords,yCoords]=deal(zeros(nFilters,1));
roiIndList=cell(nFilters,2);

roiTraces=zeros(nFrames,nFilters);

%Get traces
for k=1:nFilters
    [i,j]=ind2sub(size(IcaFilters(:,:,k)),find(IcaFilters(:,:,k)==max(max(IcaFilters(:,:,k)))));
    xCoords(k)=j;
    yCoords(k)=i;
    %Lists y-indices, then x-indices
    roiIndList{k,1}=max([i-roiHalfWidth,xMin]):min([i+roiHalfWidth,xMax]);
    roiIndList{k,2}=max([j-roiHalfWidth,yMin]):min([j+roiHalfWidth,yMax]);
    roiTraces(:,k)=mean(mean(h5Movie(roiIndList{k,1},roiIndList{k,2},:),2),1);
end




% For troubleshooting:
%list positions for ROI rectangles
roiPositions=zeros(nFilters,4);
for k=1:nFilters
    xMin=min(roiIndList{k,2});
    yMin=min(roiIndList{k,1});
    xMax=max(roiIndList{k,2});
    yMax=max(roiIndList{k,1});
    roiPositions(k,:)=[xMin,yMin,xMax-xMin,yMax-yMin];    
end

%Visualize ROIs on top of ICs:
collapsedIca=sum(IcaFilters,3);
figure; imagesc(collapsedIca); %creates merged stack
for k=1:nFilters
    rectangle('Position',roiPositions(k,:),'EdgeColor',[0,0,0]);
end
figure; plot(roiTraces);


% saves output .mat files
save(roi_traces_file,'roiTraces');
save(roi_position_file,'roiPositions');

clear;
