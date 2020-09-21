
lastIndex=20;


for i=20683:nFrames
    curFrame=data(:,:,i);
    for j=1:nFilters
        curMask=squeeze(IcaMasks(j,:,:))';
        framePixels(i,j)=sum(sum(curMask));
        frameSums(i,j)=sum(curFrame(curMask));
    end
    if floor(i/1000) > lastIndex
        lastIndex=floor(i/1000);
        disp([num2str(lastIndex), ' frames done.']);
    end
end


frameMeans=frameSums./framePixels;
