function traces = applyScale(gui)

    if(strcmpi(gui.traces.toPlot,'PCA'))
        traces = gui.data.PCA'*gui.data.rast;
    else
        traces = gui.data.(gui.traces.toPlot);
    end
    
    switch gui.ctrl.track.plotType.scaling.String{gui.ctrl.track.plotType.scaling.Value}
        case 'raw (scaled by session)'
            if(strcmpi(gui.traces.toPlot,'PCA'))
                all = gui.data.PCA'*[gui.allData(gui.data.info.mouse).(gui.data.info.session).rast];
            else
                all = [gui.allData(gui.data.info.mouse).(gui.data.info.session).(gui.traces.toPlot)];
                all = all(gui.traces.show,:);
            end
            traces = traces - min(all(:));
            traces = traces/max(all(:));
            
        case 'raw (scaled by trial)'
            trmin = min(traces(:));
            trmax = max(traces(:));
            traces = traces-trmin;
            traces = traces/trmax;
            
        case 'zscored (by session)'
            if(strcmpi(gui.traces.toPlot,'PCA'))
                all = gui.data.PCA'*[gui.allData(gui.data.info.mouse).(gui.data.info.session).rast];
            else
                all = [gui.allData(gui.data.info.mouse).(gui.data.info.session).(gui.traces.toPlot)];
                all = all(gui.traces.show,:);
            end
            mu  = mean(all,2);
            sig = std(all,[],2);
            traces = bsxfun(@times,bsxfun(@minus,traces,mu),1./sig)/10;
            
        case 'zscored (by trial)'
            traces = zscore(traces(:,2:end-1)')'/10;
    end
    
    gui.data.([gui.traces.toPlot '_formatted']) = traces;
end