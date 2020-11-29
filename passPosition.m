function [Order] = passPosition(Lon,Lat,AngleV,Step,OrderType,Radius,SequenceNumber,TotalNumber,x,y)
%[Order] = controlOrder(Lat,Lon,OrderType)
%   �˴���ʾ��ϸ˵��
% ���룺Lon��ʾ���ȣ�Lat��ʾγ�ȣ�OrderType��ʾ��������
% �����Order Ϊ��CRC16У��������

    HeadLen = 4;
    LonLen = 5;
    LatLen = 5;
    AngleVLen = 1;
    StepLen = 1;
    RadiusLen = 4;
    TypeLen = 1;
    SNLen = 1;
    TNLen = 1;
    ReservedLen1 = 2;
    ReservedLen2 = 2;
    R1 = HeadLen+1;
    R2 = LonLen+R1;
    R3 = LatLen+R2;
    R4 = AngleVLen+R3;
    R5 = StepLen+R4;
    R6 = RadiusLen+R5;
    R7 = TypeLen+R6;
    R8 = SNLen+R7;
    R9 = TNLen+R8;
    R10 = ReservedLen1+R9;
    R11 = ReservedLen2+R10;

% ���������ʽ����ο�Э�顣
    InitialOrder = ['55';'AA';'02';'1D';...    % �ֽ�ͷ
        '00';'00';'00';'00';'00';...           % ����
        '00';'00';'00';'00';'00';...           % γ��
        '00';'00';'00';'00';'00';'00';...      % ���ٶ�1������1���뾶4
        '00';'00';'00';...                     % �������͡��������/����
        '00';'00';'00';'00'];                  % ����4 .
    
    InitialOrder(R1:R2-1,:) = Lon;
    InitialOrder(R2:R3-1,:) = Lat;
    InitialOrder(R3:R4-1,:) = AngleV;
    InitialOrder(R4:R5-1,:) = Step;
    InitialOrder(R5:R6-1,:) = Radius;
    InitialOrder(R6,:) = OrderType;
    InitialOrder(R7,:) = SequenceNumber;
    InitialOrder(R8,:) = TotalNumber;
    InitialOrder(R9:R10-1,:) = x;
    InitialOrder(R10:R11-1,:) = y;
    
    [Order,~] = CRC16_MODBUS(hex2dec(InitialOrder));
    Order = hex2dec(Order);
end


