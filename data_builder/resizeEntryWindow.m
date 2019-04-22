function resizeEntryWindow(source,~)
%
% (C) Ann Kennedy, 2019
% California Institute of Technology
% Licensing: https://github.com/annkennedy/bento/blob/master/LICENSE.txt


minWidth = 730;
h = guidata(source);
h.pTop.Position(2)  = h.f.Position(4)-90;
h.pTop.Position(1)  = (h.f.Position(3) - minWidth)/2+10;
wResid = max(h.f.Position(3),minWidth);

bump = h.f.Position(4) - h.pTop.Position(4) - 10;
for i = 1:length(h.fields)
    h.fields(i).rm.Callback = {@entryWindowRmBox,i};
    bump = bump - h.fields(i).wrap.Position(4);
    h.fields(i).wrap.Position(2)    = bump;
    h.fields(i).wrap.Position(3)    = wResid;
    h.fields(i).p.Position(3)       = wResid - 60;
    for j = h.fields(i).rows
        j.p.Position(3) = wResid - 60; %scale the row wrapper
        all = [j.fix j.scale];
        start = cell2mat(arrayfun(@(a) a.Position(1), all, 'Uniform', 0));
        width = cell2mat(arrayfun(@(a) a.Position(3), all, 'Uniform', 0));
        ratio = cell2mat(arrayfun(@(a) a.Position(3), j.scale, 'Uniform', 0));
        ratio = ratio/sum(ratio);
        delta = (wResid - 60) - min(start) - sum(width) - 10*length(width);
        for ind = 1:length(j.scale)
            j.scale(ind).Position(3) = j.scale(ind).Position(3) + delta*ratio(ind);
            width(start==j.scale(ind).Position(1)) = width(start==j.scale(ind).Position(1)) + delta*ratio(ind);
            move = find(start > j.scale(ind).Position(1));
            if(isempty(move))
                continue;
            else
                for l = move
                    all(l).Position(1) = (wResid - 60) - sum(width(start>=start(l))) - sum(start>=start(1))*10;
                end
            end
        end
        align([j.scale j.fix],'distribute','center');
    end
end
h.bump = bump;

if(bump<=10)
    h.bump = 10;
    h.f.Position(4) = h.f.Position(4) - bump + 10;
end
guidata(h.f,h);