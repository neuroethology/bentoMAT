function processCP(~,~,h,gui,m,sess,trList,bhvList)
%
% (C) Ann Kennedy, 2019
% California Institute of Technology
% Licensing: https://github.com/annkennedy/bento/blob/master/LICENSE.txt



bhv1 = bhvList(h.bhv1.Value);
ch1  = h.ch1.String(h.ch1.Value);
tr1  = trList(h.tr1.Value);

bhv2 = bhvList(h.bhv2.Value);
ch2  = h.ch2.String(h.ch2.Value);
tr2  = trList(h.tr2.Value);

% assemble condition 1 data:
rast1 = [gui.allData(m).(sess)(tr1).rast];
mask1 = [];
for tr = tr1'
    data    = gui.allData(m).(sess)(tr);
    mtemp = false(1,length(data.annoTime));
    for f = bhv1'
        if(~strcmpi(f{:},'no label') && isfield(data.annot.(ch1{:}),f{:}))
            mtemp = mtemp|convertToRast(data.annot.(ch1{:}).(f{:}),length(data.annoTime));
        else
            mtemp2 = false(size(mtemp));
            for f2 = setdiff(bhvList','no label')
                mtemp2 = mtemp2|convertToRast(data.annot.(ch1{:}).(f2{:}),length(data.annoTime));
            end
            mtemp = mtemp|~mtemp2;
        end
    end
    mask1 = [mask1 mtemp];
end
mask1 = imresize(mask1,[1 length(rast1)])>0.5;

% assemble condition 2 data:
rast2 = [gui.allData(m).(sess)(tr2).rast];
mask2 = [];
for tr = tr2'
    data    = gui.allData(m).(sess)(tr);
    mtemp = false(1,length(data.annoTime));
    for f = bhv2'
        if(~strcmpi(f{:},'no label'))
            mtemp = mtemp|convertToRast(data.annot.(ch2{:}).(f{:}),length(data.annoTime));
        else
            mtemp2 = false(size(mtemp));
            for f2 = setdiff(bhvList','no label')
                mtemp2 = mtemp2|convertToRast(data.annot.(ch2{:}).(f2{:}),length(data.annoTime));
            end
            mtemp = mtemp|~mtemp2;
        end
    end
    mask2 = [mask2 mtemp];
end
mask2 = imresize(mask2,[1 length(rast2)])>0.5;

%compute CP:
rast1 = rast1(:,mask1~=0);
rast2 = rast2(:,mask2~=0);
for i = 1:size(rast1,1)
    CP(i) = doCP(rast1(i,:),rast2(i,:));
end

gui.traces.order = CP;
guidata(gui.h0,gui);
updatePlot(gui.h0,[]);

