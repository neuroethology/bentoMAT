function CP = doCP(sig1,sig2)
%
% (C) Ann Kennedy, 2019
% California Institute of Technology
% Licensing: https://github.com/annkennedy/bento/blob/master/LICENSE.txt


dat = [sig1 sig2];
bins  = linspace(min(dat) - .05*range(dat),max(dat)+.05*range(dat),500);
sigh1 = cumsum(hist(sig1,bins))/length(sig1);
sigh2 = cumsum(hist(sig2,bins))/length(sig2);

dx = sigh2(2:end)-sigh2(1:end-1);
dy = ((1-sigh1(2:end))+(1-sigh1(1:end-1)))/2;


CP = sum(dy.*dx);