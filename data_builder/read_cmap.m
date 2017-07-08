function cmap_M = read_cmap(cmap,bhvr)

cmap_M = [];
for i = 1:length(bhvr)
    if(isfield(cmap,bhvr{i}))
        cmap_M(i,:) = cmap.(bhvr{i});
    else
        warning(['no color found for ' bhvr{i} '; picking one at random.']);
        cmap_M(i,:) = distinguishable_colors(1,[0 0 0;1 1 1;cmap_M(1:i-1,:)]);
    end
end