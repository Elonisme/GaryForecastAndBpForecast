clc
clear all
close all
p=[1.14 1.18 1.20 1.26 1.28 1.30  1.38  1.38  1.38  1.40  1.48  1.54  1.56  1.36  1.24;
     1.78 1.96  1.86  2.00  2.00  1.96 1.64  1.82  1.90  1.70  1.82  1.82  2.08  1.74  1.72];%输入两种飞蠓的参数
t = [1 1 1 1 1 1 0 0 0 0 0 0 0 0 0];                   %两种飞蠓的类别
net=newff(minmax(p),[2,1],{'tansig','purelin'});      %建立一个具有两层的神经网络
net.trainParam.show = 50; 
net.trainParam.epochs = 50000;
net.trainParam.goal = 1e-3;                       %设置训练参数
net=train(net,p,t);    
pp=[1.24 1.28 1.40;1.80 1.84 2.04];                                %输入需要判别的三只飞蠓参数
y = sim(net, pp);                              %利用已训练好的网络识别三只飞蠓




