clear all;close all;clc;
addpath('drtoolbox');
addpath('libsvm-3.22','libsvm-3.22/matlab');
dataset_name = 'pavia_university';  % paviau_university or salinas
for num = 1:10
switch(dataset_name)
    case 'pavia_university'
        no_classes = 9;
        train_perclass = ones(1, no_classes)*200;  % number of training samples per class
        load('./data/PaviaU.mat');
        load('./data/PaviaU_gt.mat');
        img = paviaU;
        img_gt = paviaU_gt;
        pad_size = 12;    % patch size = 2*pad_size+1
    case 'salinas'
        no_classes = 16;
        train_perclass = ones(1, no_classes)*200;
        load('./data/Salinas_corrected.mat');
        load('./data/Salinas_gt.mat');
        img = salinas_corrected;
        img_gt = salinas_gt;
        pad_size = 18;
end

[train_data, train_L, test_data, test_L] = generating_samples(img, img_gt, no_classes, train_perclass, pad_size);

%% load the pre-trained CNN
net = load('models/imagenet-vgg-f.mat');
%% initialization
maxIter = 50;  % number of iterations 
eta = 10;    % regularization parameter, 
codelens = 64;  % length of hash layer
lr = logspace(-2,-5,maxIter) ; %generate #maxIter of points between 10^(-2) ~ 10^(-6)
net = net_structure (net, codelens);
U = zeros(size(train_data,4),codelens);
B = zeros(size(train_data,4),codelens);
%% training
for iter = 1: maxIter
[net,U,B] = train(train_data,train_L,U,B,net,iter,lr(iter),eta);
end
[train_features, test_features] = extract_features(net, train_data, test_data);

%%%% Select the paramter for SVM with five-fold cross validation
[Ccv Gcv cv cv_t]=cross_validation_svm(train_L,train_features);
%%%% Training using a Gaussian RBF kernel
%%% give the parameters of the SVM (Thanks Pedram for providing the
%%% parameters of the SVM)
parameter=sprintf('-c %f -g %f -m 500 -t 2 -q',Ccv,Gcv); 

%%% Train the SVM
model=svmtrain(train_L,train_features,parameter);

%%%% SVM Classification
SVMresult = svmpredict(ones(size(test_features,1),1),test_features,model); 

%%%% Evaluation the performance of the SVM
GroudTest = double(test_L);
%SVMResultTest = SVMresult(test_index,:);
[SVMOA(num),SVMKappa(num),SVMAA(num), SVMCA(:,num)]=calcError(GroudTest-1,SVMresult-1,1:no_classes);
end
OA = mean(SVMOA)
AA = mean(SVMAA)
Kappa = mean(SVMKappa)
CA = mean(SVMCA,2)