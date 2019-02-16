function [train_features, test_features] = extract_features(net, train_data, test_data)
    batchsize = 100;
    for j = 0:ceil(size(train_data,4)/batchsize)-1
        im = train_data(:,:,:,(1+j*batchsize):min((j+1)*batchsize,size(train_data,4))) ;
        im_ = single(im) ; % note: 0-255 range
        im_ = imresize(im_, net.meta.normalization.imageSize(1:2)) ;
        im_ = im_ - repmat(net.meta.normalization.averageImage,1,1,1,size(im_,4)) ;
        im_ = gpuArray(im_) ;
        % run the CNN
        res = vl_simplenn(net, im_) ;
        features = squeeze(gather(res(end).x))' ;
        train_features((1+j*batchsize):min((j+1)*batchsize,size(train_data,4)),:) = features ;
    end
    for j = 0:ceil(size(test_data,4)/batchsize)-1
        im = test_data(:,:,:,(1+j*batchsize):min((j+1)*batchsize,size(test_data,4))) ;
        im_ = single(im) ; % note: 0-255 range
        im_ = imresize(im_, net.meta.normalization.imageSize(1:2)) ;
        im_ = im_ - repmat(net.meta.normalization.averageImage,1,1,1,size(im_,4)) ;
        im_ = gpuArray(im_) ;
        % run the CNN
        res = vl_simplenn(net, im_) ;
        features = squeeze(gather(res(end).x))' ;
        test_features((1+j*batchsize):min((j+1)*batchsize,size(test_data,4)),:) = features ;
    end
 train_features = double(train_features);
 test_features = double(test_features);
end

