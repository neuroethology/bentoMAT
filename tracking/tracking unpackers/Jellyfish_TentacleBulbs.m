function pts = Jellyfish_TentacleBulbs(data,fr)

% npts = size(data.ctrStore{fr},1);
% pts = [(1:npts)' data.ctrStore{fr}];
npts = 16;
pts = [(1:npts)' bsxfun(@plus,squeeze(data.tracked(fr,:,:)),[326 277]) 5*ones(npts,1)];
