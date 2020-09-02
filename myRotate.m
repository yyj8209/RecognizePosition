function [XDisp0, YDisp0] = myRotate(XDisp,YDisp,offX,offY,Alpha)
% [XDisp0, YDisp0] = myRotate(XDisp,YDisp,offX,offY,Alpha)
% �ԣ�offX,offY��Ϊ���ģ���ʱ����ת Alpha��

    XDisp0 = (XDisp-offX)*cos(Alpha*pi/180) - (YDisp-offY)*sin(Alpha*pi/180) + offX;
    YDisp0 = (YDisp-offY)*cos(Alpha*pi/180) + (XDisp-offX)*sin(Alpha*pi/180) + offY;                     
end
        
