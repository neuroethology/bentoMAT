function addLabelLegend(p,annot,specs)

tmin = round(specs.startTime*specs.FR);
tmax = round(specs.endTime*specs.FR)-1;

keep = {};
for f = fieldnames(annot.show)'
    if(~annot.show.(f{:}))
        continue;
    end
    if(~any(annot.bhv.(f{:})(tmin:tmax)))
        continue;
    end
    keep{end+1} = f{:};
end

nRows = ceil(length(keep)/5);
nCols = ceil(length(keep)/nRows);

for i = 1:length(keep)
    boxes(i) = uipanel(p,'bordertype','none','BackgroundColor',specs.color,...
                       'units','normalized','position',[mod(i-1,nCols)/nCols 1-ceil((i)/nCols)/nRows 1/nCols 1/nRows]);
    uipanel(boxes(i),'bordertype','none','BackgroundColor',annot.cmap.(keep{i}),'units','normalized',...
            'position',[.1 .05 .25 .9]);
    uicontrol(boxes(i),'style','text','units','normalized','backgroundcolor',specs.color,...
            'fontsize',11,'horizontalalign','left',...
            'position',[.4 .2 .6 .6],'string',strrep(keep{i},'_',' '));
end
