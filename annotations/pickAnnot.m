function pickAnnot(source,~)
%
% (C) Ann Kennedy, 2019
% California Institute of Technology
% Licensing: https://github.com/annkennedy/bento/blob/master/LICENSE.txt


parent      = source;
gui = guidata(source);

lbls = fieldnames(gui.annot.cmap);
nbeh = length(lbls);
ncol = ceil(nbeh/10);
nrows = ceil(nbeh/ncol);
colwidth = 200;

hfig = figure('dockcontrols','off','menubar','none',...
    'Tag','Annot browser','NumberTitle','off');
gui.browser = hfig;


p = get(hfig,'position');
p0 = get(0,'screenSize');
py = p0(4)-(nrows*35+50);
if(py>0)
    py = py/2;
end
set(hfig,'position',[p(1) py ncol*colwidth nrows*35+50]);

bump = nrows*35;
uicontrol('Style','text',...
            'String','Select annotations to display:',...
            'Position',[0 bump ncol*colwidth 30]);
bump = bump - 5;
for j = 1:ceil(nbeh/ncol)
    bump = bump - 35;
    for i = 1:ncol
        b = (j-1)*ncol + i;
        if(b<=length(lbls))
            cbox = getButtonImage(gui.annot.cmap.(lbls{b}),gui.annot.show.(lbls{b}));
            h.bhvrs(b) = uicontrol('Style','checkbox',...
                    'Value',gui.annot.show.(lbls{b}),...
                    'Position',[30+(i-1)*colwidth bump+13 30 30],...
                    'CData',cbox,...
                    'Callback',{@updateAnnot,parent,lbls{b}});
            uicontrol('Style','text',...
                    'String',strrep(lbls{b},'_',' '),...
                    'HorizontalAlignment','left',...
                    'Position',[60+(i-1)*colwidth bump 120 35]);
        end
    end
end

guidata(source,gui);
end

function updateAnnot(source,~,parent,str)

gui = guidata(parent);
str = strrep(str,' ','_');
gui.annot.show.(str) = source.Value;
guidata(parent,gui);

cbox = getButtonImage(gui.annot.cmap.(str),source.Value);
set(source,'CData',cbox);

updateSliderAnnot(gui);
updateLegend(gui,1);
updatePlot(parent,[]);
end