function bhvList = getAllBehaviors(gui)
%
% (C) Ann Kennedy, 2019
% California Institute of Technology
% Licensing: https://github.com/annkennedy/bento/blob/master/LICENSE.txt



data    = gui.allData;
inds    = gui.allPopulated;

bhvList = {};
for i = 1:size(inds,1)
    m       = inds(i,1);
    sess    = ['session' num2str(inds(i,2))];
    trial   = inds(i,3);
    anno    = data(m).(sess)(trial).annot;
    
    channels = fieldnames(anno);
    for ch = 1:length(channels)
        bhvList = [bhvList; fieldnames(anno.(channels{ch}))];
    end
end
bhvList = unique(bhvList);