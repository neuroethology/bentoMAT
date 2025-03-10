function pts = MARS(data,fr)

    if ~isfield(data,'keypoints')
        pts = {};
        return
    end
    
    fr = min(fr,size(data.keypoints,1));
    fr = max(fr,1);
    if(iscell(data.keypoints)) %support for both jsondecode and loadjson
        v       = data.keypoints{fr};
        v       = permute(reshape(v,[2 2 7]),[2 1 3]);
    else
        v       = permute(data.keypoints(fr,:,:,:),[2,3,4,1]);
    end
    
    pts={};count=0;
    for i=1:size(v,1) %loop over animals
        for k = 1:size(v,3) % loop over keypoints
            count=count+1;
            pts{count} = [count squeeze(v(i,:,k))];
        end
    end

end