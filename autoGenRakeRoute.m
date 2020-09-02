function [RouteX,RouteY] = autoGenRakeRoute(xVertex,yVertex,Width)
% [RouteX,RouteY] = autoGenRakeRoute(xVertex,yVertex,Width)
% 生成耙形的探扫路径。
%   此处显示详细说明

    % 解算多边形各边的方程。
    NumVertex = length(xVertex) - 1;
    M = 100;
    LineX = zeros(NumVertex,M);
    LineY = zeros(NumVertex,M);
    for i = 1:NumVertex
        LineX(i,:) = linspace(xVertex(i),xVertex(i+1),M);
        LineY(i,:) = linspace(yVertex(i),yVertex(i+1),M);
    end
    
    % 平行于Y轴的等距离直线与多边形的交点，存为矩形顶点。
    Xmin = min(xVertex);
    Xmax = max(xVertex);
    X_i = Xmin:Width:Xmax;
    NumRectangle = length(X_i);
%     yValue = zeros(1,2); 
    for i = 1:NumRectangle
        Rect(i).Xleft = X_i(i);    % 横坐标（左）
        Rect(i).Xright = X_i(i)+Width;    % 横坐标（右）
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
    