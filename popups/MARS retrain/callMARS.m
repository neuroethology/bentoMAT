function callMARS(source,~)

h   = guidata(source);
gui = guidata(h.h0);

behaviors = py.list(h.bhvrs.String(h.bhvrs.Value)');
model     = h.pth;

trials = h.trials.String(h.trials.Value);

for i=1:length(trials)
    vals = sscanf(trials{i},'mouse %d, session %d, trial %d');
    data = gui.allData(vals(1)).(['session' num2str(vals(2))])(vals(3));
    
    ind = find(~isempty(strfind(data.io.movie.fid,'Top')),1); %assume we're just using the top classifier for now
    movies{1,i} = data.io.movie.fid{ind};
    annot{1,i}  = data.io.annot.fid{end};
    feat{1,i}   = data.io.feat.fid;
end

movies  = py.list(movies);
annot   = py.list(annot);
feat    = py.list(feat);

doFull = find([h.train.Children.Value])==2; % full train or quick train

% insert(py.sys.path,'path_to_MARS','');
% py.MARS.train_classifier(behaviors,model,movies,annot,feat);