root = 'C:\users\ann\desktop\research\ryan\esr1 traces\data\er08\';

% build_expt_simple assumes that the directory "root" contains:
% -- a file "ROI_traces_day1.mat" (and/or _day2 and/or _day3)
% -- an xls file whose name ends with "stimuli.xlsx", with sheets named
% "day1","day2","day3" giving the stimulus IDs and frame counts for each
% trial.
expt = build_expt_simple(root);

%%

day = 'day1';
stim1 = 'male';
stim2 = 'female';

is1 = find(strcmpi(lower({expt.(day).stim}),stim1));
is2 = find(strcmpi(lower({expt.(day).stim}),stim2));

pCorr = [];
hit = zeros(max(is1),max(is2));
for i = is1
    for j = is2
        if(i~=j)
            sig1 = mean(expt.(day)(i).rast,2);
            sig2 = mean(expt.(day)(j).rast,2);
            pCorr(i,j) = corr(sig1,sig2);
            hit(i,j) = 1;
        end
    end
end
figure(1);clf;
bar(mean(pCorr(hit~=0)));
hold on;
errorbar(mean(pCorr(hit~=0)),std(pCorr(hit~=0))/sqrt(sum(hit(:))/2),'k');
title({'Pearson''s correlation between ',[ stim1 ' and ' stim2],'mean +/- SEM'});
text(1.1,mean(pCorr(hit~=0))*1.1,num2str(mean(pCorr(hit~=0))));