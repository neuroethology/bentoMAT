function computeBTA(source,~,gui)
%
% (C) Ann Kennedy, 2019
% California Institute of Technology
% Licensing: https://github.com/annkennedy/bento/blob/master/LICENSE.txt


h = guidata(source);

% first get the signal we're analyzing, and sample at the desired rate ----
plotTraces = 1;
unit    = h.unit.Value;
str = h.unit.String{unit};
useFR = 1/str2double(h.bin.String);
switch lower(str(1))
    case 'p' % population average
        sig     = nanmean(gui.data.rast);
        sig     = nan_fill(sig);
        sig     = resample(sig,useFR,gui.data.CaFR);
        
    case 'u' % unit
        if(isfield(gui.data,'PCs'))
            bump = size(gui.data.PCs,1);
        else
            bump = 0;
        end
        sig     = gui.data.rast(unit - 1 - bump,:);
        sig     = nan_fill(sig);
        sig     = resample(sig,useFR,gui.data.CaFR);
        
    case 'b' % behavior
        sig = double(gui.annot.bhv.(strrep(str,'behavior: ','')));
        sig = nan_fill(sig);
        % resample at the desired framerate:
        sig2 = convertToBouts(sig);
        sig2 = round(sig2*useFR/gui.data.annoFR);
        sig = double(convertToRast(sig2,round(length(sig)*useFR/gui.data.annoFR))); % sig is now binary at our desired framerate~
        plotTraces = 0;
        
end


% now find our triggering behavior ----------------------------------------

bhv         = h.bhv.String{h.bhv.Value};
discard     = str2double(h.discard.String)/str2double(h.bin.String);
merge       = str2double(h.merge.String)/str2double(h.bin.String);

% find the trigger frames for the behavior raster
rast    = gui.annot.bhv.(bhv);
dt      = rast(2:end) - rast(1:end-1);
tbB     = find(dt==1);
teB     = find(dt==-1);

% find the trigger frames for the plotted trace
tb      = round(tbB*useFR/gui.data.annoFR);
te      = round(teB*useFR/gui.data.annoFR);

if(isempty(tb))
    clearBTA(source,[]);
    axes(h.fig);
    px=get(h.fig,'xlim');
    py=get(h.fig,'ylim');
    text(mean(px),mean(py),'no bouts found','HorizontalAlignment','center');
    uistack(h.figLine,'top');
    h.isActive = 1;
    guidata(source,h);
    return;
end

if(te(1)<tb(1)), te(1) = []; end
if(length(te)<length(tb)), tb(end) = []; end
if(teB(1)<tbB(1)), teB(1) = []; end
if(length(teB)<length(tbB)), tbB(end) = []; end

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

if(h.toggle.start.Value)
    use = round(tb);
    useB = round(tbB);
else
    use = round(te);
    useB = round(teB);
end


% make sure we still have some bouts left
if(isempty(use))
    axes(h.fig);
    px=get(h.fig,'xlim');
    py=get(h.fig,'ylim');
    text(mean(px),mean(py),'no bouts found','HorizontalAlignment','center');
    uistack(h.figLine,'top');
    h.isActive = 1;
    guidata(source,h);
    return;
end

% now compute the BTA -----------------------------------------------------
win  = round(-str2double(h.pre.String)*useFR):round(str2double(h.post.String)*useFR);
winB = round(-str2double(h.pre.String)*gui.data.annoFR):round(str2double(h.post.String)*gui.data.annoFR);
BTA  = nan(length(use),length(win));

bouts   = ones(length(use),length(win),3);
showAnnot = struct();
for i = 1:length(h.bhvrs)
    showAnnot.(strrep(h.bhvrs(i).Tag,'checkbox_','')) = h.bhvrs(i).Value;
end
boutPic = makeBhvImage(gui.annot.bhv,gui.annot.cmap,[],length(gui.data.annoTime),showAnnot);

clearBTA(source,[]);
    
for i = 1:length(use)
    inds = find((use(i)+win)>0 & (use(i)+win)<length(sig));
    BTA(i,inds) = sig(use(i) + win(inds));
    
    boutInds    = find((useB(i)+winB)>0 & (useB(i)+winB)<length(boutPic));
    bouts(i,boutInds,:) = boutPic(1,useB(i) + winB(boutInds),:);
end
BTAmeans = nanmean(BTA,2);
BTAstd   = nanstd(BTA,[],2)+eps;
if(h.zscore.Value)
    BTA  = bsxfun(@times,bsxfun(@minus,BTA,BTAmeans),1./BTAstd);
end
BTAmin  = min(nanmean(BTA,2));
BTAmax  = max(nanmean(BTA,2));

axes(h.fig);
SEM  = 1/sqrt(max(length(use),1));
if(size(BTA,1)>1)
    drawvar(win/useFR,BTA,'b',SEM);
    p(1) = min(min(nanmean(BTA) - nanstd(BTA)*SEM),0);
    p(2) = max(nanmean(BTA) + nanstd(BTA)*SEM)*1.05 + eps;
else
    plot(win/useFR,BTA,'b');
    p(1) = min([BTAmin 0]);
    p(2) = BTAmax+eps;
end

p(isnan(p)) = 1;

set(h.figLine,'ydata',p);
set(h.fig,'ylim',p);
uistack(h.figLine,'top');

axes(h.fig_sub);
image(winB/gui.data.annoFR,[-size(BTA,1) -1]*6,flipud(bouts)*2/3+1/3);
if(plotTraces)
    plot(win/useFR,bsxfun(@plus,BTA',-(1:size(BTA,1))*6),'k');
end
ylim([-size(BTA,1)-0.5 -0.5]*6);

set(h.figLineS,'ydata',[-size(BTA,1)-0.5 -0.5]*6);
uistack(h.figLineS,'top');

h.isActive = 1;
guidata(source,h);















