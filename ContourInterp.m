function [XDisp,YDisp,ZDisp] = ContourInterp(X,Y,Z)
    [m,n] = size(X);
    TIMES = 2;
    M = m*TIMES;      % ×ÝÏò²åÖµ
    x_TIMES = zeros(M,n);
    y_TIMES = zeros(M,n);
    z_TIMES = zeros(M,n,3);
    for i = 1:n
        y_TIMES(:,i) = interp(Y(:,i),TIMES);
        x_TIMES(:,i) = interp(X(:,i),TIMES);
        z_TIMES(:,i,1) = interp1(Y(:,i),Z(:,i,1),y_TIMES(:,i));
        z_TIMES(:,i,2) = interp1(Y(:,i),Z(:,i,2),y_TIMES(:,i));
        z_TIMES(:,i,3) = interp1(Y(:,i),Z(:,i,3),y_TIMES(:,i));
    end
    XDisp = x_TIMES;
    YDisp = y_TIMES;
    ZDisp = z_TIMES;
    
%     
%     ZDisp = zeros(m,n,3);
%     Len = m*n;
%     x = reshape(X',1,Len);
%     y = reshape(Y',1,Len);
%     xi = linspace(xMin,xMax,n)';
%     yi = linspace(yMin,yMax,Len*2);
%     z = reshape(Z(:,:,1)',1,Len);
%     [XDisp,YDisp,ZDisp(:,:,1)]=griddata(x,y,z,xi,yi,'linear');
%     z = reshape(Z(:,:,2)',1,Len);
%     [~,~,ZDisp(:,:,2)]=griddata(x,y,z,xi,yi,'linear');
%     z = reshape(Z(:,:,3)',1,Len);
%     [~,~,ZDisp(:,:,3)]=griddata(x,y,z,xi,yi,'linear');
end