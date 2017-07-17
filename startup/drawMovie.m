function gui = drawMovie(gui)

if(isfield(gui,'movie'))
    delete(gui.movie.panel);
end
%behavior movie panel:
movie.panel     = uipanel('position',[0 0 1 1],'bordertype','none');
movie.axes      = axes('parent',movie.panel,'position',[0.01 0 0.98 1]);
movie.img       = image(0);colormap gray;
movie.annot     = text(10,30,'','fontweight','bold','color','w','fontsize',14);
axis equal; axis tight; axis off; axis ij; hold on;

gui.movie = movie;