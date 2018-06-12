function img = makeBhvImage(bhv,cmap,inds,tmax,showAnnot)

bhvList = fieldnames(bhv);

img = ones(1,tmax,3)*.95;
for i = 1:length(bhvList)
    if((isempty(showAnnot) || showAnnot.(bhvList{i})) && ~isempty(bhv.(bhvList{i})) && ~strcmpi(bhvList{i},'other'))
        if(min(size(bhv.(bhvList{i})))==2 || length(bhv.(bhvList{i}))==2)
            hits = convertToRast(bhv.(bhvList{i}),tmax);
        else
            hits                = bhv.(bhvList{i});
        end
        img(1,hits~=0,:)    = ones(sum(hits),1)*cmap.(bhvList{i});
    end
end

if(~isempty(inds)) %crop image for traces/tracker browsers
    mask                    = (inds<1)|(inds>length(img));
    inds(inds<1)            = 1;
    inds(inds>length(img))  = length(img);
    
    img             = img(1,inds,:);
    img(1,mask,:)   = permute(ones(sum(mask),3),[3 1 2]);
end