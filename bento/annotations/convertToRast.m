function rast = convertToRast(bhvr,tmax)
%
% (C) Ann Kennedy, 2019
% California Institute of Technology
% Licensing: https://github.com/annkennedy/bento/blob/master/LICENSE.txt



time = 1:tmax;
rast = false(size(time));
for i = 1:size(bhvr,1)
    inds = (time>=bhvr(i,1))&(time<=bhvr(i,2))&(time<=tmax);
    rast(inds)=true;
end