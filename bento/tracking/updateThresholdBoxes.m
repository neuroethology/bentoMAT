function updateThresholdBoxes(gui,featInd)
%
% (C) Ann Kennedy, 2019
% California Institute of Technology
% Licensing: https://github.com/annkennedy/bento/blob/master/LICENSE.txt



lim     = get(gui.features.feat(featInd).axes,'ylim');
limU = str2num(gui.features.feat(featInd).threshValU.String);
limL = str2num(gui.features.feat(featInd).threshValL.String);

if(limU>limL)
    set(gui.features.feat(featInd).threshLineU,'xdata',gui.features.win*[-1 1 1 -1],...
                'ydata',[lim(2) lim(2) limU limU]);
    set(gui.features.feat(featInd).threshLineL,'xdata',gui.features.win*[-1 1 1 -1],...
                'ydata',[lim(1) lim(1) limL limL]);
else
    set(gui.features.feat(featInd).threshLineU,'xdata',gui.features.win*[-1 1 1 -1],...
            'ydata',[limL limL limU limU]);
    set(gui.features.feat(featInd).threshLineL,'xdata',gui.features.win*[-1 1 1 -1],...
            'ydata',[0 0 0 0]);
end