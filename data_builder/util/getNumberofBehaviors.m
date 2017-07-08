function [count,keep] = getNumberofBehaviors(bhvr)

beh = fieldnames(bhvr);
hits = zeros(length(bhvr),length(beh));
keep = {};
for i = 1:length(bhvr)
    for f = 1:length(beh)
        if(~isempty(bhvr(i).(beh{f})))
            keep{end+1} = beh{f};
        end
    end
end
keep = unique(keep);
count = length(keep);