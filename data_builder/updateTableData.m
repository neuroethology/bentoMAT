function gui = updateTableData(gui,mouse)

gui.mouse = mouse; 

M = {};
for m = 1:length(mouse)
    for sess = fieldnames(mouse(m))'
        for tr = 1:length(mouse(m).(sess{:}))
            types = fieldnames(mouse(m).(sess{:})(tr).io);
            
            M{end+1,1} = num2str(m);
            M{end,2}   = strrep(sess{:},'session','');
            M{end,3}   = mouse(m).(sess{:})(tr).stim;
            M{end,4}   = strrep(strjoin(types,'; '),'_',' ');
        end
    end
end

M = appendTableIcons(M);
gui.t.Data = M;