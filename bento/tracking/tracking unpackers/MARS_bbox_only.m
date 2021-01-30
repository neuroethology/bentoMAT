function pts = MARS_bbox_only(data,fr)

    fr = min(fr,size(data.bbox,1));
    
    if(iscell(data.bbox)) %support for both jsondecode and loadjson
        b       = data.bbox{fr};
    else
        b       = squeeze(data.bbox(:,:,fr));
    end
    b1      = [b(1,[1 3 3 1 1]); b(1,[2 2 4 4 2])];
    b2      = [b(2,[1 3 3 1 1]); b(2,[2 2 4 4 2])];

    pts = {[1 b1(:)'] [2 b2(:)']};
    
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