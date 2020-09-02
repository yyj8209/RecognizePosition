function  [x, y, Xm, Yn] = targetPosition(X,Y,Z,CH1Threshold,MaxTargetNum,SignalWidth)
%��X��Y ��������ƽ�棬Z ������ͨ�������ݡ�
% ���Ϊ��ֵ���ڵ�(x��y)����ֵ����Xm, Yn��Ϊ�������
% ʵ���϶�λֻ��Ҫ CH1 �����ݾͿ����ˡ�

z = Z(:,:,1);
[~,MeanValue,~,~] = peakValue(z,SignalWidth,MaxTargetNum);   % ÿһ��ɨ��ʱ����׼�ź�ǿ�ȡ�
z = z - MeanValue;     % ��ÿ��ǿ�Ȳ�һ�£���Ҫ����ȥ����2019.11.19

BW = imregionalmax(abs(z));

[Xm,Yn] = find(BW);    %���ҳ���Ϊ��ĵ㡣
mLen = length(Xm);
tmp = zeros(1,mLen);  % ��ʱ�洢δ�ﵽ���޵ķ�ֵ��
k = 0;
for i = 1:mLen
    v = abs(z(Xm(i),Yn(i)));
    if(v < CH1Threshold)    % δ�ﵽ���޵�ֵ����ǡ�
        k = k + 1;
        tmp(k) = i;
    end
end
forDelete = tmp(1:k);
Xm(forDelete) = [];   % ��δ�ﵽ���޵ĵ�ɾ������ʱ��Ϊ������ţ�������ֵ��
Yn(forDelete) = [];
%% ����һ�������ж��Ƿ�Ϊ�߽�������鱨��Ŀ��㡣�����ܼ�Ϊ�鱨�ĵ㡣
xx = diff(Xm);
yy = diff(Yn);
Distance = sqrt(xx.^2+yy.^2);
forDelete = find(Distance<2);
if(~isempty(forDelete))
    Xm(forDelete+1) = [];   % ��δ�ﵽ���޵ĵ�ɾ������ʱ��Ϊ������ţ�������ֵ��
    Yn(forDelete+1) = [];
end
%%

len = length(Xm);
if(len == 0)
    msgbox('��������Ŀ�꣡');
    x = [];
    y = [];
    return;
else
    x = zeros(1,len);  %�洢��ֵ���ꡣ
    y = x;
    for i = 1:len
        x(i) = X(Xm(i),Yn(i));
        y(i) = Y(Xm(i),Yn(i));
    end
end

