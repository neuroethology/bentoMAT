function pts = jellyfish_neurons(data,fr)

fr = min(fr,data.tMax);
pts = {};
for i = 1:data.nCells
    pts{i} = [i data.pX(i,fr) data.pY(i,fr)];
end
    
