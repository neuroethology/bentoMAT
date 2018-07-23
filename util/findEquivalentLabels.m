function bhvrs = findEquivalentLabels(bhvrs)

for b = 1:length(bhvrs)
    switch bhvrs{b}
        case {'sniff_genital','sniff_genitals','sniffurogenital','sniffgenital','sniffgenitals','anogeninvestigation'}
            bhvrs{b} = 'sniff_genital';
        case {'sniff_face','sniffface','facesniffing','snifface'}
            bhvrs{b} = 'sniff_face';
        case {'sniff_body','sniffbody','bodysniffing'}
            bhvrs{b} = 'sniff_body';
        case {'groom','grooming'}
            bhvrs{b} = 'grooming';
        case {'closeinvestigate','closeinvestigation','investigate','investigation','close_investigate','close_investigation'}
            bhvrs{b} = 'closeinvestigation';
        case{'singing','song'}
            bhvrs{b} = 'singing';
    end    
end