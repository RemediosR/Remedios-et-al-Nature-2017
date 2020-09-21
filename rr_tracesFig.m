% rr_tracesFig

% requires x=time(frames), y=traces(from imagej)
for k=1:size(y,2)
    Y(:,k)=y(:,k)-min(y(:,k));
    Z(:,k)=Y(:,k)+k;
end   
subplot(2,1,1)
plot(X,Y)
xlim([0 max(X)]);
xlabel('time (s)');
ylabel('dF/F (%)');
subplot(2,1,2)
plot(X,Z)
xlim([0 max(X)]);
xlabel('time (s)');
ylabel('neuron #');



% shortlisting only ICs of interest,
% for this you will first need the excel list of the numbers of ICs
% (ICs-Units.xlxs)

ICs=[]

for k=1:length(ICs);
m02.spksD1(k,:)=IcaTraces(ICs(k),:);
end

%next we want to construct a spk vs time plot:
spk=m02.spksD1';
m=1:length(ICs); %creating offset
m=m*0.1;
for k=1:length(ICs);
spk2(:,k)=spk(:,k)+m(:,k);
end
m02.waveD1=spk2;
figure
plot(m02.waveD1);