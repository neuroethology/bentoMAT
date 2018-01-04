function updatePlot(source,eventdata)
gui = guidata(source);
evaltime = tic;
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
            gui.traces.win      = str2num(eventdata.Source.String);
            gui.features.win    = str2num(eventdata.Source.String);
            gui.audio.win       = str2num(eventdata.Source.String);
            gui.fineAnnot.win   = str2num(eventdata.Source.String);
            guidata(source,gui);

            set(gui.traces.axes,'xlim',[-gui.traces.win  gui.traces.win]);
            set(gui.features.axes,'xlim',[-gui.features.win  gui.features.win]);
            set(gui.audio.axes,'xlim',[-gui.audio.win  gui.audio.win]);
            set(gui.fineAnnot.axes,'xlim',[-gui.fineAnnot.win  gui.fineAnnot.win]);
    end
end
time = gui.ctrl.slider.Value;


% update the movie panel
if(all(gui.enabled.movie))
    [mov, gui.data.io.movie.reader] = readBehMovieFrame(gui.data.io.movie,time);
    if(all(gui.enabled.tracker)) % add tracking data if included
        mov = applyTracking(gui,mov,time);
    end
    if(size(mov,3)==1)
        mov = repmat(mov,[1 1 3]);
    end
	set(gui.movie.img,'cdata',mov);
end

% update the audio spectrogram
if(all(gui.enabled.audio))
    inds   = (gui.data.audio.t >= (time-gui.audio.win)) & (gui.data.audio.t <= (time+gui.audio.win));
    inds   = inds | [false inds(1:end-1)] | [inds(2:end) false];
    tsub   = gui.data.audio.t;
    img    = scaleAudio(gui,gui.data.audio.psd(:,find(inds)));
    fshow  = (gui.data.audio.f/1000>=gui.audio.freqLo)&(gui.data.audio.f/1000<=gui.audio.freqHi);
    
    set(gui.audio.img, 'cdata', img(fshow,:)*64);
    set(gui.audio.img, 'xdata', tsub(inds)-time);
    set(gui.audio.img, 'ydata', [gui.audio.freqLo gui.audio.freqHi]);
    
    if((all(gui.enabled.annot)||all(gui.enabled.fineAnnot))&&~all(gui.enabled.traces))
        set(gui.audio.axes,'ylim',      [gui.audio.freqLo-.2*(gui.audio.freqHi-gui.audio.freqLo) gui.audio.freqHi]);
        set(gui.audio.zeroLine,'ydata', [gui.audio.freqLo-.2*(gui.audio.freqHi-gui.audio.freqLo) gui.audio.freqHi]);
    else
        set(gui.audio.axes,'ylim',      [gui.audio.freqLo gui.audio.freqHi]);
        set(gui.audio.zeroLine,'ydata', [gui.audio.freqLo gui.audio.freqHi]);
    end
end

%now change time to be relative to start of relevant movie segment
time = time - gui.ctrl.slider.Min;%gui.data.io.movie.tmin/gui.data.io.movie.FR;%slider.Min;

