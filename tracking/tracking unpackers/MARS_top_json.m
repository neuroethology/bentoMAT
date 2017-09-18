function pts = MARS_top_json(data,fr)

inds    = [1 2 4 5 7 6 4 3 1];
m1      = data.keypoints{fr}{1};
m2      = data.keypoints{fr}{2};

m1      = [[m1{1}{:}]; [m1{2}{:}]];
m2      = [[m2{1}{:}]; [m2{2}{:}]];

m1      = squeeze(m1(:,inds));
m2      = squeeze(m2(:,inds));

pts = [1 m1(:)'; 2 m2(:)'];
