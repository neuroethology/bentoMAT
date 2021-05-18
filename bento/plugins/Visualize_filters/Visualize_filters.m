function Visualize_filters(source)
%
% (C) Ann Kennedy, 2021
% California Institute of Technology
% Licensing: https://github.com/annkennedy/bento/blob/master/LICENSE.txt

% create a new figure displaying fit filters
gui = guidata(source);

h.fig = figure('Tag','Visualize Filters','name','Visualize Filters');
gui.browser = h.fig; %I'm not actually using gui.browser right now...

tracking_files = gui.data.tracking.args;
filtData = {};
for i=1:length(tracking_files)
    argfields = fieldnames(tracking_files{i});
    nAnnot = contains(argfields,'filter_names');
    [~,featFile] = fileparts(gui.data.io.feat.fid{i});
    if(sum(nAnnot)>1)
        count=0;
        for j=find(nAnnot)'
            count=count+1;
            annoName = strrep(argfields{j},'_filter_names','');
            filtData{end+1} = struct('filter_y',tracking_files{i}.([annoName '_filter_y']),...
                                 'filter_x',tracking_files{i}.filter_x,...
                                 'bias',tracking_files{i}.annot_bias(count),...
                                 'file',[featFile '_' annoName],...
                                 'names',tracking_files{i}.([annoName '_filter_names']));
        end
    elseif(sum(nAnnot)==1)
        filtData{end+1} = struct('filter_y',tracking_files{i}.filter_y,...
                                 'filter_x',tracking_files{i}.filter_x,...
                                 'bias',tracking_files{i}.annot_bias,...
                                 'file',featFile,...
                                 'names',tracking_files{i}.filter_names);
    end
end
nFilt = length(filtData);

maxSub = 1;
leg=[];
axisFlag=1;
ax=[];
for i=1:nFilt
    nSub = size(filtData{i}.names,1);
    maxSub = max([maxSub nSub]);
    for j = 1:nSub
        ax(end+1) = subplot(nFilt,nSub,nSub*(i-1)+j);hold on;
        leg(1) = plot(filtData{i}.filter_x,squeeze(filtData{i}.filter_y(j,1,:)),'r','linewidth',1.5);
        leg(2) = plot(filtData{i}.filter_x,squeeze(filtData{i}.filter_y(j,2,:)),'b','linewidth',1.5);
%         leg(3) = plot(filtData{i}.filter_x([1 end]),filtData{i}.bias*[1 1],'c','linewidth',1.5);
        title({filtData{i}.file,strtrim(filtData{i}.names(j,:)),['Bias: ' num2str(filtData{i}.bias,3)]},'interpreter','none');
        xlim(filtData{i}.filter_x([1 end]));
        if(axisFlag)
            xlabel('Frame # with respect to predicted frame')
            ylabel('Feature Weight + Bias');
            axisFlag=0;
        end
    end
end
linkaxes(ax,'y');
labels = {'resident','intruder'};%,'bias'};
legend(leg(leg~=0),labels(leg~=0),'location','best');
p=get(h.fig,'position');
p(4) = p(4)*nFilt*2/3;
p(2) = p(2) - p(4)*(nFilt*2/3 - 1);
p(3) = p(3)*maxSub/2*1.25;
p(1) = p(1) - p(3)*(maxSub/2*1.25 - 1);
set(h.fig,'position',p);
