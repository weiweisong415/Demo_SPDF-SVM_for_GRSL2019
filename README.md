# Demo_SPDF-SVM
The code implementation of our paper "Deep Hashing Neural Networks for Hyperspectral Image Feature Extraction", accepted by IEEE Geosci. Remote Sens. Lett, 2019.
If you use this code, please kindly cite our paper:
@article{song2019Deep,
  title={Deep Hashing Neural Networks for Hyperspectral Image Feature Extraction},
  author={Fang, Leyuan and Liu, Zhiliang and Song, Weiwei},
  journal={IEEE Geoscience and Remote Sensing Letter},
  volume={16},
  number={9},
  pages={1412-1416},
  year={2019},
  publisher={IEEE}
}

This code is tested on matconvnet-1.0-beta25, which can refer to this link (http://www.vlfeat.org/matconvnet/install/) to correctly install this deep learning framework. Here, we assume the installation location of matconvent is "Demo_SPDF-SVM/matconvnet".

1. Download the pre-trained deep models for website (http://www.vlfeat.org/matconvnet/pretrained/), for examples: imagenet-vgg-s.mat or imagenet-vgg-f.mat. Put them into the folder "Demo_SPDF-SVM/models";

2. Download the hyperspectral datasets form website (http://lesun.weebly.com/hyperspectral-data-set.html) and put them into folder      "Demo_SPDF-SVM/data";

3. run the script "Demo_SPDF.m" to obtain the classification rsults.

If you have any questions, don't hesitate to contact me: Email: weiwei_song@hnu.edu.cn
