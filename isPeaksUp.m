function result = isPeaksUp(data)
% �ж϶�ά�����Ƿ�ֵ���ϣ����ǹ�ֵ���£�

result = true;
[m,n] = size(data);
if((m == 1)||(n == 1))    % һά����������
    [Value] = find(data >  mean(data));
    if(length(Value)>0.5*length(data))
        result = false;    % �ȵ���״����Ҫ��ת�����ֵ��
    end
else
    [Value] = find(data >  mean(mean(data)));
    if(length(Value)>0.5*m*n)
        result = false;    % �ȵ���״����Ҫ��ת�����ֵ��
    end
end
