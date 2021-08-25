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
title('ԭʼ����ͼ��')
subplot(1,2,2)
autocorr(x)
title('����غ���ͼ��')

%��1��4�����
s=12;  %����s=12
n=12;  %Ԥ�����ݵĸ���
m1=length(x); 
for i=s+1:m1
  	y(i-s)=x(i)-x(i-s); 
end
x1=diff(y); 
m2=length(x1); 
figure;
subplot(1,2,1)
plot(x1)
title('��ֺ�����ͼ��')
subplot(1,2,2)
autocorr(x1)
title('����غ���ͼ��')

%%����������
yanchi=[2,6,12];
[H,pValue,Qstat,CriticalValue]=lbqtest(x1,'lags',yanchi);
%�������ʽ��ӡ��Ӧͳ����
fprintf('%15s%15s%15s','�ӳٽ���','����ͳ����','pֵ');
fprintf('\n');
for i=1:length(yanchi)
    fprintf('%18f%19f%19f',yanchi(i),Qstat(i),pValue(i));
    fprintf('\n');
end

%%ģ��ʶ��
x1=x1';
LOGL = zeros(6,6);% Initialize
PQ = zeros(6,6);
for p = 0:5
    for q = 0:5
        model=arima(p,0,q);%ָ��ģ�͵Ľṹ
        [fit,~,logL] =estimate(model,x1);  %��ϲ���
        LOGL(p+1,q+1) = logL;
        PQ(p+1,q+1) = p+q;%������ϲ����ĸ���
    end
end
LOGL = reshape(LOGL,numel(LOGL),1);
PQ = reshape(PQ,numel(PQ),1);
[aic,bic] = aicbic(LOGL,PQ+1,m2);
fprintf('AICΪ��\n');  %��ʾ������
reshape(aic,6,6)       %����36��ģ��AIC��ֵ
fprintf('BICΪ��\n');
reshape(bic,6,6)       %����36��ģ��BIC��ֵ

%% ģ�͹���
p=input('�������p��');q=input('�������q��');
model=arima(p,0,q);        %ָ��ģ�͵Ľṹ
m=estimate(model,x1)      %��ϲ���

%% ģ�Ͳв����
z=iddata(x1);
ml1=armax(z,[p,q]);
e = resid(ml1,z);%������в����
[H,pValue,Qstat,CriticalValue]=lbqtest(e.OutputData,'lags',6)


%% ģ��Ԥ��
[yf,ymse]=forecast(m,n,'Y0',x1);%yfΪx1Ԥ��ֵ
yhat=y(end)+cumsum(yf)%��y��Ԥ��ֵ
for j=1:n
    x(m1+j)=yhat(j)+x(m1+j-s);%��x��Ԥ��ֵ
end
xhat=x(m1+1:end)%��ȡn��Ԥ��ֵ





