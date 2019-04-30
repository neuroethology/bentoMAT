function expt = drawexpt(gui,row,scale,nRows)
%
% (C) Ann Kennedy, 2019
% California Institute of Technology
% Licensing: https://github.com/annkennedy/bento/blob/master/LICENSE.txt



expt.panel = uipanel('parent',gui.ctrl.panel,...
        'position',[0.01 (row-.5)/(nRows+1) 0.98 scale/(nRows+1)],'bordertype','none');

temp{1} = uicontrol('parent',expt.panel,'Style','text',...
            'String','Mouse','horizontalalign','right',...
            'units','normalized','Position', [0.1 0 .125 .7]);
expt.mouse   = uicontrol('parent',expt.panel,'Style','popupmenu',...
            'String',{''},'Tag','mouse',...
            'units','normalized','Position', [.5 0.05 .1 .8],...
            'Callback',@changeExpt);
        
temp{2} = uicontrol('parent',expt.panel,'Style','text',...
            'String','Session','horizontalalign','right',...
            'units','normalized','Position', [.5 0 .125 .7]);
expt.session = uicontrol('parent',expt.panel,'Style','popupmenu',...
            'String',{''},'Tag','session',...
            'units','normalized','Position', [0.5 0.05 .1 .8],...
            'Enable','off','Callback',@changeExpt);
        
temp{3} = uicontrol('parent',expt.panel,'Style','text',...
            'String','Trial','horizontalalign','right',...
            'units','normalized','Position', [.5 0 .125 .7]);
expt.trial = uicontrol('parent',expt.panel,'Style','popupmenu',...
            'String',{''},'Tag','trial',...
            'units','normalized','Position', [0.75 0.05 .1 .8],...
            'Enable','off','Callback',@changeExpt);


align([temp{1} expt.mouse temp{2} expt.session temp{3} expt.trial],'Fixed',5,'horizontalalignment');