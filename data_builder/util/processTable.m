function processTable(source,~,parent)

gui = guidata(source);
transferToBento(parent,gui.mouse);
close(gui.f);