function addLabelLegend(p,annot,specs)

tmin = max(round(specs.startTime*specs.FR),1);
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
            'position',[.1 .2 .15 .6]);
    uicontrol(boxes(i),'style','text','units','normalized','backgroundcolor',specs.color,...
            'fontsize',10,'horizontalalign','left','position',[.3 .2 .7 .6],'string',strrep(keep{i},'_',' '));
end
