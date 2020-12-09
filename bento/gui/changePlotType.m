function changePlotType(source,~)
    %
    % (C) Ann Kennedy, 2019
    % California Institute of Technology
    % Licensing: https://github.com/annkennedy/bento/blob/master/LICENSE.txt


    gui = guidata(source);

    oldPlot = gui.traces.toPlot;
    if(strcmpi(oldPlot(1:3),'img'))
        gui.traces.tracesIm.Visible = 'off';
    else
        delete(gui.traces.axes.Children(1:end-4));
        gui.traces.traces=[];
        gui.traces.groupLines=[];
    end

    switch(source.String{source.Value})
        case 'units'
            gui.traces.toPlot = 'rast';
            if(strcmpi(oldPlot,'PCA')||strcmpi(oldPlot,'ctrs'))
                gui.traces.show = true(size(gui.data.rast,1),1);
            end
        case 'd/dt'
            gui.traces.toPlot = 'ddt';
            if(strcmpi(oldPlot,'PCA')||strcmpi(oldPlot,'ctrs'))
                gui.traces.show = true(size(gui.data.rast,1),1);
            end
        case 'smoothed'
            gui.traces.toPlot = 'sm_rast';
            gui.data.sm_rast = gui.data.rast;
            gui.data.sm_rast(:,2:end-1) = promptSmKernel(gui.data.rast(:,2:end-1));
            if(strcmpi(oldPlot,'PCA')||strcmpi(oldPlot,'ctrs'))
                gui.traces.show = true(size(gui.data.rast,1),1);
            end
        case 'PCs'
            gui.traces.toPlot = 'PCA';
            getPCAxes(gui,source,'PCA');
        case 'NMF'
            gui.traces.toPlot = 'PCA';
            getPCAxes(gui,source,'NMF');
        case 'clusters'
            gui.traces.toPlot = 'ctrs';
            gui.traces.show = true(10,1);
    end
    gui.data.([gui.traces.toPlot '_formatted']) = applyScale(gui);

    if(~any(strcmpi(source.String{source.Value},{'PCs','NMF'})))
        guidata(source,gui);
        updatePlot(source,[]);
    end

end

function sm_rast = promptSmKernel(rast)
    p = get(0,'defaultFigurePosition');
    d = dialog('Position',[p(1:2) 250 150],'Name','Set smoothing kernel');
    txt = uicontrol('Parent',d,...
           'Style','text',...
           'Position',[20 100 100 25],...
           'String','Kernel type:');
    h.smkH = uicontrol('Parent',d,...
           'Style','popup',...
           'Position',[115 100 100 25],...
           'String',{'Gaussian';'Exponential'});
    
    txt = uicontrol('Parent',d,...
           'Style','text',...
           'Position',[20 60 100 25],...
           'String','Kernel width: (frames)');
    h.smwH = uicontrol('Parent',d,...
           'Style','edit',...
           'Position',[115 65 100 25],...
           'String','5');
       
    btn = uicontrol('Parent',d,...
           'Position',[89 20 70 25],...
           'String','OK',...
           'Callback',@exit_callback);
       
    sm_rast = rast;
    smk = 'Gaussian';
    smw = 5;
    
    guidata(d,h);
       
    % Wait for d to close before running to completion
    uiwait(d);
    
    switch smk
        case 'Gaussian'
            sm_rast = smoothts(rast,'g',smw*5,smw);
        case 'Exponential'
            sm_rast = smoothts([zeros(size(rast,1),1) rast],'e',smw);
            sm_rast = sm_rast(:,2:end);
    end

    function exit_callback(closebtn,~)
        h = guidata(closebtn.Parent);
        smk = h.smkH.String{h.smkH.Value};
        smw = str2num(regexprep(h.smwH.String,'[^0-9.]',''));
        delete(gcf);
    end
end