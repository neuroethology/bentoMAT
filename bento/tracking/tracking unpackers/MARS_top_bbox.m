function pts = MARS_top_bbox(data,fr)

    fr = min(fr,size(data.keypoints,1));
    inds    = [1 2 4 5 7 6 4 3 1];
    binds   = [1 2 1 4 3 4 3 2 1 2];
    if(iscell(data.keypoints)) %support for both jsondecode and loadjson
        v       = data.keypoints{fr};
        v       = permute(reshape(v,[2 2 7]),[2 1 3]);
        b       = data.bbox{fr};
    else
        v       = squeeze(data.keypoints(fr,:,:,:));
        b       = squeeze(data.bbox(fr,:,:));
    end
    m1      = squeeze(v(1,:,inds));
    m2      = squeeze(v(2,:,inds));
    m1nose  = squeeze(v(1,:,1));
    m2nose  = squeeze(v(2,:,1));
    b1      = b(1,binds);
    b2      = b(2,binds);

    pts.pts   = {[1 m1(:)'], [2 m2(:)'], [3 m1nose], [4 m2nose], [5 b1(:)'], [6 b2(:)']};
    pts.color = [0 1 0; 0 0 1; 1 0 0; 1 0 0; 1 1 .75; 1 1 .75]*256;
end