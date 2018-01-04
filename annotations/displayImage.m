function bgsmall = displayImage(bg,w,pullBg)

if(pullBg)
    neutral = get(gcf,'Color');
    bg(:,sum(bg,3)==3,:) = neutral(1);
end

if(w<length(bg))
    bgsmall = imresize(bg,[size(bg,1) w]);
else
    bgsmall = bg;
end