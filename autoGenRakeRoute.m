function [RouteX,RouteY] = autoGenRakeRoute(xVertex,yVertex,Width)
% [RouteX,RouteY] = autoGenRakeRoute(xVertex,yVertex,Width)
% ���ɰ��ε�̽ɨ·����
%   �˴���ʾ��ϸ˵��

    % �������θ��ߵķ��̡�
    NumVertex = length(xVertex) - 1;
    M = 100;
    LineX = zeros(NumVertex,M);
    LineY = zeros(NumVertex,M);
    for i = 1:NumVertex
        LineX(i,:) = linspace(xVertex(i),xVertex(i+1),M);
        LineY(i,:) = linspace(yVertex(i),yVertex(i+1),M);
    end
    
    % ƽ����Y��ĵȾ���ֱ�������εĽ��㣬��Ϊ���ζ��㡣
    Xmin = min(xVertex);
    Xmax = max(xVertex);
    X_i = Xmin:Width:Xmax;
    NumRectangle = length(X_i);
%     yValue = zeros(1,2); 
    for i = 1:NumRectangle
        Rect(i).Xleft = X_i(i);    % �����꣨��
        Rect(i).Xright = X_i(i)+Width;    % �����꣨�ң�
        n = 1;
        for k = 1:NumVertex
            y = interp1(LineX(k,:),LineY(k,:),X_i(i));
            if(~isnan(y))
                yValue(n) = y;
                n = n + 1;
            end
        end
        Rect(i).Ytop = max(yValue);
        Rect(i).Ybottom = min(yValue);
    end
    