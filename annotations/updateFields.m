function updateFields(source,~,fieldname)
parent = source;
gui    = guidata(source);

% change the active channel if needed
if(~strcmpi(source.String{source.Value},'add new...'))
    if(~strcmpi(fieldname,'channel'))
        return;
    else
        gui     = guidata(source);
        gui     = readoutAnnot(gui);
        gui.annot.activeCh = source.String{source.Value};
        gui     = transferAnnot(gui,gui.data);
        updateSliderAnnot(gui);
        guidata(parent,gui);
        updatePlot(gui.h0,[]);
        return;
    end
end

switch fieldname
    case 'channel'
        labels  = gui.annot.channels;
    case 'annot'
        labels  = fieldnames(gui.annot.bhv);
end

h = figure('dockcontrols','off','menubar','none','NumberTitle','off');
p = get(h,'Position');
set(h,'Position',[p(1:2) 350 100]);

uicontrol('Style','text',...
            'HorizontalAlignment','left',...
            'String',['Name of new ' fieldname ':'],...
            'Position', [20 60 200 20]);
temp2 = uicontrol('Style','pushbutton',...
            'String','Accept',...
            'Position', [245 60 80 30]);
uicontrol('Style','pushbutton',...
            'String','Cancel',...
            'Position', [245 20 80 30],...
            'Callback',@closeBrowser);
newStr = uicontrol('Style','edit',...
            'String','',...
            'Position', [20 20 200 30]);
        
switch fieldname
    case 'channel'
        set(temp2,'Callback',{@addChannel,labels,newStr,parent});
    case 'annot'
        set(temp2,'Callback',{@addLabel,labels,newStr,parent});
end

uicontrol(newStr);