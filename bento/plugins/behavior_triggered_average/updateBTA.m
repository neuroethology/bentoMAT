function updateBTA(source,~,gui)
%
% (C) Ann Kennedy, 2019
% California Institute of Technology
% Licensing: https://github.com/annkennedy/bento/blob/master/LICENSE.txt


h = guidata(source);

if(~isempty(strfind(source.Tag,'checkbox')))
    color = permute(source.CData(2,5,:),[1 3 2]);
    set(source,'CData',getButtonImage(color,source.Value));
end

str = h.unit.String{h.unit.Value};
switch lower(str(1))
    case 'p' % population average: across trials yes, across channels no
        h.chAvgTxt.Enable='off';
        h.chAvg.Enable='off';
        h.trAvgTxt.Enable='on';
        h.trAvg.Enable='on';
    case 'u' % unit: across trials no, across channels no
        h.chAvgTxt.Enable='off';
        h.chAvg.Enable='off';
        h.trAvgTxt.Enable='off';
        h.trAvg.Enable='off';
    case 'b' % behavior: across trials yes, across channels yes
        h.chAvgTxt.Enable='on';
        h.chAvg.Enable='on';
        h.trAvgTxt.Enable='on';
        h.trAvg.Enable='on';
    case 'f' % feature: across trials yes, across channels no
        h.chAvgTxt.Enable='off';
        h.chAvg.Enable='off';
        h.trAvgTxt.Enable='on';
        h.trAvg.Enable='on';
end

if(h.isActive)
    computeBTA(source,[],gui);
end