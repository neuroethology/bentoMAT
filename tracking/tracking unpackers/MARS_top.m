function pts = MARS_top(data,fr)

    inds    = [1 2 4 5 7 6 4 3 1];
    if(iscell(data.keypoints)) %support for both jsondecode and loadjson
        v       = data.keypoints{fr};
        v       = permute(reshape(v,[2 2 7]),[2 1 3]);
    else
        v       = squeeze(data.keypoints(fr,:,:,:));
    end
    m1      = squeeze(v(1,:,inds));
    m2      = squeeze(v(2,:,inds));

    pts = [1 m1(:)'; 2 m2(:)'];
end