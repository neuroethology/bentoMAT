function bgsmall = displayImage(bg,w,pullBg)

if(pullBg)
    neutral = get(gcf,'Color');
    bg(:,sum(bg,3)==3,:) = neutral(1);
end

if(w<length(bg))
    bgsmall = imresize(bg,w/length(bg));
else
    bgsmall = bg;
end