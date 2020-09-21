%Uses the Filters from the PCA-ICA to create masks to extract traces from
%the dF/F videos.
clear all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
threshold=5; %controlls size of ROI. Larger value makes smaller ROI.
filterFileName='ICFilters_consolidated.mat';
movieFileName='dFF_concat.h5';
outFileName='Filter_Traces.mat';
pathName='H:\er11\day2\concat\ROItraces';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ~exist('pathName', 'var') || isempty(pathName)
    pathName=uigetdir();
    if isNumeric(pathName) || isempty(pathName) || ~isdir(pathName)
        return
    end
end

if ~strcmpi(pathName(end),filesep)
    pathName=[pathName, filesep];
end

load([pathName, filesep, filterFileName]);
data=hdf5read([pathName,movieFileName],'Object');
outFileName=[pathName,outFileName];


IcaFilters=permute(IcaFilters,[2,3,1]);

[IcaMasks,IcaBorders]=deal(false(size(IcaFilters)));

IcaMasks=IcaFilters >= threshold;

for i=1:size(IcaFilters, 3)
    
    curMask=IcaMasks(:,:,i);
    
    curLabel=bwlabel(curMask);
    maxLabel=max(max(curLabel));
    largestSpotLabel=1;
    [curNumEqual, maxNumEqual]=deal(sum(sum(curLabel==1)));
    if maxLabel>1
        for j=2:maxLabel
            curNumEqual=sum(sum(curLabel==j));
            if curNumEqual >= maxNumEqual
                maxNumEqual=curNumEqual;
                largestSpotLabel=j;
            end
        end
    end
    curMask=curLabel==largestSpotLabel;
    IcaMasks(:,:,i)=curMask;
    
    IcaBoundsList=bwboundaries(curMask);
    IcaBoundsList=IcaBoundsList{1};
    
    for j=1:length(IcaBoundsList)
        IcaBorders(IcaBoundsList(j,1),IcaBoundsList(j,2),i)=true;
    end
end


% figure;
% imshow(IcaBorders(:,:,1));
% hold all;
% figure;
% imshow(IcaMasks(:,:,1));
% hold all;
% figure;
% imagesc(IcaFilters(:,:,1));




IcaFilters=permute(IcaFilters,[3,1,2]);
IcaMasks=permute(IcaMasks,[3,1,2]);
IcaBorders=permute(IcaBorders,[3,1,2]);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Make time series of masks
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic;
lastIndex=0;

IcaMasks=permute(IcaMasks, [3,2,1]);

nFrames=size(data,3);
nFilters=size(IcaMasks,3);

[frameSums, framePixels, frameMeans]=deal(zeros(nFrames,nFilters));

pixelCounts=zeros(1,nFilters);




% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Slow Method (Method left running before I left. If there are problems
% with the faster method, this can be uncommented and that commented to
% replace it.)
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% for j=1:nFilters
%     pixelCounts(j)=sum(sum(IcaMasks(:,:,j)));
% end
% 
% for i=1:nFrames
%     curFrame=data(:,:,i);
%     for j=1:nFilters
%         frameSums(i,j)=sum(curFrame(IcaMasks(:,:,j)));
%     end
%     frameMeans(i,:)=frameSums(i,:)./pixelCounts;
%     
%     if floor(i/1000) > lastIndex
%         lastIndex=floor(i/1000);
%         curTime=toc;
%         disp([num2str(lastIndex*1000), ' frames done after ', num2str(curTime), ' seconds.']);
%         
%     end
% end
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % /Slow Method
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Possibly faster method (Untested; uses something like 12.5% more memory)
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for j=1:nFilters
    pixelCounts(j)=sum(sum(IcaMasks(:,:,j)));
    frameBlock=repmat(IcaMasks(:,:,j),[1,1,nFrames]);
    sumBlock=data(frameBlock);
    sumBlock=reshape(sumBlock, [pixelCounts(j), nFrames]);
    frameSums(:,j)=sum(sumBlock,1)';
    frameMeans(:,j)=frameSums(:,j)/pixelCounts(j);
    disp([num2str(j), ' of ' num2str(nFilters), ' done after ', num2str(toc), ' seconds.']);
end
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % /Possibly faster method
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%





%Restore filters to normal arrangement
IcaMasks=permute(IcaMasks, [3,2,1]);


filterTraces=frameMeans;
save(outFileName, 'filterTraces');