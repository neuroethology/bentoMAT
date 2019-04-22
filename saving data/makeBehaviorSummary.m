function [M,channelSummary] = makeBehaviorSummary(channel,tmin,tmax,FR)
%
% (C) Ann Kennedy, 2019
% California Institute of Technology
% Licensing: https://github.com/annkennedy/bento/blob/master/LICENSE.txt



M = {};
channelSummary = {};
count=0;
fields = fieldnames(channel);
fields(strcmpi(fields,'other')) = [];
for f = 1:length(fields)
    if(~isempty(channel.(fields{f}))&&(size(channel.(fields{f}),2)==2))
        count=count+1;
        M{1,count*3-2} = fields{f};
        M(2,(count-1)*3+(1:3)) = {'Start','Stop','Duration'};

        M(2+(1:size(channel.(fields{f}),1)),count*3-[2 1]) = num2cell(channel.(fields{f}));
        delta = channel.(fields{f})(:,2) - channel.(fields{f})(:,1) + 1;
        M(2+(1:size(channel.(fields{f}),1)),count*3) = num2cell(delta);
        
        channelSummary{count,1} = fields{f};
        channelSummary{count,3} = (sum(delta))/(tmax-tmin+1)*100;
        channelSummary{count,4} = length(delta);
        channelSummary{count,5} = mean(delta);
        channelSummary{count,6} = channel.(fields{f})(1,1);
    end
end