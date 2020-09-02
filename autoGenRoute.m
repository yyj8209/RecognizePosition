function [RouteX,RouteY] = autoGenRoute(xVetex,yVetex,HalfWidth)
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明

    NumVetex = length(xVetex) - 1;
    X0 = mean(xVetex(2:end));
    Y0 = mean(yVetex(2:end));
    D = zeros(1,NumVetex);
    P0 = [X0,Y0];
    for i = 1:NumVetex
        P1 = [xVetex(i), yVetex(i)];
        P2 = [xVetex(i+1), yVetex(i+1)];
        D(i) = myDistance(P0,P1,P2);
    end
    d = max(D);
    N = 2*floor(d/HalfWidth);
    if(mod(d,HalfWidth)>HalfWidth/2)
        N = 2*ceil(d/HalfWidth);
    end
    N_i = 1:2:N;
    M = 20;
    RouteX = zeros(NumVetex,length(N_i));
    RouteY = RouteX;
    for i = 1:NumVetex
        X = linspace(xVetex(i),X0,M*N);
        Y = linspace(yVetex(i),Y0,M*N);
        RouteX(i,:) = X(M*N_i);
        RouteY(i,:) = Y(M*N_i);
    end
    RouteX = [RouteX; RouteX(1,:)];
    RouteY = [RouteY; RouteY(1,:)];
end

% 点到直线的距离公式
function D = myDistance(Point0, Point1, Point2)
    x0 = Point0(1);
    y0 = Point0(2);
    x1 = Point1(1);
    y1 = Point1(2);
    x2 = Point2(1);
    y2 = Point2(2);
    A = y2 - y1;
    B = x1 - x2;
    C = x2*y1 - x1*y2;
    D = abs(A*x0 + B*y0 + C)/sqrt(A^2+B^2);
end