function gui = redrawFeaturePlots(gui)

nfeat = length(gui.features.feat);

% update the positioning of the displayed feature axes
for i = 1:nfeat
    gui.features.feat(i).axes.Position  = [0.085   0.15+0.85*(i-1)/nfeat                0.85 0.8/nfeat];
    gui.features.feat(i).rmBtn.Position = [0.015 0.15+0.85*(i-1)/nfeat+(0.4/nfeat-0.02) 0.05 0.04];
    
    xlabel(gui.features.feat(i).axes,'');
    set(gui.features.feat(i).axes,'xtick',[]);
    
    lims = [min(gui.data.tracking.features(:,gui.features.feat(i).featNum)) ...
            max(gui.data.tracking.features(:,gui.features.feat(i).featNum))];
    set(gui.features.feat(i).axes,'ylim',lims);
    set(gui.features.feat(i).zeroLine,'ydata',lims);
end

set(gui.features.feat(1).axes, 'XTickMode', 'auto', 'XTickLabelMode', 'auto');
xlabel(gui.features.feat(1).axes,'time (sec)');