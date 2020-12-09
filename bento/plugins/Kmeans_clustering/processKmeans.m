function processKmeans(source,~,gui,m,sess,trList,bhvList)
%
% (C) Ann Kennedy, 2019
% California Institute of Technology
% Licensing: https://github.com/annkennedy/bento/blob/master/LICENSE.txt

h=guidata(source);
set(h.go,'backgroundcolor',[.7 .7 .7],'String','Clustering...');drawnow;
K=cellstr(h.K.String);
K = str2double(K{h.K.Value});

bhv     = bhvList(h.bhv.Value);
ch      = h.ch.String(h.ch.Value);
trials  = trList(h.trials.Value);

% make sure we're up to date:
gui = guidata(gui.h0);
% assemble trials:
rast = [gui.allData(m).(sess)(trials).rast];

% get subframes if requested:
if(h.subset.Value)
    mask = [];
    for tr = trials'
        data    = gui.allData(m).(sess)(tr);
        mtemp = false(1,length(data.annoTime));
        for f = bhv'
            if(~strcmpi(f{:},'no label') && isfield(data.annot.(ch{:}),f{:}))
                mtemp = mtemp|convertToRast(data.annot.(ch{:}).(f{:}),length(data.annoTime));
            else
                mtemp2 = false(size(mtemp));
                for f2 = setdiff(bhvList','no label')
                    mtemp2 = mtemp2|convertToRast(data.annot.(ch{:}).(f2{:}),length(data.annoTime));
                end
                mtemp = mtemp|~mtemp2;
            end
        end
        mask = [mask mtemp];
    end
    mask = imresize(mask,[1 length(rast)])>0.5;
    rast = rast(:,mask);
end

% zscore if requested:
if(h.zscore.Value)
    rast = zscore(rast')';
end

% actually do the clustering:
[idx,~] = kmeans(rast,K,'replicates',10);

% display some goodness-of-fit stuff:
axes(h.sPlot);cla;
silhouette(rast,idx);
if(~strcmpi(get(h.output,'Visible'),'on'))
    set(h.output,'Visible','on');
    p = get(h.fig,'Position');
    p(3) = p(3)+500;
    set(h.fig,'Position',p);
end
if(strcmpi(get(h.ctrls2,'Visible'),'on'))
    set(h.ctrls,'Position',[0 0 280/980 1]);
    set(h.ctrls2,'Position',[280/980 0 200/980 1]);
    set(h.output,'Position',[480/980 0 500/980 1]);
else
    set(h.ctrls,'Position',[0 0 280/780 1]);
    set(h.output,'Position',[280/780 0 500/780 1]);
end
set(h.go,'backgroundcolor',[.65 1 .65],'String','Go!');drawnow;


gui.traces.order = idx + (1:length(idx))'/(length(idx)+1); % fractional values preserve original ordering
guidata(gui.h0,gui);
updatePlot(gui.h0,[]);

