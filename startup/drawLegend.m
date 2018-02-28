function gui = drawLegend(gui)

if(isfield(gui,'legend'))
    delete(gui.legend.panel);
end

legend.panel     = uipanel('position',[0 0 1 1],'bordertype','none');
legend.axes      = axes('parent',legend.panel,'position',[0.01 .13 0.98 .87],'xlim',[0 1],'ylim',[0 1]);
axis ij; axis off;

legend.editColor = uicontrol('parent',legend.panel,'style','pushbutton','string','Edit colors',...
        'units','normalized','position',[.15 .015 .7 .055],'callback',@launchColorPick);
legend.editKeys = uicontrol('parent',legend.panel,'style','pushbutton','string','Edit hotkeys',...
        'units','normalized','position',[.15 .075 .7 .055],'callback',@setAnnotHotkeys);

gui.legend = legend;