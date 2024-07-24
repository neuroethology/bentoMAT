function pts = jax_simple(data,fr)

    fr = min(fr,size(data.keypoints,1));

	inds = [0 3 1 0 2 3 6 9 7 4 5 8 9]+1;
    if(iscell(data.keypoints)) %support for both jsondecode and loadjson
        v       = data.keypoints{fr};
        v       = permute(reshape(v,[2 2 7]),[2 1 3]);
    else
        v       = squeeze(data.keypoints(fr,:,:,:));
    end
	v = double(permute(v,[1 3 2]))*0.875;

    v(v==0)=nan;
    m1      = squeeze(v(1,:,inds));
    m2      = squeeze(v(2,:,inds));
	m3      = squeeze(v(3,:,inds));
    
    m1=flipud(m1);
    m2=flipud(m2);
    m3=flipud(m3);

    pts = {[1 m1(:)'] [2 m2(:)'] [3 m3(:)']};

end