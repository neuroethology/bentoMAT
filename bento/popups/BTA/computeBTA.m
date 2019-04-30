function computeBTA(source,~,data)
%
% (C) Ann Kennedy, 2019
% California Institute of Technology
% Licensing: https://github.com/annkennedy/bento/blob/master/LICENSE.txt


h = guidata(source);

bhv         = h.bhv.String{h.bhv.Value};
discard     = str2double(h.discard.String)*data.frBhv;
merge       = str2double(h.merge.String)*data.frBhv;

unit    = h.unit.Value;
if(unit==1)
    sig = nanmean(data.rast);
else
    str = h.unit.String{unit};
    switch lower(str(1))
        case 'p' % PC
            sig     = data.PCs(unit - 1,:);
        case 'u' % unit
            bump    = size(data.PCs,1);
            sig     = data.rast(unit - 1 - bump,:);
    end
end
sig     = nan_fill(sig);

dt      = data.bhv.(bhv);
dt      = fillBehGaps(dt,merge);
dt      = dt(2:end) - dt(1:end-1);

tb      = find(dt==1);
te      = find(dt==-1);
if(te(1)<tb(1)), te(1) = []; end
if(length(te)<length(tb)), tb(end) = []; end

del     = te - tb;
tb(del<discard) = [];
te(del<discard) = [];

if(h.toggle.start.Value)
    use = round(tb*data.frCa/data.frBhv);
    useB = round(tb);
else
    use = round(te*data.frCa/data.frBhv);
    useB = round(te);
end

win  = round(-str2num(h.pre.String)*data.frCa):round(str2num(h.post.String)*data.frCa);
winB = round(-str2num(h.pre.String)*data.frBhv):round(str2num(h.post.String)*data.frBhv);
BTA  = nan(length(use),length(win));

bouts   = ones(length(use),length(win),3);
showAnnot = struct();
for i = 1:length(h.bhvrs)
    showAnnot.(data.lbls{i}) = h.bhvrs(i).Value;
end
% need to define tmax
boutPic = makeBhvImage(data.bhv,data.cmap,[],tmax,showAnnot);

clearBTA(source,[]);
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
    
for i = 1:length(use)
    inds = find((use(i)+win)>0 & (use(i)+win)<length(sig));
    BTA(i,inds) = sig(use(i) + win(inds));
    
    boutInds    = find((useB(i)+winB)>0 & (useB(i)+winB)<length(boutPic));
    bouts(i,boutInds,:) = boutPic(1,useB(i) + winB(boutInds),:);
end
BTAmeans = nanmean(BTA,2);
BTAstd   = nanstd(BTA,[],2);
if(h.zscore.Value)
    BTA  = bsxfun(@times,bsxfun(@minus,BTA,BTAmeans),1./BTAstd);
else
    BTA  = bsxfun(@minus,BTA,BTAmeans)/max(BTAstd);
end
BTAmin  = min(nanmean(BTA,2));
BTAmax  = max(nanmean(BTA,2));

axes(h.fig);
SEM  = 1/sqrt(max(length(use),1));
drawvar(win/11,BTA,'b',SEM);
p(1) = min(min(nanmean(BTA) - nanstd(BTA)*SEM),0);
p(2) = max(nanmean(BTA) + nanstd(BTA)*SEM)*1.05;
p(isnan(p)) = 1;

set(h.figLine,'ydata',p);
set(h.fig,'ylim',p);
uistack(h.figLine,'top');

axes(h.fig_sub);
image(win/11,[-size(BTA,1) -1]*6,flipud(bouts)*2/3+1/3);
plot(win/11,bsxfun(@plus,BTA',-(1:size(BTA,1))*6),'k');
ylim([-size(BTA,1)-0.5 -0.5]*6);

set(h.figLineS,'ydata',[-size(BTA,1)-0.5 -0.5]*6);
uistack(h.figLineS,'top');

h.isActive = 1;
guidata(source,h);















