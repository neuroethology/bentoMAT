function updatePlot(source,eventdata)
gui = guidata(source);
evaltime = tic;
%update gui features (depending on who called)
if(~isempty(eventdata))
    switch eventdata.Source.Tag
        case 'slider'
            if(gui.Keys.Shift && any(gui.Action~=0))
                chNum = strcmpi(gui.annot.activeCh,gui.annot.channels);
                match = strrep(strtrim(gui.movie.annot(chNum).String),' ','_');
                if(~isempty(match))
                    inds    = gui.data.annoTime > (gui.ctrl.slider.Value - gui.ctrl.slider.Min);
                    tNext   = gui.data.annoTime(find(gui.annot.bhv.(match)(inds),1,'first'));
                    if(~isempty(tNext))
                        gui.ctrl.slider.Value = gui.ctrl.slider.Value + tNext - gui.ctrl.slider.SliderStep(1);
                    end
                end
            end
            if(strcmpi(gui.ctrl.slider.text.Tag,'timeBox'))
                set(gui.ctrl.slider.text,'String',makeTime(gui.ctrl.slider.Value-gui.ctrl.slider.Min+gui.ctrl.slider.SliderStep(1)));
            else
                set(gui.ctrl.slider.text,'String',num2str(round((gui.ctrl.slider.Value-gui.ctrl.slider.Min)*gui.data.annoFR+1)));
            end            
        case 'timeBox'
            gui.ctrl.slider.Value = getTime(gui.ctrl.slider.text.String)+gui.ctrl.slider.Min;
            updateSlider(source,gui.ctrl.slider);
            
        case 'doubleClick'
            t = gui.ctrl.slider.Value + eventdata.delta;
            gui.ctrl.slider.Value = t;
            updateSlider(source,gui.ctrl.slider);
            t = t - gui.ctrl.slider.Min;
            set(gui.ctrl.slider.text,'String',makeTime(t));

        case 'frameBox'
            gui.ctrl.slider.Value = (str2num(gui.ctrl.slider.text.String)-1)/gui.data.annoFR + gui.ctrl.slider.Min;
            updateSlider(source,gui.ctrl.slider);

        case 'winBox'
            gui.traces.win      = str2num(eventdata.Source.String);
            gui.features.win    = str2num(eventdata.Source.String);
            gui.audio.win       = str2num(eventdata.Source.String);
            gui.fineAnnot.win   = str2num(eventdata.Source.String);
            gui.features.win    = str2num(eventdata.Source.String);
            guidata(source,gui);

            set(gui.traces.axes,   'xlim',gui.traces.win*[-1 1]);
            set(gui.audio.axes,    'xlim',gui.audio.win*[-1 1]);
            set(gui.fineAnnot.axes,'xlim',gui.fineAnnot.win*[-1 1]);
            gui.features.axes.XLim = gui.features.win*[-1 1];
            
            for i = 1:length(gui.features.feat)
                set(gui.features.feat(i).axes,'xlim',gui.features.win*[-1 1]);
                set(gui.features.feat(i).threshLine,'xdata',gui.features.win*[-1 1 1 -1 -1]);
                gui.features.feat(i).label.Position(1) = -gui.features.win*.975;
                gui.features.feat(i).label.Position(2) = ...
                    max(reshape(gui.data.tracking.features(:,:,gui.features.feat(i).featNum),1,[]))*.975;
            end
    end
end
time = gui.ctrl.slider.Value;

% update the movie panel
if(all(gui.enabled.movie)||all(gui.enabled.tracker))
    if(all(gui.enabled.movie))
        [mov, gui.data.io.movie.reader] = readBehMovieFrame(gui.data.io.movie,time);
    elseif(gui.enabled.movie(1))
        mov = ones(gui.data.io.movie.reader.width,gui.data.io.movie.reader.height,'uint8')*255;
    else
        mov = ones(1024,540,'uint8')*255;
    end
	
    if(all(gui.enabled.tracker)) % add tracking data if included
        mov = applyTracking(gui,mov,time);
    end
    % apply crop+zoom if turned on
    if(isfield(gui.data,'tracking')&&isfield(gui.data.tracking,'crop')&&~isempty(gui.data.tracking.crop))
        mov = imcrop(mov,gui.data.tracking.crop);
    end
    if(size(mov,3)==1), mov = repmat(mov,[1 1 3]); end
	set(gui.movie.img,'cdata',mov);
end

% update the plotted features
if(all(gui.enabled.features) && isfield(gui.features,'feat'))
    inds  = (gui.data.annoTime >= (time-gui.features.win)) & (gui.data.annoTime <= (time+gui.features.win));
    inds  = inds | [false inds(1:end-1)] | [inds(2:end) false];
    
    for i = 1:length(gui.features.feat)
        channel = regexp(gui.features.feat(i).tag(3:5),'[\d]','match');
        channel = str2num(channel{:});
        set(gui.features.feat(i).trace,'xdata',gui.data.annoTime(inds) - time,...
            'ydata',gui.data.tracking.features(channel,inds,gui.features.feat(i).featNum));
    end
