function traces = applyScale(gui)

    if(strcmpi(gui.traces.toPlot,'PCA'))
        traces = gui.data.PCA'*gui.data.rast;
    else
        traces = gui.data.(gui.traces.toPlot);
    end
    
    switch gui.ctrl.track.plotType.scaling.String{gui.ctrl.track.plotType.scaling.Value}
        case 'raw (scaled by session)'
            if(strcmpi(gui.traces.toPlot,'PCA'))
                allTr = gui.data.PCA'*[gui.allData(gui.data.info.mouse).(gui.data.info.session).rast];
            else
                allTr = [gui.allData(gui.data.info.mouse).(gui.data.info.session).(gui.traces.toPlot)];
                allTr = allTr(gui.traces.show,:);
            end
            traces = traces - min(allTr(:));
            traces = traces/max(allTr(:));
            
        case 'raw (scaled by trial)'
            trmin = min(traces(:));
            trmax = max(traces(:));
            traces = traces-trmin;
            traces = traces/trmax;
            
        case 'zscored (by session)'
            if(strcmpi(gui.traces.toPlot,'PCA'))
                allTr = gui.data.PCA'*[gui.allData(gui.data.info.mouse).(gui.data.info.session).rast];
            else
                allTr = [gui.allData(gui.data.info.mouse).(gui.data.info.session).(gui.traces.toPlot)];
                allTr = allTr(gui.traces.show,:);
            end
            mu  = nanmean(allTr,2);
            sig = nanstd(allTr,[],2);
            traces = bsxfun(@times,bsxfun(@minus,traces,mu),1./sig)/5;
            
        case 'zscored (by trial)'
            traces = nanzscore(traces(:,2:end-1)')'/5;
    end
    
    gui.data.([gui.traces.toPlot '_formatted']) = traces;
end