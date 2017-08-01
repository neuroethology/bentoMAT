function pts = MARS_top(data,fr)

inds    = [1 2 4 5 7 6 4 3 1];
v       = squeeze(data.keypoints(fr,:,:,:));
m1      = squeeze(v(1,:,inds));
m2      = squeeze(v(2,:,inds));

pts = [1 m1(:)'; 2 m2(:)'];
