function pts = JAX(data,fr)

    fr = min(fr,size(data.points,4));
    nMice = size(data.points,3);
    order = [1 2 4 3 1 3 4 7 10 11 12 13 5 6 9 10 8 5];

    for j = 1:nMice
        m1 = double([flipud(squeeze(data.points(:,:,j,fr))) [0;0]]);
        m1(m1==0) = nan;
        m1 = m1(:,order);
        pts{j} = [double(data.ids(j,fr))+1 m1(:)'];
    end
end