% update the plotted traces
if(all(gui.enabled.traces))
    inds = (gui.data.CaTime>=(time-gui.traces.win)) & (gui.data.CaTime<=(time+gui.traces.win));
    inds = inds | [false inds(1:end-1)] | [inds(2:end) false];
    bump = gui.traces.yScale;
    show = find(gui.traces.show);
    [~,order] = sort(gui.traces.order(show));
    order     = max(order)-order+1;
    [~,first] = min(order(show));
    [~,last]  = max(order(show));
    for i = 1:length(show)
        switch gui.traces.toPlot
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
    switch gui.traces.toPlot
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
if(gui.enabled.annot(1))
    % update behavior pic
    win  = (-gui.traces.win*gui.data.annoFR):(gui.traces.win*gui.data.annoFR);
    inds = round(time*gui.data.annoFR) + round(win);
    drop = (inds<=0)|(inds>length(gui.data.annoTime));
    inds(inds<=0) = 1;
    inds(inds>length(gui.data.annoTime)) = length(gui.data.annoTime);
    
    
    % make the fineAnnot pic if it's enabled
    tmax    = round(gui.data.annoTime(end)*gui.data.annoFR);
    if(all(gui.enabled.fineAnnot))
        img = makeAllChannelBhvImage(gui,gui.data.annot,gui.annot.cmapDef,inds,tmax,gui.annot.show);
        img(:,drop,:) = 1;
        img = displayImage(img,gui.traces.panel.Position(3)*gui.h0.Position(3)*.75,0);
        set(gui.fineAnnot.img,'cdata',img,'XData',win/gui.data.annoFR,'YData',[0 1] + [1 -1]/(size(img,1)*2));
    end
    
    
    % add background images to traces/audio
    if(all(gui.enabled.traces) || all(gui.enabled.audio))
        img     = makeBhvImage(gui.annot.bhv,gui.annot.cmapDef,inds,tmax,gui.annot.show)*2/3+1/3;
        img(:,drop,:) = 1;
        img     = displayImage(img,gui.traces.panel.Position(3)*gui.h0.Position(3)*.75,0);
        if(~gui.enabled.annot(2))
            img = [];
        end
        if(all(gui.enabled.traces))
            set(gui.traces.bg,'cdata',img,'XData',win/gui.data.annoFR,'YData',[0 bump*(length(show)+1)]);
        else
            if(gui.enabled.annot(2)) %this if/else shouldn't be necessary
                set(gui.audio.bg,'Visible','on');
            else
                set(gui.audio.bg,'Visible','off');
            end
            if(gui.enabled.fineAnnot)
                img = makeAllChannelBhvImage(gui,gui.data.annot,gui.annot.cmap,inds,tmax,gui.annot.show);
                img(:,drop,:) = 1;
                img = displayImage(img,gui.traces.panel.Position(3)*gui.h0.Position(3)*.75,0);
            end
            set(gui.audio.bg,'cdata',img,'XData',win/gui.data.annoFR,'YData',[-gui.data.audio.f(end,1)/1000/5 0]);
        end
    end
        
    % update behavior-annotating box if it's active
    if(isfield(gui.ctrl,'annot'))
        if((gui.ctrl.annot.toggleAnnot.Value||gui.ctrl.annot.toggleErase.Value)&&all(gui.enabled.traces))
            set(gui.annot.Box.traces,'ydata',[0 0 bump*(length(show)+1) bump*(length(show)+1)]);
            set(gui.annot.Box.traces,'xdata',[gui.annot.highlightStart/gui.data.annoFR-time 0 0 gui.annot.highlightStart/gui.data.annoFR-time]);
        end
    end
    
    % display the current behavior in each channel~!
    frnum = min(max(round(time*gui.data.annoFR),1),...
                round((gui.data.io.annot.tmax - gui.data.io.annot.tmin)*gui.data.annoFR+1));
    for chNum = 1:length(gui.annot.channels)
        chName = gui.annot.channels{chNum};
        str = '';
        count=0;
        if(gui.enabled.annot(2))
            if(strcmpi(gui.annot.activeCh,chName))
                for f = fieldnames(gui.annot.bhv)'
                    if(gui.annot.bhv.(f{:})(frnum)&&gui.annot.show.(f{:}))
                        str = [str strrep(f{:},'_',' ') ' '];
                        count=count+1;
                    end
                end
            else %have to get inactive-channel data from gui.data :0
                for f = fieldnames(gui.data.annot.(chName))'
                    if(~isempty(gui.data.annot.(chName).(f{:}))&~strcmpi(f{:},'other'))
                        if(any((gui.data.annot.(chName).(f{:})(:,1)<=frnum) & (gui.data.annot.(chName).(f{:})(:,2)>=frnum)))
                            str = [str strrep(f{:},'_',' ') ' '];
                            count=count+1;
                        end
                    end
                end
            end
        end
        if(all(gui.enabled.movie))
            set(gui.movie.annot(chNum),'string',str);
            if(count==1)
                cswatch = gui.annot.cmapDef.(strrep(str(1:end-1),' ','_'));
                set(gui.movie.annot(chNum),'backgroundcolor',cswatch,'color',ones(1,3)*(1-round(mean(cswatch))));
            else
                set(gui.movie.annot(chNum),'backgroundcolor',[.5 .5 .5],'color','w');
            end
            if(strcmpi(gui.annot.activeCh,chName))
                set(gui.movie.annot(chNum),'fontweight','bold','fontsize',14);
            else
                set(gui.movie.annot(chNum),'fontweight','normal','fontsize',10);
            end
        elseif(all(gui.enabled.traces))
    %         set(gui.traces.annot,'string',str); %display text on traces plot (need to create+place this object)
        end
    end
end


%check if Action was updated while we were busy (so we don't overwrite it)
g2 = guidata(source);
gui.Action=g2.Action;

guidata(source,gui);
pause(min(gui.ctrl.slider.SliderStep(1) - toc(evaltime),0));
drawnow;