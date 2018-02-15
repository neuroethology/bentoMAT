function feats = MARS_top_features(data)

feats = [squeeze(data.data_smooth(1,:,:)) squeeze(data.data_smooth(2,:,:))];