function bhvpic = makeBhvPic(data,labels)

bhvpic = [];
for b = 1:length(labels)
    for ep = 1:size(data.(labels{b}),1)
        tStart = data.(labels{b})(ep,1);
        tEnd   = data.(labels{b})(ep,2);
        bhvpic(tStart:tEnd) = b;
    end
end
bhvpic(bhvpic==0) = find(strcmp(labels,'other'));