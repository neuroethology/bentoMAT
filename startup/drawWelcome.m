function gui = drawWelcome(gui)

welcome.panel  = uipanel('position',[0 0 1 1],'bordertype','none');


uicontrol('parent',welcome.panel,'Style','text',...
            'String','Hello!','horizontalalign','center',...
            'fontsize',18,'fontname','myriad pro','fontweight','bold',...
            'units','normalized','Position', [0 .75 1 .1]);

uicontrol('parent',welcome.panel,'style','pushbutton',...
            'String','New experiment','fontsize',12,...
            'units','normalized','Position', [.35 .65 .3 .09],...
            'callback',@build_experiment);

uicontrol('parent',welcome.panel,'style','pushbutton',...
            'String','Edit experiment','fontsize',12,...
            'units','normalized','Position', [.35 .55 .3 .09],...
            'callback',{@loadExpt,'edit'});
        
uicontrol('parent',welcome.panel,'style','pushbutton',...
            'String','Load experiment','fontsize',12,...
            'units','normalized','Position', [.35 .45 .3 .09],...
            'callback',{@loadExpt,'load'});
        
% uicontrol('parent',welcome.panel,'style','pushbutton',...
%             'String','Open tracking data','fontsize',12,...
%             'units','normalized','Position', [.35 .45 .3 .09],...
%             'callback',@loadTracking);

uicontrol('parent',welcome.panel,'style','pushbutton',...
            'String','Open movie','fontsize',12,...
            'units','normalized','Position', [.35 .3 .3 .09],...
            'callback',@selectMovie);
        
gui.welcome = welcome;