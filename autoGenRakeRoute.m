function [RouteX,RouteY] = autoGenRakeRoute(xVertex,yVertex,HalfWidth)
% [RouteX,RouteY] = autoGenRakeRoute(xVertex,yVertex,HalfWidth)
% 生成旋引形的探扫路径。
% 与最长边平行的方向行走。
% 步骤：
% 1、找出最长的边；
% 2、以最长边的一端为顶点，旋转到与Y轴平行；
% 3、计算旋转角度及新顶点位置；
% 4、调用autoGenRakeRouteV函数生成弓形路径的途经点；
% 5、根据第3步计算的角度，反向旋转，生成新的途经点坐标。

    NumVertex = length(xVertex) - 1;
    X1 = xVertex(1:NumVertex)';
    Y1 = yVertex(1:NumVertex)';
    X2 = xVertex(2:end)';
    Y2 = yVertex(2:end)';
    PolyGon1 = [X1 Y1];
    PolyGon2 = [X2 Y2];
    [n] = longestSide(PolyGon1,PolyGon2);                               % 寻找最长边
    [Alpha, offX, offY]= mySideRotate(PolyGon1, PolyGon2, n);           % 计算旋转诸元
    [xVertex,yVertex] = myRotate(xVertex,yVertex,offX,offY,Alpha);      % 旋转多边形，使长边与Y轴平行
    [RouteX,RouteY,~] = autoGenRakeRouteV(xVertex,yVertex,HalfWidth);   % 路线规划
    [RouteX,RouteY] = myRotate(RouteX,RouteY,offX,offY,-Alpha);         % 旋转多边形，回到初始位置
end

% 求最长边的位置
function [n] = longestSide(PolyGon1,PolyGon2)
    Dist = distance(PolyGon1, PolyGon2);
    [~, n] = max(Dist);   % 边的位置
end

% 当前曲线的斜率，以及（以n边的第一个点x1 y1为圆心）应旋转的角度。
function [Alpha, x1, y1] = mySideRotate(PolyGon1, PolyGon2 ,n)
    x1 = PolyGon1(n,1);  % 该边的两个端点
    y1 = PolyGon1(n,2);
    x2 = PolyGon2(n,1);
    y2 = PolyGon2(n,2);
    if(n == 1)                % 多边形的其他任一顶点（取第一点或第三点）。
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