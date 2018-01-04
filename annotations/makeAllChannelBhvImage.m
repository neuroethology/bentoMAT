function img = makeAllChannelBhvImage(gui,annot,cmap,inds,tmax,showAnnot)

chList = fieldnames(annot);

img = ones(length(chList),tmax,3);
for ch = 1:length(chList)
    
    bhvList = fieldnames(annot.(chList{ch}));
    
    for i = 1:length(bhvList)
        show = (~isfield(showAnnot,bhvList{i})) || (isfield(showAnnot,bhvList{i}) && showAnnot.(bhvList{i}));
        if(show && ~isempty(annot.(chList{ch}).(bhvList{i})) && ~strcmpi(bhvList{i},'other'))
            
            if(strcmpi(chList{ch},gui.annot.activeCh))
                hits = gui.annot.bhv.(bhvList{i});
                img(ch,hits~=0,:)   = ones(sum(hits),1)*cmap.(bhvList{i});
            else
                use = annot.(chList{ch}).(bhvList{i});
                if(~isempty(inds))
                    use(use(:,2)<inds(1),:) = [];
                    use(use(:,1)>inds(end),:) = [];
                end
                if(~isempty(use))
                    hits                = convertToRast(use,tmax);
                    img(ch,hits~=0,:)   = ones(sum(hits),1)*cmap.(bhvList{i});
                end
            end
        end
    end
    
end

mask                    = (inds<1)|(inds>length(img));
inds(inds<1)            = 1;
inds(inds>length(img))  = length(img);

img             = img(:,inds,:);
img(:,mask,:)   = permute(ones(sum(mask),3),[3 1 2]);
img = flip(img,1);
