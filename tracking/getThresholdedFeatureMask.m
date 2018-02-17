function [mask,params] = getThresholdedFeatureMask(gui,params)

% create mask parameters from current plots
if(~exist('params','var'))
    for i=1:length(gui.features.feat) %iterate over all plotted features (assume we're ANDing them)

        ch      = gui.features.feat(i).ch;
        featNum = gui.features.feat(i).featNum;
        lim     = get(gui.features.feat(i).axes,'ylim');

        params(i).ch        = ch;
        params(i).featNum   = featNum;
        params(i).thrBound  = gui.features.feat(i).thrBound;
        params(i).thr       = gui.features.feat(i).threshold.Value*(lim(2)-lim(1));
    end
end

% apply parameters to tracking data
mask = true(1,size(gui.data.tracking.features,2));
for i=1:length(params)
    vals        = gui.data.tracking.features(params(i).ch,:,params(i).featNum);
    if(params(i).thrBound==1)
        mask = mask & (vals<=params(i).thr);
    else
        mask = mask & (vals>=params(i).thr);
    end
end
    