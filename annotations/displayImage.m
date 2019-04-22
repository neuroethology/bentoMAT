function bgsmall = displayImage(bg,w,pullBg)
%
% (C) Ann Kennedy, 2019
% California Institute of Technology
% Licensing: https://github.com/annkennedy/bento/blob/master/LICENSE.txt



if(pullBg)
    neutral = get(gcf,'Color');
    bg(:,sum(bg,3)==3,:) = neutral(1);
end

if(w<length(bg))
    bgsmall = imresize(bg,[size(bg,1) w]);
else
    bgsmall = bg;
end