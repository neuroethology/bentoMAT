function make_behavior_raster_summary(annot,cmapDef,maxTime,h,tstr)

FR = 390.625;
annot  = rmBlankChannels(annot);

if(~exist('tstr','var'))
    tstr = '';
end

if(exist('h','var'))
    figure(h);
else
    h = gcf;
end
h.Position(3:4) = [1200 250];
subplot(6,5,[6:9 11:14 16:19 21:24]);
hold on;

channels = fieldnames(annot);
bhvrs = {};
for c = 1:length(channels)
    for f = fieldnames(annot.(channels{c}))'
        if(~isempty(annot.(channels{c}).(f{:})) & ~strcmpi(f{:},'other'))
            bhvrs(end+1) = f;
        end
    end
end
correctedLabels = findEquivalentLabels(bhvrs);
B = length(bhvrs);

for i=1:length(channels)
    patchify(annot.(channels{i}),[0 1]+i,1/FR/60,cmapDef);
end
axis tight;
xlim([0 maxTime/FR/60]);
p1 = get(gca,'ylim');
p2 = get(gca,'xlim');

for b=1:B
    patch(p2(2)*[1.05 1.25 1.25 1.05],(B-[b-1 b-1 b b])/B*(p1(2)-p1(1))+p1(1),cmapDef.(correctedLabels{b}));
    if(mean(cmapDef.(correctedLabels{b}))<.5) cUse = 'w'; else cUse = 'k'; end
    text(p2(2)*1.0625, (B-b+.5)/B*(p1(2)-p1(1))+p1(1),strrep(correctedLabels{b},'_',' '),'color',cUse);
end
xlim([0 p2(2)*1.25]);
title(tstr,'interpreter','none');
set(gca,'ytick',[]);
xlabel('time (minutes)');
box off;

for i = 1:length(channels)
    subplot(length(channels),5,5*i);hold on;
    hit = zeros(1,B);
    cmap = [];
    for b = 1:B
        hit(b)      = mean(convertToRast(annot.(channels{i}).(bhvrs{b}),maxTime));
        if(hit(b))
            cmap(end+1,:)   = cmapDef.(correctedLabels{b});
        end
    end
    cmap(end+1,:) = [.9 .9 .9];
    hit = hit(hit~=0);
    h = pie([hit 1-sum(hit)]);
    for f = 1:2:length(h)
        h(f).FaceVertexCData = ones(length(h(f).FaceVertexCData),1)*cmap((f+1)/2,:);
    end
    axis equal; axis off;
end
