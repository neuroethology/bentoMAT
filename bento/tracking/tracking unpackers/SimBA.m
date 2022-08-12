function pts = SimBA(data,fr)

%     fr = min(fr,size(data.data,2));
%     findparts = find(contains(string(data.ids),'Euclidean'),1,'first')-1;
% 
%     for i = 1:3:findparts
%         m1      = data.data([i; i+1],fr);
%         pts{(i-1)/3+1} = [(i-1)/3+1 m1(:)'];
%     end
pts = [];