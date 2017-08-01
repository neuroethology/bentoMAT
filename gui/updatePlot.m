function updatePlot(source,eventdata)
gui = guidata(source);

%update gui features (depending on who called)
if(~isempty(eventdata))
    switch eventdata.Source.Tag
        case 'slider'
            if(strcmpi(gui.ctrl.slider.text.Tag,'timeBox'))
                set(gui.ctrl.slider.text,'String',makeTime(gui.ctrl.slider.Value-gui.ctrl.slider.Min+gui.ctrl.slider.SliderStep(1)));
            else
                set(gui.ctrl.slider.text,'String',num2str(round((gui.ctrl.slider.Value-gui.ctrl.slider.Min)*gui.data.annoFR+1)));
            end
        case 'timeBox'
            gui.ctrl.slider.Value = getTime(gui.ctrl.slider.text.String)+gui.ctrl.slider.Min;
            updateSlider(source,gui.ctrl.slider);

        case 'frameBox'
            gui.ctrl.slider.Value = (str2num(gui.ctrl.slider.text.String)-1)/gui.data.annoFR + gui.ctrl.slider.Min;
            updateSlider(source,gui.ctrl.slider);

        case 'winBox'
        gui.traces.win  = str2num(eventdata.Source.String);
            gui.features.win = str2num(eventdata.Source.String);
            guidata(source,gui);

            set(gui.traces.axes,'xlim',[-gui.traces.win  gui.traces.win]);
            set(gui.features.axes,'xlim',[-gui.features.win  gui.features.win]);
    end
end
time = gui.ctrl.slider.Value;


% update the movie panel
if(gui.enabled.movie)
    [mov, gui.data.io.movie.reader] = readBehMovieFrame(gui.data.io.movie,time);
    if(gui.enabled.tracker) % add tracking data if included
        mov = applyTracking(gui,mov,time);
    end
    if(strcmpi(gui.data.io.movie.readertype,'seq'))
        set(gui.movie.img,'cdata',mov);
    else
        set(gui.movie.img,'cdata',mov);
    end
end
%now change time to be relative to start of movie
time = time - gui.ctrl.slider.Min;


% update the plotted traces
if(gui.enabled.traces)
    inds = (gui.data.CaTime>=(time-gui.traces.win)) & (gui.data.CaTime)<=(time+gui.traces.win);
    inds = inds | [false inds(1:end-1)] | [inds(2:end) false];
    bump = gui.traces.yScale;
    show = find(gui.data.show);
    [~,order] = sort(gui.data.order(show));
    order     = max(order)-order+1;
    [~,first] = min(order(show));
    [~,last]  = max(order(show));
    for i = 1:length(show)
        switch gui.toPlot
            case 'rast'
                tr = gui.data.rast(show(end-i+1),inds) - ...
                     nanmean(gui.data.rast(show(end-i+1),:));
            case 'PCs'
                tr = gui.data.PCA(:,show(end-i+1))'*gui.data.rast(:,inds) - ...
                     nanmean(gui.data.PCA(:,show(end-i+1))'*gui.data.rast);
        end
        if(i<=length(gui.traces.traces))
            set(gui.traces.traces(i),'xdata',gui.data.CaTime(inds) - time,...
                                     'ydata',tr + order(i)*bump);
        else
            gui.traces.traces(i) = plot(gui.traces.axes,...
                                        gui.data.CaTime(inds) - time,tr + order(i)*bump,...
                                        'color',[.1 .1 .1]);
        end
    end
    delete(gui.traces.traces(i+1:end));
    gui.traces.traces(i+1:end)=[];
    switch gui.toPlot
        case 'rast'
            traceOffset = [min(gui.data.rast(last,:) - nanmean(gui.data.rast(last,:))) ...
                           max(gui.data.rast(first,:)   - nanmean(gui.data.rast(first,:)))];
        case 'PCs'
            traceOffset = [min(gui.data.PCA(:,last)'*gui.data.rast - gui.data.PCA(:,last)'*nanmean(gui.data.rast,2)) ...
                           max(gui.data.PCA(:,first)'*gui.data.rast   - gui.data.PCA(:,first)'*nanmean(gui.data.rast,2))];
    end
    traceOffset(isnan(traceOffset)) = 0;
    if(isempty(traceOffset))
        traceOffset = [0 0];
    end
    set(gui.traces.axes,'ylim',[bump bump*length(show)] + traceOffset);
    set(gui.traces.zeroLine,'ydata',[bump bump*length(show)] + traceOffset);
    uistack(gui.traces.traces,'top');
end


% update annotations
if(gui.enabled.annot)
    % update behavior pic
    win  = (-gui.traces.win*gui.data.annoFR):(gui.traces.win*gui.data.annoFR);
    inds = round(time*gui.data.annoFR) + round(win);
    drop = (inds<=0)|(inds>length(gui.data.annoTime));
    inds(inds<=0) = 1;
    inds(inds>length(gui.data.annoTime)) = length(gui.data.annoTime);
    
    tmax    = round(gui.data.annoTime(end)*gui.data.annoFR);
    if(gui.enabled.traces)
        img     = makeBhvImage(gui.annot.bhv,gui.annot.cmap,inds,tmax,gui.annot.show)*2/3+1/3;
        img(:,drop,:) = 1;
        img     = displayImage(img,gui.traces.panel.Position(3)*gui.h0.Position(3)*.75,0);
        set(gui.traces.bg,'cdata',img,'xdata',win/gui.data.annoFR,'ydata',[0 bump*(length(show)+1)]);
    end
        
    % update behavior-annotating box if it's active
    if((gui.ctrl.annot.toggleAnnot.Value||gui.ctrl.annot.toggleErase.Value)&&gui.enabled.traces)
        set(gui.annot.Box.traces,'ydata',[0 0 bump*(length(show)+1) bump*(length(show)+1)]);
        set(gui.annot.Box.traces,'xdata',[gui.annot.highlightStart/gui.data.annoFR-time 0 0 gui.annot.highlightStart/gui.data.annoFR-time]);
    end
    
    % display the current behavior
    str = '';count=0;
    for f = fieldnames(gui.annot.bhv)'
        if(gui.annot.bhv.(f{:})(min(max(round(time*gui.data.annoFR),1),length(gui.annot.bhv.(f{:})))))
            str = [str strrep(f{:},'_',' ') ' '];
            count=count+1;
        end
    end
    if(gui.enabled.movie)
        set(gui.movie.annot,'string',str);
        if(count==1)
            cswatch = gui.annot.cmap.(strrep(str(1:end-1),' ','_'));
            set(gui.movie.annot,'backgroundcolor',cswatch,'color',ones(1,3)*(1-round(mean(cswatch))));
        else
            set(gui.movie.annot,'backgroundcolor','k','color','w');
        end
    elseif(gui.enabled.traces)
%         set(gui.traces.annot,'string',str); %display text on traces plot (need to create+place this object)
    end
end


%check if Action was updated while we were busy (so we don't overwrite it)
g2 = guidata(source);
gui.Action=g2.Action;

guidata(source,gui);
pause(.025);
drawnow;