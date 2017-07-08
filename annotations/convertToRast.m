function rast = convertToRast(bhvr,tmax)

time = 1:tmax;
rast = false(size(time));
for i = 1:size(bhvr,1)
    inds = (time>=bhvr(i,1))&(time<=bhvr(i,2));
    rast(inds)=true;
end