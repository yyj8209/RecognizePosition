function [RouteX,RouteY] = autoGenRakeRoute(xVertex,yVertex,HalfWidth)
% [RouteX,RouteY] = autoGenRakeRoute(xVertex,yVertex,HalfWidth)
% ���������ε�̽ɨ·����
% �����ƽ�еķ������ߡ�
% ���裺
% 1���ҳ���ıߣ�
% 2������ߵ�һ��Ϊ���㣬��ת����Y��ƽ�У�
% 3��������ת�Ƕȼ��¶���λ�ã�
% 4������autoGenRakeRouteV�������ɹ���·����;���㣻
% 5�����ݵ�3������ĽǶȣ�������ת�������µ�;�������ꡣ

    NumVertex = length(xVertex) - 1;
    X1 = xVertex(1:NumVertex)';
    Y1 = yVertex(1:NumVertex)';
    X2 = xVertex(2:end)';
    Y2 = yVertex(2:end)';
    PolyGon1 = [X1 Y1];
    PolyGon2 = [X2 Y2];
    [n] = longestSide(PolyGon1,PolyGon2);                               % Ѱ�����
    [Alpha, offX, offY]= mySideRotate(PolyGon1, PolyGon2, n);           % ������ת��Ԫ
    [xVertex,yVertex] = myRotate(xVertex,yVertex,offX,offY,Alpha);      % ��ת����Σ�ʹ������Y��ƽ��
    [RouteX,RouteY,~] = autoGenRakeRouteV(xVertex,yVertex,HalfWidth);   % ·�߹滮
    [RouteX,RouteY] = myRotate(RouteX,RouteY,offX,offY,-Alpha);         % ��ת����Σ��ص���ʼλ��
end

% ����ߵ�λ��
function [n] = longestSide(PolyGon1,PolyGon2)
    Dist = distance(PolyGon1, PolyGon2);
    [~, n] = max(Dist);   % �ߵ�λ��
end

% ��ǰ���ߵ�б�ʣ��Լ�����n�ߵĵ�һ����x1 y1ΪԲ�ģ�Ӧ��ת�ĽǶȡ�
function [Alpha, x1, y1] = mySideRotate(PolyGon1, PolyGon2 ,n)
    x1 = PolyGon1(n,1);  % �ñߵ������˵�
    y1 = PolyGon1(n,2);
    x2 = PolyGon2(n,1);
    y2 = PolyGon2(n,2);
    if(n == 1)                % ����ε�������һ���㣨ȡ��һ�������㣩��
        x0 = PolyGon1(n+2,1);
        y0 = PolyGon1(n+2,2);
    else
        x0 = PolyGon1(1,1);
        y0 = PolyGon1(1,2);
    end
    A = y2 - y1;
    B = x1 - x2;
    C = x2*y1 - x1*y2;
    D = A*x0 + B*y0 + C;
    k = -A/B;
    Theta = atan(k)*180/pi;
    if(D<0)
        Alpha = -(90+Theta);
    else
        Alpha = 90-Theta;
    end
end