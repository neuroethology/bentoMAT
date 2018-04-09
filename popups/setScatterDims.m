function setScatterDims(source,~)

gui   = guidata(source);
varlist = evalin('base','who()');
keep    = zeros(size(varlist));
for i=1:length(varlist)
    temp = evalin('base',varlist{i});
    keep(i) = isnumeric(temp) && any(size(temp)==size(gui.data.rast,1));
end
varlist = varlist(keep~=0);

if(isempty(varlist))
    msgbox('No suitable projection axes found in workspace.');
    return;
end

clear h;
h.gui = gui;
h.fig = figure('dockcontrols','off','menubar','none',...
        'Tag','Trace browser','NumberTitle','off','name','Project data onto specified axes');
set(h.fig,'position',h.fig.Position.*[1 1 1 .3] + [0 h.fig.Position(4)/4 0 0]);

h.dims  = [];
h.inds  = [];
for i=1:length(varlist)
    d = size(evalin('base',varlist{i}));
    if(~isempty(setdiff(d,size(gui.data.rast,1))))
        [h.dims(i), h.ind(i)] = setdiff(d,size(gui.data.rast,1));
    else
        h.dims(i) = 135;
        h.ind(i)  = 0;
    end
end

h2(1) = uipanel('parent',h.fig,'title','Dimension 1',...
                'units','normalized','bordertype','none',...
                'Position',[0.025 .5 .7 .4]);
h.d1.var = uicontrol('parent',h2(1),'Style','popupmenu',...
                'String',varlist,'tag','d1',...
                'units','normalized','Position',[.05 .5 .5 .4],'callback',@setIndexRange);
h.d1.dim = uicontrol('parent',h2(1),'Style','popupmenu',...
                'String',{'row #','column #'},'tag','d1',...
                'units','normalized','Position',[.575 .5 .2 .4],'callback',@setIndexRange);
h.d1.val = uicontrol('parent',h2(1),'Style','popupmenu','String',' ',...
                'units','normalized','Position',[.8 .5 .15 .4]);

h2(2) = uipanel('parent',h.fig,'title','Dimension 2',...
                'units','normalized','bordertype','none',...
                'Position',[0.025 .1 .7 .4]);
h.d2.var = uicontrol('parent',h2(2),'Style','popupmenu',...
                'String',varlist,'tag','d2',...
                'units','normalized','Position',[.05 .5 .5 .4],'callback',@setIndexRange);
h.d2.dim = uicontrol('parent',h2(2),'Style','popupmenu',...
                'String',{'row #','column #'},'tag','d2',...
                'units','normalized','Position',[.575 .5 .2 .4],'callback',@setIndexRange);
h.d2.val = uicontrol('parent',h2(2),'Style','popupmenu','String',' ',...
                'units','normalized','Position',[.8 .5 .15 .4]);
            
h.go = uicontrol('parent',h.fig,'Style','pushbutton','String','Go',...
                'units','normalized','Position',[.75 .15 .2 .7],...
                'fontsize',11,'backgroundcolor',[.62 1 .62],'callback',@applyProjections);
guidata(h.fig,h);
end

function setIndexRange(source,~)
    h = guidata(source);
    d = source.Tag;
    h.(d).val.Value  = 1;
    h.(d).val.String = num2str((1:h.dims(h.(d).var.Value))');
    if(h.ind(h.(d).var.Value)==0)
        h.(d).dim.Enable = 'on';
    else
        h.(d).dim.Enable = 'off';
        h.(d).dim.Value   = h.ind(h.(d).var.Value);
    end
end

function applyProjections(source,~)
    h   = guidata(source);
    gui = guidata(h.gui.h0);
    
    var1 = evalin('base',h.d1.var.String{h.d1.var.Value});
    if(h.d1.dim.Value==1),  w1 = var1(h.d1.val.Value,:);
    else,                   w1 = var1(:,h.d1.val.Value)'; end
    
    var2 = evalin('base',h.d2.var.String{h.d2.var.Value});
    if(h.d2.dim.Value==1),  w2 = var2(h.d2.val.Value,:);
    else,                   w2 = var2(:,h.d2.val.Value)'; end
    
    gui.data.proj.d1 = w1;
    gui.data.proj.d2 = w2;
    gui.enabled.traces(2)  = 0;
    gui.enabled.scatter(2) = 1;
    
    rast = [gui.allData(gui.data.info.mouse).(gui.data.info.session).rast];
    p1  = w1*rast;
    p2  = w2*rast;
    set(gui.scatter.alldata,'xdata',p1,'ydata',p2);
    
    close(h.fig);
    gui = redrawPanels(gui);
    guidata(gui.h0,gui);
    updatePlot(gui.h0,[]);
end





