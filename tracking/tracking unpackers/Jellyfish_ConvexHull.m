function data = Jellyfish_ConvexHull(data)
% extracts tracking features of interest from the output of the convex hull
% jellyfish tracker.

data.nframes = length(data.hull);

data.L    = [nan nanzscore([data.hull.MajorAxisLength]) nan];
data.l    = [nan nanzscore([data.hull.MinorAxisLength]) nan];
th              = unwrap([data.hull.Orientation]*pi/180*2);
data.dAng = [nan 0 th(2:end)-th(1:end-1) nan];
data.Ctr  = [nan(2,1) nanzscore(cat(1,data.hull.Centroid))' nan(2,1)];