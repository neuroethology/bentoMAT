function pts = MARS_top_simple(data,fr)

inds    = [1 4 7];
v       = squeeze(data.keypoints(fr,:,:,:));
m1      = squeeze(v(1,:,inds));
m2      = squeeze(v(2,:,inds));

pts = [1 m1(:)'; 2 m2(:)'];
