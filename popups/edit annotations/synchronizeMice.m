function gui = synchronizeMice(gui,bhvList)

data    = gui.allData;
inds    = gui.allPopulated;

for i = 1:size(inds,1)
    m       = inds(i,1);
    sess    = ['session' num2str(inds(i,2))];
    trial   = inds(i,3);
    anno    = data(m).(sess)(trial).annot;
    
    for b = 1:length(bhvList)
        if(~isfield(anno,bhvList{b}))
            anno.(bhvList{b})=[];
        end
    end
    data(m).(sess)(trial).annot = anno;
end

gui.allData = data;