function CP = doCP(sig1,sig2)

dat = [sig1 sig2];
bins  = linspace(min(dat)*.9,max(dat)*1.1,500);
sigh1 = cumsum(hist(sig1,bins))/length(sig1);
sigh2 = cumsum(hist(sig2,bins))/length(sig2);

dx = sigh2(2:end)-sigh2(1:end-1);

dy = ((1-sigh1(2:end))+(1-sigh1(1:end-1)))/2;

CP = sum(dy.*dx);