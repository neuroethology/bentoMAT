function doPCA(source,~,parent,h,trials,nPCs,gui,m,sess,trList,type)

source.String = 'Computing...';
drawnow;

rast    = [gui.allData(m).(sess)(trList(setdiff(1:length(trList),trials.Value))).rast];
nPCs    = min(str2num(nPCs.String),size(rast,1));
switch type
    case 'PCA'
        [e,~]           = eig(rast*rast');
        gui.data.PCA    = fliplr(e(:,end-nPCs+1:end));
    case 'NMF'
        [weights,~]     = nnmf(rast,nPCs);
        gui.data.PCA    = weights;
end
        
gui.traces.show = true(nPCs,1);
close(h);

guidata(parent,gui);
updatePlot(parent,[]);