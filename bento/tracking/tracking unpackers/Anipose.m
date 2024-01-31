function pts = Anipose(data,fr)

    fr = max(1,min(fr,size(data.data,2)));
    v  = data.data(:, fr);
    px = v(1:6:end);
    py = v(2:6:end);
    pz = v(3:6:end);
    
    pts = {};
    count=0;

    parts.head = [1 10 12 10 11 13 11 1];
    parts.arms = [2 3 4 5 9 8 7 6];
    parts.leftfoot = [14];
    parts.rightfoot = [15];

    for p = fieldnames(parts)'
        count=count+1;
        part = [px(parts.(p{:})) py(parts.(p{:})) pz(parts.(p{:}))]';
        pts{count} = [-count part(:)'];
    end
end