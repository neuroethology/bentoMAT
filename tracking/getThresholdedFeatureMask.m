function [mask,params] = getThresholdedFeatureMask(gui,params)
%
% (C) Ann Kennedy, 2019
% California Institute of Technology
% Licensing: https://github.com/annkennedy/bento/blob/master/LICENSE.txt



% create mask parameters from current plots
if(~exist('params','var'))
    for i=1:length(gui.features.feat) %iterate over all plotted features (assume we're ANDing them)

        ch      = gui.features.feat(i).ch;
        featNum = gui.features.feat(i).featNum;

        params(i).ch        = ch;
        params(i).featNum   = featNum;
        params(i).limL      = str2num(gui.features.feat(i).threshValL.String);
        params(i).limU      = str2num(gui.features.feat(i).threshValU.String);
    end
end

% apply parameters to tracking data
mask = true(1,size(gui.data.tracking.features,2));
for i=1:length(params)
    vals        = gui.data.tracking.features(params(i).ch,:,params(i).featNum);
    if(params(i).limL>params(i).limU)
        mask = mask & ((vals<=params(i).limL) & (vals>=params(i).limU));
    else
        mask = mask & ((vals<=params(i).limL) | (vals>=params(i).limU));
    end
end
mask = convertToRast(floor(gui.data.trackTime(convertToBouts(mask))*gui.data.annoFR),length(gui.data.annoTime));