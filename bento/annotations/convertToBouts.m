function bouts = convertToBouts(rast)%
% (C) Ann Kennedy, 2019
% California Institute of Technology
% Licensing: https://github.com/annkennedy/bento/blob/master/LICENSE.txt



dt = rast(2:end)-rast(1:end-1);
start = find([rast(1) dt==1]);
stop  = find([dt==-1 rast(end)]);
bouts = [start' stop'];