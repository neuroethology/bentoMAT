function gui = applyToAllMice(gui,action,varargin)

data    = gui.allData;
inds    = gui.allPopulated;

switch action
    case 'add'
        newStr = varargin{1};
    case 'delete'
        toKill = varargin{1};
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
                for b = 1:length(toKill)
                    anno.(channels{ch}) = rmfield(anno.(channels{ch}),toKill{b});
                end
                
            case 'merge'
                newRast = [];
                for b = 1:length(oldList)
                    newRast = [newRast; anno.(channels{ch}).(oldList{b})];
                    if(toKill)
                        anno.(channels{ch}) = rmfield(anno.(channels{ch}),oldList{b});
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









