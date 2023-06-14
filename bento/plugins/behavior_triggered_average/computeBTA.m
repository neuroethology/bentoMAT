function [BTA,time] = computeBTA(source,~,gui)
%
% (C) Ann Kennedy, 2019
% California Institute of Technology
% Licensing: https://github.com/annkennedy/bento/blob/master/LICENSE.txt


h = guidata(source);
if(h.trAvg.Enable)
    trList = h.trAvg.String(h.trAvg.Value)';
    for i = 1:length(trList)
        [m(i),s(i),tr(i)] = parseTrialString(trList{i});
    end
else
    m  = gui.data.info.mouse;
    s  = gui.data.info.session;
    tr = gui.data.info.trial;
end

[BTAstack,BTBstack] = deal([]);
for ii = 1:length(m)
    data = gui.allData(m(ii)).(['session' num2str(s(ii))])(tr(ii));
    % first get the signal we're analyzing, and sample at the desired rate ----
    plotTraces = 1;
    str = h.unit.String{h.unit.Value};
    useFR = 1/str2double(h.bin.String);
    switch lower(str(1))
        case 'p' % population average: across trials yes (not implemented yet), across channels no
            usecolor = 'k';
            sig     = nanmean(data.rast);
            sig     = nan_fill(sig);
            if useFR >= gui.data.CaFR*.999
                useFR = min(useFR,gui.data.CaFR);
                h.bin.String = num2str(1/useFR);
                p=1;q=1;
            else
                [p,q]   = rat(useFR/gui.data.CaFR);
            end
            sig     = my_resample(sig,p,q);

        case 'u' % unit: across trials no, across channels no
            usecolor = 'k';
            sig     = data.rast(h.unit.Value - 1,:);
            sig     = nan_fill(sig);
            if useFR >= gui.data.CaFR*.999
                useFR = min(useFR,gui.data.CaFR);
                h.bin.String = num2str(1/useFR);
                p=1;q=1;
            else
                [p,q]   = rat(useFR/gui.data.CaFR);
            end
            sig     = my_resample(sig,p,q);

        case 'b' % behavior: across trials yes, across channels yes
            plotTraces = 0;
            usecolor = gui.annot.cmap.(strrep(str,'behavior: ',''));
            sigStack = [];
            useFR = min(useFR,gui.data.annoFR);
            h.bin.String = num2str(1/useFR);
            for ch = h.chAvg.String(h.chAvg.Value)'
                sig2 = double(data.annot.(ch{:}).(strrep(str,'behavior: ','')));
                sig2 = round(sig2*useFR/gui.data.annoFR);
                sig2 = double(convertToRast(sig2,round(length(data.annoTime)*useFR/data.annoFR)));
                sigStack = [sigStack;sig2];
            end
            sig = sigStack;

        case 'f' % feature: across trials yes, across channels no
            usecolor = 'k';
            [~,~,featnum]   = regexp(str,'feature *([0-9])*:');
            featnum         = str2double(str(featnum{1}(1):featnum{1}(2)));
            [~,~,chnum]     = regexp(str,'Ch([0-9])*');
            chnum           = str2double(str(chnum{1}(1):chnum{1}(2)));

            if(isfield(data.tracking.args{1},'features'))
                [gui,data] = loadCurrentFeatures(gui,data);
                sig     = squeeze(data.tracking.features{chnum}(:,featnum));
                trackFR = 1/(gui.data.trackTime(2) - gui.data.trackTime(1));
            if useFR >= gui.data.CaFR*.999
                useFR = min(useFR,trackFR);
                h.bin.String = num2str(1/useFR);
                p=1;q=1;
            else
                [p,q]   = rat(useFR/trackFR);
            end
                sig     = my_resample(sig,p,q);
            else
                sig = zeros(1,length(gui.data.trackTime));
            end
    end
    if(size(sig,2)==1)
        sig=sig';
    end

    win  = round(-str2double(h.pre.String)*useFR):round(str2double(h.post.String)*useFR);
    winB = round(-str2double(h.pre.String)*gui.data.annoFR):round(str2double(h.post.String)*gui.data.annoFR);

    showAnnot = struct();
    for i = 1:length(h.bhvrs)
        showAnnot.(strrep(h.bhvrs(i).Tag,'checkbox_','')) = h.bhvrs(i).Value;
    end

    % now find our triggering behavior ------------------------------------

    bhv     = h.bhv.String{h.bhv.Value};
    ch      = h.chTrig.String{h.chTrig.Value};
    discard = str2double(h.discard.String)/str2double(h.bin.String);
    merge   = str2double(h.merge.String)/str2double(h.bin.String);

    % find the trigger frames for the behavior raster
    if(isfield(data.annot,ch) & isfield(data.annot.(ch),bhv))
        rast    = convertToRast(data.annot.(ch).(bhv),length(data.annoTime));
    else
        rast = zeros(1,length(data.annoTime));
    end
    dt      = rast(2:end) - rast(1:end-1);
    tbB     = find(dt==1);
    teB     = find(dt==-1);

    % find the trigger frames for the plotted trace
    if isempty(data.CaTime)
        tb      = round(tbB*useFR/data.annoFR); 
        te      = round(teB*useFR/data.annoFR);
    else
        tb      = round(tbB*useFR/data.annoFR + (data.annoTime(1)-data.CaTime(1))*useFR); % resample and apply any offset between bhvr and neural data
        te      = round(teB*useFR/data.annoFR + (data.annoTime(1)-data.CaTime(1))*useFR);
    end

    if(isempty(tb)), continue; end

    if(te(1)<tb(1)), te(1) = []; end
    if(length(te)<length(tb)), tb(end) = []; end
    if(teB(1)<tbB(1)), teB(1) = []; end
    if(length(teB)<length(tbB)), tbB(end) = []; end
    
    % drop bouts that happen before the recording
    drop = find(tb<0 | te<0);
    tb(drop)=[];
    te(drop)=[];
    tbB(drop)=[];
    teB(drop)=[];

    % merge bouts that are close together
    drop = find((tb(2:end)-te(1:end-1)) < merge);
    tb(drop+1)=[];
    te(drop)=[];
    tbB(drop+1)=[];
    teB(drop)=[];

    % delete short bouts
    drop = find((te - tb) < discard);
    tb(drop) = [];
    te(drop) = [];
    tbB(drop)=[];
    teB(drop)=[];
    if(isempty(tb)), continue; end

    if(h.toggle.start.Value)
        use = round(tb);
        useB = round(tbB);
    else
        use = round(te);
        useB = round(teB);
    end

    % now compute the BTA for this trial ----------------------------------
    gui = transferAnnot(gui,data);
    boutPic = makeBhvImage(gui.annot.bhv,gui.annot.cmap,[],length(gui.data.annoTime),showAnnot);

    BTA = nan(length(use),length(win));
    BTB = ones(length(use),length(win),3);
    N = size(sig,1);bump = 0;
    for n = 1:N
        if(~plotTraces) %change active channel
            gui.annot.activeCh = h.chAvg.String{h.chAvg.Value(n)};
            gui = transferAnnot(gui,data);
            boutPic = makeBhvImage(gui.annot.bhv,gui.annot.cmap,[],length(gui.data.annoTime),showAnnot);
        end
        for i = 1:length(use)
            inds = find((use(i)+win)>0 & (use(i)+win)<length(sig));
            BTA(i+bump,inds) = sig(n,use(i) + win(inds));

            boutInds    = find((useB(i)+winB)>0 & (useB(i)+winB)<length(boutPic));
            BTB(i+bump,boutInds,:) = boutPic(1,useB(i) + winB(boutInds),:);
        end
        bump = bump + length(use);
    end
    BTAstack = [BTAstack;BTA];
    BTBstack = cat(1,BTBstack,BTB);
