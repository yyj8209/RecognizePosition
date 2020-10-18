function [RouteX,RouteY,Rect] = autoGenRakeRouteV(xVertex,yVertex,Width)
% [RouteX,RouteY,Rect] = autoGenRakeRouteV(xVertex,yVertex,Width)
% ���룺xVertex,yVertexΪ����ζ������꣬WidthΪ̽ɨ��ȡ�
% ���ɰ��ε�̽ɨ·��RouteX,RouteY��
% ����������εĶ��� Rect��
%   �ϱ���������

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
    RouteX = zeros(NumRectangle,2);    % ÿ�������������յ㡣
    RouteY = zeros(NumRectangle,2);
    
    yCross = zeros(NumRectangle-1,2); 
    for i = 1:NumRectangle-1
        Rect(i).Xleft = X_i(i);    % �����꣨��
        Rect(i).Xright = X_i(i)+Width;    % �����꣨�ң�
        n = 1;
        for k = 1:NumVertex
            if(abs(LineX(k,1)-LineX(k,end))<1e-3)
                y = mean(LineY(k,:));
            else
                y = interp1(LineX(k,:),LineY(k,:),X_i(i+1));
            end
            if(~isnan(y))
                yCross(i,n) = y;
                n = n + 1;
            end
        end
        Rect(i).Ytop = max(yCross(i,:));
        Rect(i).Ybottom = min(yCross(i,:));
        if(i>1)
            Rect(i).Ybottom = min(min(yCross(i-1:i,:)));
            Rect(i).Ytop = max(max(yCross(i-1:i,:)));
        end
    end
    Rect(NumRectangle).Xleft = X_i(NumRectangle);    % �����꣨��
    Rect(NumRectangle).Xright = X_i(NumRectangle)+Width;    % �����꣨�ң�
    Rect(NumRectangle).Ytop = max(yCross(i,:));
    Rect(NumRectangle).Ybottom = min(yCross(i,:));
    
    Des = true;
    LastY = 0;
    for i = 1:NumRectangle-1
        x1 = Rect(i).Xleft+Width/2;
        x2 = Rect(i).Xleft+Width/2;

        if(Des)
            y1 = Rect(i).Ybottom;
            y2 = Rect(i).Ytop;
            LastY =  min(yCross(i,:));
        else
            y2 = Rect(i).Ybottom;
            y1 = Rect(i).Ytop;
            LastY =  max(yCross(i,:));
        end
%         if(Des)
%             y1 = min(Rect(i).Ybottom, Rect(i+1).Ybottom);
%             y2 = max(Rect(i).Ytop, Rect(i+1).Ytop);
%         else
%             y2 = min(Rect(i).Ybottom, Rect(i+1).Ybottom);
%             y1 = max(Rect(i).Ytop, Rect(i+1).Ytop);
%         end
        Des = ~Des;
        RouteX(i,:) = [x1,x2];
        RouteY(i,:) = [y1,y2];
    end
    RouteX(NumRectangle,:) = [x1,x2] + Width;
    RouteY(NumRectangle,:) = [y2,LastY];

    RouteY(2:NumRectangle,1) = RouteY(1:NumRectangle-1,2);
end