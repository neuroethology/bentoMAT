function pts = SLEAP(data,fr)

    fr = min(fr,size(data.tracks,1));
    v       = squeeze(data.tracks(fr,:,:,:));
    
    pts = {};
    for track = 1:size(v,3)
        m1      = squeeze(v(:,:,track));
        if all(isnan(m1(:)))
            continue
        elseif sum(~isnan(m1(:,1)))==1
            pts = [pts {[track m1(:)']}];
            continue
        end 

        for e = 1:size(data.edges,2)
            temp = m1(data.edges(:,e),:)';
            pts = [pts {[track temp(:)']}];
        end
    end
    
end