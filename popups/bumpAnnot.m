function bumpAnnot(source)
%
% (C) Ann Kennedy, 2019
% California Institute of Technology
% Licensing: https://github.com/annkennedy/bento/blob/master/LICENSE.txt


    gui         = guidata(source);
    
    h = figure('dockcontrols','off','menubar','none',...
        'Tag','Trace browser','NumberTitle','off','name','shift annot');
    h.Position(3:4) = [200 50];
    gui.browser = h;
    
    uicontrol('Style','pushbutton',...
                'String','<--',...
                'Position',[10 10 80 30],...
                'callback',{@shiftAnnot,gui.h0,'l'});
    uicontrol('Style','pushbutton',...
                'String','-->',...
                'Position',[110 10 80 30],...
                'callback',{@shiftAnnot,gui.h0,'r'});
end

function shiftAnnot(~,~,parent,direction)
    gui = guidata(parent);
    switch direction
        case 'l'
            for f = fieldnames(gui.annot.bhv)'
                temp = gui.annot.bhv.(f{:});
                temp = [temp(2:end) false(1)];
                gui.annot.bhv.(f{:}) = temp;
            end
        case 'r'
            for f = fieldnames(gui.annot.bhv)'
                temp = gui.annot.bhv.(f{:});
                temp = [false(1) temp];
                gui.annot.bhv.(f{:}) = temp;
            end
    end
    guidata(parent,gui);
    updatePlot(parent,[]);
end