function saveBTA(source,~)

h=guidata(source);
p = h.panelPlots.Position;
p2 = h.hfig.Position;

h2.hfig2        = figure('position',[p2(1:2) p(3)/.8 p(4)]);
h2.panelPlots   = uipanel('parent',h2.hfig2,'position',[.2 0 .8 1],'bordertype','none','BackgroundColor','white');
h2.fig          = copyobj(h.fig,h2.panelPlots);
h2.fig_sub      = copyobj(h.fig_sub,h2.panelPlots);
set(h2.fig.Title,'String',[h2.fig.Title.String ' of ' strrep(h.unit.String{h.unit.Value},'behavior: ','')]);
set(h2.hfig2,'color','white');

h2 = drawLegend(h2);
set(h2.legend.panel,'BackgroundColor','white');
set(h2.legend.innerPanel,'BackgroundColor','white');
h2.legend.panel.Position = [0 0 .2 1];

gui = guidata(h.h0);
h2.annot = gui.annot;
h2.annot.hotkeys = struct();
h2.h0 = h2.hfig2;
updateLegend(h2);
h2.legend.editColor.Visible='off';
h2.legend.editKeys.Visible='off';

[FileName,PathName] = uiputfile([h.bhv.String{h.bhv.Value} '_triggered_average.pdf'],'Saving figure...');

pos = get(h2.hfig2,'Position');
set(h2.hfig2,'PaperPositionMode','Auto','PaperUnits','inches','PaperSize',[pos(3), pos(4)]/150*2)
saveas(h2.hfig2,[PathName filesep FileName]);
close(h2.hfig2);

