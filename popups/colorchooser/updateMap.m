function data = updateMap(data,Hval)

img = getHSVmap(Hval);
set(data.h.SVchooser,'cdata',img);
data.img = img;