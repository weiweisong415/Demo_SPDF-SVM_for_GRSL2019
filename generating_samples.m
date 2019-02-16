function [train_data, train_L, test_data, test_L] = generating_samples(img, img_gt, no_classes, train_perclass, pad_size);
% =========================================================
% This function is used yo generate the samples and labels
% ========================================================
train_data = [];
train_L = [];
test_data = [];
test_L = [];
train_index = [];
test_index = [];
per_index = [];
num_bands = 3;

[I_row,I_line,I_high] = size(img);
img=reshape(img,I_row*I_line,I_high);
%%%%%%%%%%%%%%  Dimension-reducing by PCA  %%%%%%%%%%%%%%%%%%%%%%%
im=img;
im=compute_mapping(im,'PCA',num_bands);
im = mat2gray(im);
im =reshape(im,[I_row,I_line,num_bands]);
[I_row,I_line,I_high] = size(im);

%%%%%  scale the image from 0 to 1
im=reshape(im,I_row*I_line,I_high);
[im ] = scale_func(im);
im =reshape(im,[I_row,I_line,I_high]);

im = round(255*im);
%%%%%% extending the image %%%%%%%%
im_extend=padarray(im,[pad_size,pad_size],'symmetric');


for ii = 1: no_classes
    index_ii =  find(img_gt == ii)'; 
    rand_order=randperm(length(index_ii));
    train_ii = rand_order(:,1:train_perclass(ii));
    train_index = [train_index index_ii(train_ii)];
    train_label_temp = ones(1, length(train_ii))*ii;
    train_L = [train_L train_label_temp];
    test_ii = rand_order(:,train_perclass(ii)+1:end);
    test_index = [test_index index_ii(test_ii)];
    test_label_temp = ones(1, length(test_ii))*ii;
    test_L = [test_L test_label_temp];
end

train_data = zeros(2*pad_size+1,2*pad_size+1,I_high,length(train_index));
count=0;
for j = 1:length(train_index)
    count = count+1;
    img_data = [];
    X = mod(train_index(j),I_row);
    Y = ceil(train_index(j)/I_row);
    if X==0
        X=I_row;
    end
    if Y==0
        Y=I_line;
    end
    X_new = X+pad_size;
    Y_new = Y+pad_size;
    X_range = [X_new-pad_size : X_new+pad_size];
    Y_range = [Y_new-pad_size : Y_new+pad_size]; 
    img_data=im_extend(X_range,Y_range,:);
    train_data(:,:,:,count)=img_data;
end

test_data = zeros(2*pad_size+1,2*pad_size+1,I_high,length(test_index));
count=0;
for j = 1:length(test_index)
    count = count+1;
    img_data = [];
    X = mod(test_index(j),I_row);
    Y = ceil(test_index(j)/I_row);
    if X==0
        X=I_row;
    end
    if Y==0
        Y=I_line;
    end
    X_new = X+pad_size;
    Y_new = Y+pad_size;
    X_range = [X_new-pad_size : X_new+pad_size];
    Y_range = [Y_new-pad_size : Y_new+pad_size]; 
    img_data=im_extend(X_range,Y_range,:);
    test_data(:,:,:,count)=img_data;
end
train_L = train_L';
test_L = test_L';
end

