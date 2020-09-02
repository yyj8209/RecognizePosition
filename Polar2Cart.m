function [X,Y,Z] = Polar2Cart(Array,R,THETA,DeltaY)
% Ӧ����myContour��
% [X,Y,Z] = Polar2Cart(Array,R,THETA,DeltaY)
% ���룺
% Array ��m��ɨ�����ݣ�
% R��ɨ��뾶��
% THETA��һ��nά����������n�����Ӧ��
% DeltaY��һ��mά����������m-1���ƶ���Ӧ��

    [m,n] = size(Array);
    [m1,~] = size(THETA);
    X = zeros(m,n);
    Y = X;
    Z = Array;
    for i = 1:m
        if(m1 == 1)
            [X(i,:),y] = pol2cart(THETA,R);
        else
            [X(i,:),y] = pol2cart(THETA(i,:),R);
        end
        Y(i,:) = y + DeltaY(i);
    end
end
