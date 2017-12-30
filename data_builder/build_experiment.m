function gui = build_experiment(source,~)

guiParent = guidata(source);
clear gui;
pth = pwd;

fillin = {'units','normalized','fontsize',11};
f = figure(999);clf;
gui.f = f;
set(f,'units','pixels','dockcontrols','off','menubar','none','NumberTitle','off',...
    'position',[100 200 1100 550],'ResizeFcn',@redrawBuilder);
uicontrol('style','text',fillin{:},'position',[0 .925 1 .05],...
          'string','Experiment manager','fontweight','bold');

cnames          = {'Mouse','Sessn','Stim','Linked Data'};
colSizes        = ones(1,8);
gui.t       = uitable('parent',f,fillin{:},'position',[.01 .4 .63 .525],...
                        'columnname',cnames,'rowname','',...
                'columneditable',[true(1,3) false(1,3)],'columnwidth',mat2cell(colSizes,1,ones(1,length(colSizes))),...
                'CellSelectionCallback',@tableCallback);
gui.pth = pwd;
gui.mouse.session1.io=struct();
clear dat;
dat{1,1}    = '1';
dat{1,2}    = '1';
dat{1,5} = ['  ' char(9998)];
dat{1,6} = ['  ' char(10549)];
dat{1,7} = ['  '  char(10007)];

set(gui.t,'data',dat);

gui.buttons   = uipanel('parent',f,fillin{:},'position',...
                    [.65 .45 .34 .475],'bordertype','none');
gui.preview   = uicontrol('parent',f,fillin{:},'position',...
                    [.015 .025 .3 .35],'style','edit','backgroundColor',[.93 .93 .93],...
                    'string','','horizontalalign','left',...
                    'max',2,'min',0,'callback',@setPreviewString);
prevPnl       = uipanel('parent',f,fillin{:},'position',...
                    [.325 .025 .66 .35]);
gui.prevImg   = axes('parent',prevPnl,'position',[.01 .01 .98 .98]);
imagesc(rand(5,10),'parent',gui.prevImg);
axis off;
               
gui.next      = uicontrol('parent',gui.buttons,fillin{:},'style','pushbutton','position',[.25,.6,.5,.25],...
                    'string','Start import','backgroundcolor',[.65 1 .65],'callback',{@processTable,guiParent});
exptGui.save      = uicontrol('parent',gui.buttons,fillin{:},'style','pushbutton','position',[.25,.4,.5,.15],...
                    'string','Save info','callback',@saveTable_new);
exptGui.load      = uicontrol('parent',gui.buttons,fillin{:},'style','pushbutton','position',[.25,.225,.5,.15],...
                    'string','Load info','callback',@loadTable_new); 
guidata(f,gui);

redrawBuilder(f,[]);