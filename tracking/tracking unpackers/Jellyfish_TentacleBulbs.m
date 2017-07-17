function pts = Jellyfish_TentacleBulbs(data,fr)

npts = size(data.ctrStore{fr},1);
pts = [(1:npts)' data.ctrStore{fr}];
