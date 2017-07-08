function data = unpackConvexHull(data)
% extracts tracking features of interest from the output of the convex hull
% jellyfish tracker. The only mandatory feature that must be defined is a
% value for data.nframes; the remaining features, saved to data.feats, will
% be z-scored and plotted in the tracking panel.

data.nframes = length(data.hull);

data.L    = [nan nanzscore([data.hull.MajorAxisLength]) nan];
data.l    = [nan nanzscore([data.hull.MinorAxisLength]) nan];
th              = unwrap([data.hull.Orientation]*pi/180*2);
data.dAng = [nan 0 th(2:end)-th(1:end-1) nan];
data.Ctr  = [nan(2,1) nanzscore(cat(1,data.hull.Centroid))' nan(2,1)];