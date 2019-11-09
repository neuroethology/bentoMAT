function bhvpic = makeBhvPic(data,labels,tmax)
%
% (C) Ann Kennedy, 2019
% California Institute of Technology
% Licensing: https://github.com/annkennedy/bento/blob/master/LICENSE.txt



bhvpic = zeros(1,tmax);
for b = 1:length(labels)
    if(~isfield(data,labels{b})), continue; end
    for ep = 1:size(data.(labels{b}),1)
        tStart = data.(labels{b})(ep,1);
        tEnd   = data.(labels{b})(ep,2);
        bhvpic(tStart:tEnd) = b;
    end
end
if(any(strcmpi(labels,'other')))
    bhvpic(bhvpic==0) = find(strcmp(labels,'other'));
end