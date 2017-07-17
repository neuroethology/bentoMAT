function mov = Jellyfish_TentacleBulbs(mov,fr,active,data)

npts = size(data.ctrStore{fr},1);
active(active>npts) = [];

pts = data.ctrStore{fr}(active,:);
mov = insertObjectAnnotation(mov,'circle',[pts 5*ones(size(pts,1),1)],cellstr(num2str( (1:length(active))' ))',...
                             'color','magenta','textcolor','w','linewidth',4,'FontSize',12);

pts = data.ctrStore{fr}(setdiff(1:npts,active),:);
mov = insertObjectAnnotation(mov,'circle',[pts 5*ones(size(pts,1),1)],cellstr(num2str( ((length(active)+1):npts)' ))',...
                             'color','blue','textcolor','w','linewidth',2,'FontSize',10);