end
BTA=BTAstack;
BTB=BTBstack;

% make sure we got some bouts
if(isempty(BTA))
    axes(h.fig);
    px=get(h.fig,'xlim');
    py=get(h.fig,'ylim');
    text(mean(px),mean(py),'no bouts found','HorizontalAlignment','center');
    uistack(h.figLine,'top');
    h.isActive = 1;
    guidata(source,h);
    return;
end

BTAmeans = nanmean(BTA,2);
BTAstd   = nanstd(BTA,[],2)+eps;
if(h.zscore.Value)
    BTA  = bsxfun(@times,bsxfun(@minus,BTA,BTAmeans),1./BTAstd);
end
BTAmin  = min(nanmean(BTA,2));
BTAmax  = max(nanmean(BTA,2));




clearBTA(source,[]);
axes(h.fig);
SEM  = 1/sqrt(max(length(use),1));
time = win/useFR;
if(size(BTA,1)>1)
    drawvar(time,BTA,usecolor,SEM);
    xlim(time([1 end]))
    p(1) = min(min(nanmean(BTA) - nanstd(BTA)*SEM),0);
    p(2) = max(nanmean(BTA) + nanstd(BTA)*SEM) + max(abs(nanstd(BTA)*SEM))*0.1 + eps;
else
    plot(time,BTA,'color',usecolor);
    xlim(time([1 end]))
    p(1) = min([BTA 0]);
    p(2) = max(BTA)+eps;
end

p(isnan(p)) = 1;

set(h.figLine,'ydata',p);
set(h.fig,'ylim',p);
h.fig.Title.String = [strrep(bhv,'_',' ') '-triggered average of ' strrep(strrep(str,'_',' '),'behavior: ','')];
uistack(h.figLine,'top');

axes(h.fig_sub);
image(winB/gui.data.annoFR,[-size(BTA,1) -1],flipud(BTB)*2/3+1/3);
if(plotTraces)
    BTAplot = bsxfun(@minus,BTA,min(BTA(:)));
    BTAplot = bsxfun(@times,BTAplot,1./max(BTAplot(:)));
    plot(time,bsxfun(@plus,BTAplot',-(1:size(BTAplot,1)))-.5,'k');
end
ylim([-size(BTA,1)-0.5 -0.5]);

set(h.figLineS,'ydata',[-size(BTA,1)-0.5 -0.5]);
uistack(h.figLineS,'top');

h.isActive = 1;
guidata(source,h);
end

function [m,s,tr] = parseTrialString(trial)
    [~,~,hits]=regexp(trial,['mouse (\d+), session (\d+), trial (\d+)']);
    m = str2double(trial(hits{1}(1,1):hits{1}(1,2)));
    s = str2double(trial(hits{1}(2,1):hits{1}(2,2)));
    tr = str2double(trial(hits{1}(3,1):hits{1}(3,2)));
end













