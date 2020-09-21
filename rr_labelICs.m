
%To label ICs on a figure:
a=IcaFilters; [bx,by]=deal(zeros(size(a,1),1)); 
figure; 
imagesc(permute(max(a),[2,3,1])); 
for k=1:size(a,1); 
    b=permute(a(k,:,:),[2,3,1]); 
    [by(k),bx(k)]=ind2sub(size(b),find(b==max(max(b)))); 
    text(bx(k),by(k),num2str(k),'Color',[1,0,0]); 
end;



%To get numbers that are not in corners:
goodNums=find((bx<360 & bx > 10) | (by < 360 & by > 10));


%To get them in string form:
goodNumStr=[cellfun(@num2str,num2cell(goodNums),'UniformOutput',false),repmat({', '},size(goodNums))]'; 
goodNumStr=[goodNumStr{:}];