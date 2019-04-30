function gui = drawMovie(gui)
%
% (C) Ann Kennedy, 2019
% California Institute of Technology
% Licensing: https://github.com/annkennedy/bento/blob/master/LICENSE.txt



if(isfield(gui,'movie'))
    delete(gui.movie.panel);
end
%behavior movie panel:
movie.panel     = uipanel('position',[0 0 1 1],'bordertype','none');
movie.axes      = axes('parent',movie.panel,'position',[0.01 0 0.98 1]);
movie.img       = image(0);
movie.sc        = 1;
for i = 1:20
    movie.annot(i)  = text(10,30+60*(i-1),'','fontweight','bold','color','w','fontsize',18);
end
% movie.stim = title('');
axis equal; axis tight; axis off; axis ij; hold on;

gui.movie = movie;