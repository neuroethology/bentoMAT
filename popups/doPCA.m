function doPCA(~,~,parent,h,trials,nPCs,gui,m,sess,trList)

rast    = [gui.allData(m).(sess)(trList(trials.Value)).rast];
[e,~]   = eig(rast*rast');
nPCs    = min(str2num(nPCs.String),length(e));

gui.data.PCA    = fliplr(e(:,end-nPCs+1:end));
gui.data.show   = true(nPCs,1);
close(h);

guidata(parent,gui);
updatePlot(parent,[]);