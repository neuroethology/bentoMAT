function pts = DLC(data,fr)

    fr = min(fr,size(data,2));
    nPoints = size(data,1)-1;
    px = (1:3:nPoints);
    py = (2:3:nPoints);
    for i = 2:3:nPoints
        m1      = data([i; i+1],fr);
        pts{(i-2)/3+1} = [(i-2)/3+1 m1(:)'];
    end
end