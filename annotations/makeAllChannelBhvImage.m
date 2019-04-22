function img = makeAllChannelBhvImage(gui,data,cmap,inds,tmax,showAnnot)
%
% (C) Ann Kennedy, 2019
% California Institute of Technology
% Licensing: https://github.com/annkennedy/bento/blob/master/LICENSE.txt



chList = fieldnames(data);

if(~isempty(inds))
    L = length(inds);
    mask            = (inds<1)|(inds>tmax);
    inds(inds<1)    = 1;
    inds(inds>tmax) = tmax;
else
    L = tmax;
end
img = ones(length(chList),L,3);
for ch = 1:length(chList)
    
    bhvList = fieldnames(data.(chList{ch}));
    
    for i = 1:length(bhvList)
        show = (~isfield(showAnnot,bhvList{i})) || (isfield(showAnnot,bhvList{i}) && showAnnot.(bhvList{i}));
        if(show && ~strcmpi(bhvList{i},'other'))
            
            if(strcmpi(chList{ch},gui.annot.activeCh))
                hits = gui.annot.bhv.(bhvList{i})(inds);
                img(ch,hits~=0,:)   = ones(sum(hits),1)*cmap.(bhvList{i});
            elseif(~isempty(data.(chList{ch}).(bhvList{i})))
                use = data.(chList{ch}).(bhvList{i});
                if(~isempty(inds))
                    use(use(:,2)<inds(1),:) = [];
                    use(use(:,1)>inds(end),:) = [];
                    use = use - inds(1);
                end
                if(~isempty(use))
                    hits                = convertToRast(use,L);
                    img(ch,hits~=0,:)   = ones(sum(hits),1)*cmap.(bhvList{i});
                end
            end
        end
    end
    
end

if(~isempty(inds))
    img(:,mask,:)   = permute(ones(sum(mask),3),[3 1 2]);
    img = flip(img,1);
end
