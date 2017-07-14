function mov = Jellyfish_TentacleBulbs(mov,fr,active,data)

npts = size(data.ctrStore{fr},1);
active(active>npts) = [];

pts = data.ctrStore{fr}(active,:);
mov = insertShape(mov,'circle',[pts 5*ones(size(pts,1),1)],'linewidth',4,'color','red');

pts = data.ctrStore{fr}(setdiff(1:npts,active),:);
mov = insertShape(mov,'circle',[pts 5*ones(size(pts,1),1)],'linewidth',4,'color','blue');