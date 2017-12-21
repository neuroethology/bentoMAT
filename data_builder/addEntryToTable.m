function addEntryToTable(source,~)
h = guidata(source);

m       = str2num(h.expt.Mouse.String);
sess    = ['session' h.expt.Sess.String];
tr      = getTrial(h.ind,h.parent.t.Data);

mouse = h.parent.mouse;
mouse(m).(sess)(tr).stim = h.expt.Stim.String;
mouse(m).(sess)(tr).io = unpackIOData(h.fields);

h.parent = updateTableData(h.parent,mouse);

close(h.f);

h.parent.preview.String = getIODataString(h.parent.mouse(m).(sess)(tr).io);
h.parent.pth = h.pth;

guidata(h.parent.f,h.parent);