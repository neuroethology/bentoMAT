function pickUnits(source,~)
    parent      = source;
    gui         = guidata(source);
    
    switch gui.traces.toPlot
        case 'rast'
            plotStr = 'Cell ';
            rast = gui.data.rast;
        case 'PCs'
            plotStr = 'PC ';
            rast = gui.data.PCA'*gui.data.rast;
        case 'dt'
            plotStr = 'Cell ';
            rast = gui.data.dt;
    end
    plotUnits   = gui.traces.show;

    N           = size(rast,1);
    nrow        = 16; %up to 16 buttons per column
    ncol        = ceil(N/nrow);
    W           = 70;
    
    h = figure('dockcontrols','off','menubar','none',...
        'Tag','Trace browser','NumberTitle','off');
    gui.browser = h;
    
    p = get(h,'position');
    figW = max(ncol*W,300);
    set(h,'position',[p(1:2) figW 450]);
    uicontrol('Style','text','String','Select elements to plot:',...
              'Position', [0 420 max(ncol*W,300) 20]);
    for i = 1:N
        colnum = floor(20*(i-1)/(nrow*20)) - ncol/2;
        rownum = mod(20*(i-1),(nrow*20));
        h2(i) = uicontrol('Style','radiobutton',...
                'Value',plotUnits(i),...
                'Position',[figW/2 + W*colnum  nrow*20+W-rownum 20 20],...
                'callback',{@toggleUnit,parent,i});
        uicontrol('Style','text',...
                'String',[plotStr num2str(i)],...
                'Position', [figW/2  + 15 + W*colnum  nrow*20+W-rownum 40 20]);
    end
    for i = 1:ncol
        inds = (i-1)*16+(1:16);
        inds(inds>N) = [];
        uicontrol('Style','pushbutton',...
                'String','Off',...
                'Position',[figW/2 + W*(i-1-ncol/2) 40 40 20],...
                'callback',{@toggleUnit,parent,inds});
        uicontrol('Style','pushbutton',...
                'String','On',...
                'Position',[figW/2 + W*(i-1-ncol/2) 60 40 20],...
                'callback',{@toggleUnit,parent,inds});
    end
    uicontrol('Style','text',...
                'String','^^^ toggle entire column ^^^',...
                'Position', [0 15 figW 20]);
    guidata(h,h2);
    guidata(parent,gui);
end

function toggleUnit(source,eventdata,parent,cellnums)
    gui = guidata(parent);
    if(strcmpi(source.Style,'radiobutton'))
        gui.traces.show(cellnums) = source.Value;
    elseif(strcmpi(source.String,'On'))
        gui.traces.show(cellnums) = 1;
        h2 = guidata(source);
        for i = cellnums
            h2(i).Value = 1;
        end
    else
        gui.traces.show(cellnums) = 0;
        h2 = guidata(source);
        for i = cellnums
            h2(i).Value = 0;
        end
    end
    guidata(parent,gui);
    updatePlot(parent,eventdata);
end