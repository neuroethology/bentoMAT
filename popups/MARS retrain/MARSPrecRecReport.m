function varargout = MARSPrecRecReport(bhvr,gui,trials,GT)

if(~nargout)
    close(figure(6759));
    hfig = figure(6759);clf;
    set(hfig,'dockcontrols','off','menubar','none',...
            'NumberTitle','off','Position', hfig.Position.*[.75 .75 1.45 1.25],...
            'units','normalized');  
end

bhvr = strrep(bhvr,'-','_');
for i = 1:length(bhvr)
    clear prec rec;
    
    for t = 1:length(trials)
        vals    = sscanf(trials{t},'mouse %d, session %d, trial %d')';
        data    = gui.allData(vals(i,1)).(['session' num2str(vals(i,2))])(vals(i,3));
        
        try
        gt      = convertToRast(data.annot.(GT).(bhvr{i}),length(data.annoTime))~=0;
        catch
            keyboard
        end
        pred    = convertToRast(data.annot.MARS_output.(bhvr{i}),length(data.annoTime))~=0;
        
        prec(t,1) = sum(pred(gt))/sum(pred);
        rec(t,1)  = sum(pred(gt))/sum(gt);
    end
    prec = [nanmean(prec); 0; prec];
    rec  = [nanmean(rec);  0; rec];
    T = table(prec,rec,'RowNames',[{'Average';'---'};trials],'variableNames',{'Precision','Recall'});
    
    if(~nargout)
        subplot(1,length(bhvr),i);
        TString = evalc('disp(T)');
        % Use TeX Markup for bold formatting and underscores.
        TString = strrep(TString,'<strong>','\bf');
        TString = strrep(TString,'</strong>','\rm');
        TString = strrep(TString,'_',' ');
        start = strfind(TString,'\bf---');
        stop = start+5 + min(strfind(TString(start+5:end),'\bf'));
        TString(start:stop) = strrep(TString(start:stop),'0','-');
        TString(1:(7+length(bhvr{i}))) = ['\bf    ' upper(bhvr{i})];
        % Get a fixed-width font.
        FixedWidth = get(0,'FixedWidthFontName');
        % Output the table using the annotation command.
        annotation(gcf,'Textbox','String',TString,'Interpreter','Tex',...
            'FontName',FixedWidth,'Position',[0.05 (i-1)/length(bhvr) 0.9 1/length(bhvr)],'edgecolor','none');
        axis off;
    else
        varargout{1}(i) = prec(1);
        varargout{2}(i) = rec(1);
    end
end