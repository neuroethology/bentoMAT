function gui = redrawFeaturePlots(gui)

nfeat = length(gui.features.feat);

% update the positioning of the displayed feature axes
for i = 1:nfeat
    gui.features.feat(i).axes.Position      = [0.1 0.15+0.85*(i-1)/nfeat 0.85 0.8/nfeat];
    gui.features.feat(i).rmBtn.Position     = [0.9 0.1075+0.85*(i-1)/nfeat+0.8/nfeat 0.05 0.04];
    gui.features.feat(i).thresholdU.Position = [0.02 0.2+0.85*(i-1)/nfeat+.1/nfeat 0.03 0.5/nfeat];
    gui.features.feat(i).thresholdL.Position = [0.055 0.2+0.85*(i-1)/nfeat+.1/nfeat 0.03 0.5/nfeat];
    gui.features.feat(i).threshValU.Position = [0.125 0.195+0.85*(i-1)/nfeat+.02/nfeat 0.25 0.04];
    gui.features.feat(i).threshValL.Position = [0.125 0.15+0.85*(i-1)/nfeat+.02/nfeat 0.25 0.04];
    
    xlabel(gui.features.feat(i).axes,'');
    set(gui.features.feat(i).axes,'xtick',[]);
    
    lims = [min(reshape(gui.data.tracking.features(:,:,gui.features.feat(i).featNum),1,[])) ...
            max(reshape(gui.data.tracking.features(:,:,gui.features.feat(i).featNum),1,[]))];
    set(gui.features.feat(i).axes,'ylim',lims);
    set(gui.features.feat(i).zeroLine,'ydata',lims);

    
    updateThresholdBoxes(gui,i);
end

set(gui.features.feat(1).axes, 'XTickMode', 'auto', 'XTickLabelMode', 'auto');
xlabel(gui.features.feat(1).axes,'time (sec)');