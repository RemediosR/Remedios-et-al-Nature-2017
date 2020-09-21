
% this is just bare-bones PCA:
filename = 'C:\users\ann\desktop\research\ryan\esr1 traces\data\er08\ROI_traces_day3.mat';
temp=load(filename);
f=fieldnames(temp);

rast = temp.(f{:});
if(size(rast,1)>size(rast,2))
    rast=rast';
end

[e,v] = eig(rast*rast');

figure(1);clf;
p1 = e(:,end)'*rast;
p2 = e(:,end-1)'*rast;
plot(p1,p2);

%%
% if you want to label PCA trajectories by stimulus, you'll need to do more
% processing of the trace data:
root = 'C:\users\ann\desktop\research\ryan\esr1 traces\data\er08\';

% build_expt_simple assumes that the directory "root" contains:
% -- a file "ROI_traces_day1.mat" (and/or _day2 and/or _day3)
% -- an xls file whose name ends with "stimuli.xlsx", with sheets named
% "day1","day2","day3" giving the stimulus IDs and frame counts for each
% trial.
expt = build_expt_simple(root);

%% after the data's loaded, run this:
day = 'day2'; %which day to look at
[stims,~,stimtype] = unique(lower({expt.(day).stim}));
cmap = 'rgbkycm';

rast = [expt.(day).rast];
[e,v] = eig(rast*rast');

figure(2);clf;hold on;
for i = 1:length(stimtype)
    p1 = e(:,end)'*expt.(day)(i).rast;
    p2 = e(:,end-1)'*expt.(day)(i).rast;
    h(stimtype(i)) = plot(p1,p2,cmap(stimtype(i)));
end
legend(h,stims,'location','best');