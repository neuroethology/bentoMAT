function gui = drawAudio(gui)

if(isfield(gui,'audio'))
    delete(gui.audio.panel);
end

audio.panel        = uipanel('position',[0 0 1 1],'bordertype','none');
audio.axes         = axes('parent',audio.panel,'ytick',0:25:100); hold on;
audio.yScale       = 1;
audio.win          = 20;
audio.bg           = image();
audio.img          = image();colormap(parula(64));
audio.zeroLine     = plot([0 0],get(gca,'ylim'),'k--');

xlabel('time (sec)');
axis tight;
xlim(audio.win*[-1 1]);


gui.audio = audio;