end

% update the audio spectrogram
if(all(gui.enabled.audio))
    inds   = (gui.data.audio.t >= (time-gui.audio.win)) & (gui.data.audio.t <= (time+gui.audio.win));
    inds   = inds | [false inds(1:end-1)] | [inds(2:end) false];
    tsub   = gui.data.audio.t;
    img    = scaleAudio(gui,gui.data.audio.psd(:,inds));
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
time = time - gui.ctrl.slider.Min; %gui.data.io.movie.tmin/gui.data.io.movie.FR;%slider.Min;
% update the plotted traces
if(all(gui.enabled.traces))
    inds        = (gui.data.CaTime>=(time-gui.traces.win)) & (gui.data.CaTime<=(time+gui.traces.win));
    inds        = inds | [false inds(1:end-1)] | [inds(2:end) false];
    show        = find(gui.traces.show);
    [~,order]   = sort(gui.traces.order(show));
    order       = max(order)-order+1;
    bump        = gui.traces.yScale;
    
    [tr,lims] = getFormattedTraces(gui,inds,order);
    
    if(strcmpi(gui.ctrl.track.plotType.display.String{gui.ctrl.track.plotType.display.Value},'image'))
        set(gui.traces.tracesIm,'visible','on','xdata',gui.data.CaTime(inds) - time,'ydata',[2 10-.5/length(show)*8],'cdata',tr*64);
        set(gui.traces.axes,'ylim',[1 10+.5/length(show)]);
        set(gui.traces.zeroLine,'ydata',[1 10]);
    else
        set(gui.traces.tracesIm,'visible','off');
        for i = 1:length(show)
            if(i<=length(gui.traces.traces))
                set(gui.traces.traces(i),'xdata',gui.data.CaTime(inds) - time,...
                                         'ydata',(tr(i,:) - lims(1) + i*bump)/(length(show)*bump + lims(2))*10);
            else
                gui.traces.traces(i) = plot(gui.traces.axes, gui.data.CaTime(inds) - time,...
                                                 (tr(i,:) - lims(1) + i*bump)/(length(show)*bump + lims(2))*10, 'color',[.1 .1 .1],'hittest','off');
            end
        end
        if(isempty(i)) i = 0; end
        delete(gui.traces.traces(i+1:end));
        gui.traces.traces(i+1:end) = [];
        set(gui.traces.axes,'ylim',[1 10]);
        set(gui.traces.zeroLine,'ydata',[1 10]);
        uistack(gui.traces.traces,'top');
    end
end

% update scatterplot
if(all(gui.enabled.scatter))
    inds        = (gui.data.CaTime>=(time-gui.traces.win)) & (gui.data.CaTime<=time);
    inds        = inds | [false inds(1:end-1)] | [inds(2:end) false];
    [~,ind] = find(gui.data.CaTime(inds)>=time,1,'first');
    p1  = gui.data.proj.d1*gui.data.rast(:,inds);
    p2  = gui.data.proj.d2*gui.data.rast(:,inds);
%     set(gui.scatter.data,'xdata',p1,'ydata',p2);
    set(gui.scatter.currentFrame,'xdata',p1(ind),'ydata',p2(ind));
end


