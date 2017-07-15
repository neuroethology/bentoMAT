function newRast = cleanMergedRaster(rast)

if(isempty(rast))
    newRast = rast;
    return;
end

rast    = sortrows(rast,1);
rtemp   = convertToRast(rast,max(rast(:))+100);
rtemp   = [rtemp(1)  rtemp(2:end-1)-rtemp(1:end-2) -rtemp(end)];
tOn     = find(rtemp==1);
tOff    = find(rtemp==-1);

if(~isempty(tOn)&&~isempty(tOff))
    newRast = [tOn' tOff'-1];
else
    newRast = [];
end
