function pts = DLC_top(data,fr)

    fr = min(fr,size(data,2));
    inds    = [1 2 4 5 7 6 4 3 1];
    px = (1:3:21);
    py = (2:3:22);
    m1      = data([px(inds); py(inds)],fr);
    m2      = data([px(inds); py(inds)]+21,fr);

    pts = {[1 m1(:)'], [2 m2(:)']};
end