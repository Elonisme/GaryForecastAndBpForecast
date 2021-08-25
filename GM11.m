function [X,c1,error1,error2]=GM11(X0,k)
% ����X0Ϊ�������У�kΪԤ�ⳤ�ȣ�
% XΪԤ��������У�cΪ������������error1Ϊ�вerror2Ϊ������
format long;
n=length(X0);
X1=[];
X1(1)=X0(1);
for i=2:n
X1(i)=X1(i-1)+X0(i);               %�����ۼ���������
end
for i=1:n-1
B(i,1)=-0.5*(X1(i)+X1(i+1));   %����B��Yn
B(i,2)=1;
Y(i)=X0(i+1);
end
alpha=(B'*B)^(-1)*B'*Y';            %����С���˹���
a=alpha(1,1);
b=alpha(2,1);
d=b/a;                            %����ʱ����Ӧ��������
c=X1(1)-d;
X2(1)=X0(1);
X(1)=X0(1);

for i=1:n-1
X2(i+1)=c*exp(-a*i)+d;
 X(i+1)=X2(i+1)-X2(i);    
 %����Ԥ������
end
for i=(n+1):(n+k)
    X2(i)=c*exp(-a*(i-1))+d;         %����Ԥ������
    X(i)=X2(i)-X2(i-1);
end
for i=1:n
    error(i)=X(i)-X0(i);
    error1(i)=abs(error(i));       %����в�
    error2(i)=error1(i)/X0(i);     %����������
end
c1=std(error1)/std(X0);             %�������������