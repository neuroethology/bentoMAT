function pts = MARS_ASAP(data,fr)

    fr = min(fr,size(data.keypoints,1));
    if(iscell(data.keypoints)) %support for both jsondecode and loadjson
        v       = data.keypoints{fr};
        v       = permute(reshape(v,[2 2 7]),[2 1 3]);
        b       = data.bbox{fr};
    else
        v       = permute(data.keypoints(fr,:,:,:),[2,3,4,1]);
        b       = permute(data.bbox(fr,:,:),[2,3,1]);
    end
    
    pts = {};
    count=0;
%     for i = 1:size(b,1)
%         bx     = [b(i,[1 3 3 1 1]); b(i,[2 2 4 4 2])];
%         pts{i} = [i bx(:)'];
%     end
%     count=size(b,1);

    parts.body = [2 6 8 7 2];
    parts.midline = [1 2 3 8 9 10];
    parts.head = [1 4 2 5 1];
    parts.paw1 = [11 12 14 13 11];
    parts.paw2 = [15 16 18 17 15];
    parts.paw3 = [19 20 22 21 19];
    parts.paw4 = [23 24 26 25 23];

    for p = fieldnames(parts)'
        count=count+1;
        part = squeeze(v(1,:,parts.(p{:})));
        pts{count} = [count part(:)'];
    end
end