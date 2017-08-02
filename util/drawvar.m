function h2=drawvar(X,Y,color,nstd,varargin)
%X,Y,color,nstd,[variance if computed externally]
if(isempty(varargin))
    h=area(X,[nanmean(Y,1)-nanstd(Y,1)*nstd; nanstd(Y,1)*nstd; nanstd(Y,1)*nstd]');
else
    h=area(X,[Y - varargin{1}*nstd; varargin{1}*nstd; varargin{1}*nstd]'); %lets you pass variance
end
    
    set(h,'FaceColor','none')
    set(h,'LineStyle','none')

    switch color
        case 'r'
            set(h([2 3]),'FaceColor',[1 .5 .5]);
            set(get(h(2),'children'),'facealpha',0.5)
            set(get(h(3),'children'),'facealpha',0.5)
        case 'b'
            set(h([2 3]),'FaceColor',[.5 .6 1]);
            set(get(h(2),'children'),'facealpha',0.5)
            set(get(h(3),'children'),'facealpha',0.5)
        case 'g'
            set(h([2 3]),'FaceColor',[.5 1 .5]);
            set(get(h(2),'children'),'facealpha',0.5)
            set(get(h(3),'children'),'facealpha',0.5)
        case 'c'
            set(h([2 3]),'FaceColor',[.5 1 1]);
            set(get(h(2),'children'),'facealpha',0.5)
            set(get(h(3),'children'),'facealpha',0.5)
        case 'm'
            set(h([2 3]),'FaceColor',[1 .5 .6]);
            set(get(h(2),'children'),'facealpha',0.5)
            set(get(h(3),'children'),'facealpha',0.5)
        case 'y'
            set(h([2 3]),'FaceColor',[1 1 .5]);
            set(get(h(2),'children'),'facealpha',0.5)
            set(get(h(3),'children'),'facealpha',0.5)
        case 'k'
            set(h([2 3]),'FaceColor',[.5 .5 .5]);
            set(get(h(2),'children'),'facealpha',0.5)
            set(get(h(3),'children'),'facealpha',0.5)
    end
    
    %now add the average overtop:
    hold on;
    h2=plot(X,nanmean(Y,1),color,'linewidth',1);
%     plot(X,mean(Y,1)/max(abs(mean(Y,1))),color,'linewidth',2)