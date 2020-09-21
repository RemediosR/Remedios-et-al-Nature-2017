%load the IcaFilters file of choice into the workspace then run this script
%for mapping filter index values.

labelColor=[1,0,0];
labelFontSize=10;

brightScale=2; %minmium is 1. Change this to enhance contrast.


nFilters=size(IcaFilters,1);

showFilters=squeeze(mean(IcaFilters,1));

maxShowFilters=max(max(showFilters));
showFilters=brightScale*showFilters/maxShowFilters;

filterFig=figure;
filterAxes=axes('Parent', filterFig);

imshow(showFilters,'Parent',filterAxes);
hold all;

tt=zeros(nFilters,1);
% return
for i=1:nFilters
    curFilter=squeeze(IcaFilters(i,:,:));
    [row, col]=find(curFilter==max(max(curFilter)));
    
    tt(i)=text(col,row,num2str(i),'Parent',filterAxes,...
        'Color',labelColor,'FontSize',labelFontSize,'FontWeight','normal');
    hold all;
end


