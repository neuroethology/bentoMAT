function patchify(img,xran,yran,colors)

dt = (xran(2)-xran(1))/length(img);
for iq = 1:max(img)
    sig = (img==iq);

    t_begin = find(diff([0 sig])==1);
    t_end = find(diff([sig 0])==-1);

    for k = 1:length(t_begin),
        tb = t_begin(k)-1;
        te = t_end(k);
        patch([tb te te tb]*dt+xran(1),[yran(1) yran(1) yran(2) yran(2)],...
            colors(iq,:),'EdgeColor','none');
    end;
end