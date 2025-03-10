function pts = MARS_bbox_only(data,fr)

    fr = min(fr,size(data.bbox,1));
    
    if(iscell(data.bbox)) %support for both jsondecode and loadjson
        b       = data.bbox{fr};
    else
        b       = permute(data.bbox(fr,:,:),[2,3,1]);
    end
    
    pts = {[]};
    for i = 1:size(b,1)
        bx     = [b(i,[1 3 3 1 1]); b(i,[2 2 4 4 2])];
        pts{1} = [pts{1} [i bx(:)']];
    end
    
    if(isfield(data,'crop_bounds') && ~isempty(data.crop_bounds)) % support for multi-arena MARS
        bounds = data.crop_bounds;
        if((bounds(2,1)-bounds(1,1)) < (bounds(2,2)-bounds(1,2)))
            for i=1:length(pts)
                temp = pts{i};
                pts{i}(2:2:end) = temp(3:2:end);
                pts{i}(3:2:end) = temp(2:2:end);
            end
        end
        for i=1:length(pts)
            pts{i}(2:2:end) = pts{i}(2:2:end)+double(bounds(1,1));
            pts{i}(3:2:end) = pts{i}(3:2:end)+double(bounds(1,2));
        end
    end
    
end