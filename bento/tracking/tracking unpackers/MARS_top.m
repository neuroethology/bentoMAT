function pts = MARS_top(data,fr)

    fr = min(fr,size(data.keypoints,1));
    fr = max(fr,1);
    inds    = [1 2 4 5 7 6 4 3 1];
    if(iscell(data.keypoints)) %support for both jsondecode and loadjson
        v       = data.keypoints{fr};
        v       = permute(reshape(v,[2 2 7]),[2 1 3]);
    else
        try
        v       = squeeze(data.keypoints(fr,:,:,:));
        catch
            keyboard
        end
    end
    m1      = squeeze(v(1,:,inds));
    m2      = squeeze(v(2,:,inds));

    pts = {[1 m1(:)'] [2 m2(:)']};
    
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