% update annotations
if(gui.enabled.annot(1))
    % update behavior pic
    inds = find((gui.data.annoTime>=(time-gui.traces.win)) & (gui.data.annoTime<=(time+gui.traces.win)));
    win  = (-gui.traces.win*gui.data.annoFR):(gui.traces.win*gui.data.annoFR);
    win((win/gui.data.annoFR + time) > gui.data.annoTime(end))  = [];
    win((win/gui.data.annoFR + time) < gui.data.annoTime(1))    = [];
    
    % make the fineAnnot pic if it's enabled
    tmax    = round(gui.data.annoTime(end)*gui.data.annoFR);
    if(all(gui.enabled.fineAnnot))
        img = makeAllChannelBhvImage(gui,gui.data.annot,gui.annot.cmapDef,inds,tmax,gui.annot.show);
        img = displayImage(img,gui.traces.panel.Position(3)*gui.h0.Position(3)*1.5,0);
        set(gui.fineAnnot.img,'cdata',img,'XData',win/gui.data.annoFR,'YData',[0 1] + [1 -1]/(size(img,1)*2));
    end
    
    
    % add background images to traces/audio or set color for scatter marker
    if(all(gui.enabled.scatter) || all(gui.enabled.traces) || all(gui.enabled.audio) || all(gui.enabled.features))
        
        img      = makeBhvImage(gui.annot.bhv,gui.annot.cmapDef,inds,tmax,gui.annot.show)*2/3+1/3;
        imgSmall = displayImage(img,gui.traces.panel.Position(3)*gui.h0.Position(3)*.75,0);
        if(~gui.enabled.annot(2))
            img = [];
        end
        if(all(gui.enabled.scatter))
            [~,i] = min(abs(win));
            set(gui.scatter.currentFrame,'markerfacecolor',squeeze(img(1,i,:)));
            if(~isempty(p1))
                tailImg = squeeze((img(1,1:i,:)-1/3)*3/2);
                if(gui.scatter.hideOther.Value)
                    tailImg(sum(tailImg,2)==3,:) = nan;
                else
                    tailImg(sum(tailImg,2)==3,:) = 0;
                end
                tailImg = repmat(permute(imresize(tailImg,[length(p1) 3]),[3 1 2]),[2 1 1]);

                set(gui.scatter.tail,'XData',[p1;p1],'YData',[p2;p2],'ZData',zeros(2,length(p1)),'CData',tailImg);
            else
                set(gui.scatter.tail,'XData',[0;0],'YData',[0;0],'ZData',[0;0],'CData',zeros(2,1,3));
            end
        end
        if(all(gui.enabled.traces))
            set(gui.traces.bg,'cdata',imgSmall,'XData',win/gui.data.annoFR,'YData',[0 10]);
        end
        if(all(gui.enabled.features))
            for i=1:length(gui.features.feat)
                set(gui.features.feat(i).bg,'cdata',imgSmall*2/3+1/3,...
                    'XData',win/gui.data.annoFR,...
                    'YData',gui.features.feat(i).axes.YLim+[-1 1]);
            end
        end
        if(all(gui.enabled.audio))
            if(gui.enabled.annot(2)) %this if/else shouldn't be necessary
                set(gui.audio.bg,'Visible','on');
            else
                set(gui.audio.bg,'Visible','off');
            end
            if(gui.enabled.fineAnnot)
                img = makeAllChannelBhvImage(gui,gui.data.annot,gui.annot.cmap,inds,tmax,gui.annot.show);
                img = displayImage(img,gui.traces.panel.Position(3)*gui.h0.Position(3)*.75,0);
            end
            set(gui.audio.bg,'cdata',img,'XData',win/gui.data.annoFR,'YData',[-gui.data.audio.f(end,1)/1000/5 0]);
        end
    end
        
    % update behavior-annotating box if it's active
    if(isfield(gui.ctrl,'annot') && (gui.annot.highlighting(1)~=0))
        for f = fieldnames(gui.annot.Box)'
            if(all(gui.enabled.(f{:})))
                set(gui.annot.Box.(f{:}),'xdata',(gui.annot.highlightStart/gui.data.annoFR-time)*[1 0 0 1]);
            end
        end
    end
    
    % display the current behavior in each channel~!
    if(~isempty(win))
        [~,i] = min(abs(win));
        frnum = inds(i);
        gui.annot.activeBeh = '';
        for chNum = 1:length(gui.annot.channels)
            chName = gui.annot.channels{chNum};
            str = '';
            count=0;
            if(gui.enabled.annot(2))
                if(strcmpi(gui.annot.activeCh,chName))
                    for f = fieldnames(gui.annot.bhv)'
                        if(gui.annot.bhv.(f{:})(frnum)&&gui.annot.show.(f{:}))
                            str = [str strrep(f{:},'_',' ') ' '];
                            gui.annot.activeBeh = f{:};
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
end

%check if Action was updated while we were busy (so we don't overwrite it)
g2 = guidata(source);
gui.Action = g2.Action;

guidata(source,gui);
pause(min(gui.ctrl.slider.SliderStep(1) - toc(evaltime),0));
drawnow;
end

function [traces,lims] = getFormattedTraces(gui,inds,order)

    if(strcmpi(gui.traces.toPlot,'PCA'))
        traces = gui.data.PCA(:,gui.traces.show)'*gui.data.rast;
    else
        traces = gui.data.(gui.traces.toPlot)(gui.traces.show,:);
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
            traces = traces-min(traces(:));
            traces = traces/max(traces(:));
            
        case 'zscored (by session)'
            if(strcmpi(gui.traces.toPlot,'PCA'))
                all = gui.data.PCA'*[gui.allData(gui.data.info.mouse).(gui.data.info.session).rast];
            else
                all = [gui.allData(gui.data.info.mouse).(gui.data.info.session).(gui.traces.toPlot)];
                all = all(gui.traces.show,:);
            end
            mu  = mean(all,2);
            sig = std(all,[],2);
            traces = (bsxfun(@times,bsxfun(@minus,traces,mu),1./sig)+8)/16;
            
        case 'zscored (by trial)'
            traces = zscore(traces(:,2:end-1)')';
            traces = (traces+5)/10;
    end
    
    traces  = traces(order,:);
    lims    = [min(traces(:)) max(traces(:))];
    traces  = traces(:,inds);
    
end