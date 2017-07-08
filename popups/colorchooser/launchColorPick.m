function launchColorPick(source,~)
gui  = guidata(source);
hfig = figure;clf;

cmap = gui.annot.cmap;
lbls = fieldnames(cmap);
nbeh = length(lbls);
ncol = ceil(nbeh/7);
set(hfig,'dockcontrols','off','menubar','none',...
    'NumberTitle','off','position',[250 250 300+200*ncol 350],...
    'units','normalized',...
    'WindowButtonDownFcn', {@colorPick,1},...
    'WindowButtonMotionFcn', '',...
    'WindowButtonUpFcn', {@colorPick,0},...
    'Tag','Colorwheel');


color = rgb2hsv(cmap.(lbls{1}));
X = sqrt(color(2));
Y = 1 - color(3);
X = max(min(ceil(X*300),300),1);
Y = max(min(ceil(Y*300),300),1);

h = [];
img = getHSVmap(color(1));
h.SVax = axes('position',[0.025 0.1 1.5/(ncol+1.5) .85]);
h.SVchooser = imagesc(img);
hold on;
h.cursor = plot(X,Y,'ko','linewidth',2);
set(gca,'xtick',[],'ytick',[]);

h.RGBax = axes('position',[1.5/(ncol+1.5)+.05 0.1 0.04 .85]);
hsv = cat(3, linspace(1,0,500)', ones(500,1), ones(500,1)*.95);
rgbImage = hsv2rgb(hsv);
imagesc(rgbImage);
hold on;
h.Hchooser = plot(get(gca,'xlim'),(1-color(1))*[500 500],'k');
set(gca,'xtick',[],'ytick',[])


bhvPanel = uibuttongroup('position',[1.5/(ncol+1.5)+.12 0 ncol/(ncol+1.5)-.12 1],'bordertype','none');
nrows = ceil(nbeh/ncol);

bump = .85;cbump = 0;
for i = 1:length(lbls)
    if(bump<.2)
        bump = .85; cbump = cbump + 1/ncol;
    end
    h.bhvrs(i) = uicontrol(bhvPanel,'Style','togglebutton',...
            'Value',i==1,...
            'units','normalized',...
            'Position',[cbump bump .2/ncol .08],...
            'backgroundcolor',cmap.(lbls{i}),'callback',@cPickHighlight);
    h.lbls(i) = uicontrol(bhvPanel,'Style','text',...
            'String',strrep(lbls{i},'_',' '),...
            'HorizontalAlignment','left',...
            'units','normalized',...
            'Position',[.22/ncol+cbump bump-.01 .7/ncol .08]);
    bump = bump - .1;
end
set(h.lbls(1),'fontweight','bold');


uicontrol('Style','pushbutton','units','normalized',...
          'Position',[(1.5+ncol/1.5)/(ncol+1.75) 0.05 0.15 0.1],...
          'String','Save',...
          'Tag','Colorwheel',...
          'Callback',{@applyColor,source});
      
subDat = [];
subDat.h = h;
subDat.cmap = cmap;
subDat.img = img;
subDat.active = 1;
subDat.h0 = hfig;
guidata(hfig,subDat);