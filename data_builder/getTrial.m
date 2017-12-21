function tr = getTrial(ind,data)

m = data{ind,1};
s = data{ind,2};

match = find(cellfun(@(x) x==m,data(:,1)) & cellfun(@(x) x==s,data(:,2)));

tr = find(match==ind);