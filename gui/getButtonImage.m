function cbox = getButtonImage(color,isActive)
%
% (C) Ann Kennedy, 2019
% California Institute of Technology
% Licensing: https://github.com/annkennedy/bento/blob/master/LICENSE.txt



cbox = padarray(repmat(permute(color,[1 3 2]),[23 23 1]),[1 1 0]);

Xpic = ones(21)-(eye(21) | fliplr(eye(21)) |...
                 diag(ones(1,20),-1) | fliplr(diag(ones(1,20),-1)) |...
                 diag(ones(1,20),1)  | fliplr(diag(ones(1,20),1)));
Xpic = padarray(Xpic,[2 2],1);

if(isActive)
    if(mean(color)>.5)
        cbox = bsxfun(@times,cbox,Xpic);
    else
        cbox = bsxfun(@max,cbox,1-Xpic);
    end
end