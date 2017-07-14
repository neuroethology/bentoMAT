function mov = Jellyfish_TentacleBulbs(mov,fr,data)

pts = data.ctrStore{fr};
mov = insertMarker(mov,pts,'s','color','red','size',4);