% x=[9.40	8.81	8.65	10.01	11.07	11.54	12.73	12.43	11.64	11.39	11.1	10.8
% 10.71	10.24	8.48	9.88	10.31	10.53	9.55	6.51	7.75	7.8	5.96	5.21
% 6.39	6.38	6.51	7.14	7.26	8.49	9.39	9.71	9.65	9.26	8.84	8.29
% 7.21	6.93	7.21	7.82	8.57	9.59	8.77	8.61	8.94	8.4	8.35	7.95
% 7.66	7.68	7.85	8.53	9.38	10.09	10.59	10.83	10.49	9.21	8.66	8.39
% 8.27	8.14	8.71	10.43	11.47	11.73	11.61	11.93	11.55	11.35	11.11	10.4
% 10.16	9.96	10.47	11.70	10.1	10.37	12.47	11.91	10.83	10.64	10.29	10.3];
x=C2;
x=reshape(x',numel(x),1);
subplot(1,2,1)
plot(x)
title('原始数据图像')
subplot(1,2,2)
autocorr(x)
title('自相关函数图像')

%做1阶4步差分
s=12;  %周期s=12
n=12;  %预报数据的个数
m1=length(x); 
for i=s+1:m1
  	y(i-s)=x(i)-x(i-s); 
end
x1=diff(y); 
m2=length(x1); 
figure;
subplot(1,2,1)
plot(x1)
title('差分后序列图像')
subplot(1,2,2)
autocorr(x1)
title('自相关函数图像')

%%白噪声检验
yanchi=[2,6,12];
[H,pValue,Qstat,CriticalValue]=lbqtest(x1,'lags',yanchi);
%按表格形式打印相应统计量
fprintf('%15s%15s%15s','延迟阶数','卡方统计量','p值');
fprintf('\n');
for i=1:length(yanchi)
    fprintf('%18f%19f%19f',yanchi(i),Qstat(i),pValue(i));
    fprintf('\n');
end

%%模型识别
x1=x1';
LOGL = zeros(6,6);% Initialize
PQ = zeros(6,6);
for p = 0:5
    for q = 0:5
        model=arima(p,0,q);%指定模型的结构
        [fit,~,logL] =estimate(model,x1);  %拟合参数
        LOGL(p+1,q+1) = logL;
        PQ(p+1,q+1) = p+q;%计算拟合参数的个数
    end
end
LOGL = reshape(LOGL,numel(LOGL),1);
PQ = reshape(PQ,numel(PQ),1);
[aic,bic] = aicbic(LOGL,PQ+1,m2);
fprintf('AIC为：\n');  %显示计算结果
reshape(aic,6,6)       %储存36个模型AIC的值
fprintf('BIC为：\n');
reshape(bic,6,6)       %储存36个模型BIC的值

%% 模型估计
p=input('输入阶数p＝');q=input('输入阶数q＝');
model=arima(p,0,q);        %指定模型的结构
m=estimate(model,x1)      %拟合参数

%% 模型残差检验
z=iddata(x1);
ml1=armax(z,[p,q]);
e = resid(ml1,z);%拟合做残差分析
[H,pValue,Qstat,CriticalValue]=lbqtest(e.OutputData,'lags',6)


%% 模型预测
[yf,ymse]=forecast(m,n,'Y0',x1);%yf为x1预测值
yhat=y(end)+cumsum(yf)%求y的预报值
for j=1:n
    x(m1+j)=yhat(j)+x(m1+j-s);%求x的预测值
end
xhat=x(m1+1:end)%截取n个预报值





