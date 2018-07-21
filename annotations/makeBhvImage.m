function img = makeBhvImage(bhv,cmap,inds,tmax,showAnnot)

bhvList = fieldnames(bhv);

if(~isempty(inds))
    L = length(inds);
    mask            = (inds<1)|(inds>tmax);
    inds(inds<1)    = 1;
    inds(inds>tmax) = tmax;
else
    L = tmax;
end
img = ones(1,L,3);
for i = 1:length(bhvList)
    if((isempty(showAnnot) || showAnnot.(bhvList{i})) && ~isempty(bhv.(bhvList{i})) && ~strcmpi(bhvList{i},'other'))
        if(min(size(bhv.(bhvList{i})))==2 || length(bhv.(bhvList{i}))==2)
            if(~isempty(inds))
                use = bhv.(bhvList{i});
                use(use(:,2)<inds(1),:) = [];
                use(use(:,1)>inds(end),:) = [];
                use = use - inds(1);
                hits = convertToRast(use,L);
            else
                hits = convertToRast(bhv.(bhvList{i}),tmax);
            end
        else
            if(~isempty(inds))
                hits = bhv.(bhvList{i})(inds);
            else
                hits = bhv.(bhvList{i});
            end
        end
        img(1,hits~=0,:)    = ones(sum(hits),1)*cmap.(bhvList{i});
    end
end

if(~isempty(inds)) %crop image for traces/tracker browsers
    img             = img(1,inds,:);
    img(1,mask,:)   = permute(ones(sum(mask),3),[3 1 2]);
end