function gui = applyToAllMice(gui,action,varargin)

data    = gui.allData;
inds    = gui.allPopulated;

switch action
    case 'add'
        newStr = varargin{1};
    case 'delete'
        killStr = varargin{1};
    case 'merge'
        oldList = varargin{1};
        newName = varargin{2};
        toKill  = varargin{3};
    case 'rename'
        oldName = varargin{1};
        newName = varargin{2};
end

for i = 1:size(inds,1)
    m       = inds(i,1);
    sess    = ['session' num2str(inds(i,2))];
    trial   = inds(i,3);
    anno    = data(m).(sess)(trial).annot;
    
    channels = fieldnames(anno);
    for ch = 1:length(channels)
        switch action
            case 'add'
                anno.(channels{ch}).(newStr) = [];
                
            case 'delete'
                for b = 1:length(killStr)
                    anno.(channels{ch}) = rmfield(anno.(channels{ch}),killStr{b});
                end
                
            case 'merge'
                if(~isfield(anno.(channels{ch}),newName))
                    anno.(channels{ch}).(newName) = [];
                end
                newRast = []; bhvList = [newName;oldList];
                for b = 1:length(bhvList)
                    newRast = [newRast; anno.(channels{ch}).(bhvList{b})];
                    if(toKill && b>1)
                        anno.(channels{ch}) = rmfield(anno.(channels{ch}),bhvList{b});
                    end
                end
                newRast = cleanMergedRaster(newRast);
                anno.(channels{ch}).(newName) = newRast;
                
            case 'rename'
                anno.(channels{ch}).(newName) = anno.(channels{ch}).(oldName);
                anno.(channels{ch}) = rmfield(anno.(channels{ch}),oldName);
        end
    end
    data(m).(sess)(trial).annot = anno;
end

gui.allData = data;









