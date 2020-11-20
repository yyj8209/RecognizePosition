function [LatA,LonA,Angle,Status] = readDataFromCom2(data,DeltaLatA,DeltaLatB,FrameLength)
% [Lat,Lon,Angle,Status] = readDataFromCom2(data)
% ���룺data Ϊ��COM2��ȡ�����ݣ�FrameLength Ϊÿһ��Э��֡�ĳ��ȡ�
% �����LatA ������γ��,LonA Ϊ�����ľ���,Angle Ϊ���صĵ�ǰ��ǰ�����Ƕȣ�Ӧ���Ǻ���ǣ�,
% Status Ϊ�Զ�̽ɨʱ�������˷��ص�״̬ 00���޶�����01������̽ɨ������02������̽ɨֹͣ��03������̽ɨ������

Lat = [];
Lon = [];
Angle = [];
Status = [];
HeadLen = 4;
LonLen = 5;
LatLen = 5;
AngleLen = 4;
% StatursLen = 1;
% ReservedLen = 4;
R1 = HeadLen+1;
R2 = LonLen+R1;
R3 = LatLen+R2;
R4 = AngleLen+R3;
% R5 = StatursLen+R4;
% R6 = ReservedLen+R5;

HexData = dec2hex(data);
len = length(data);
HexRow = [];
for i=1:len
    HexRow = strcat(HexRow,HexData(i,:));   % һ��������
end
 
Index = strfind(HexRow,'55AA0319');   % ����ͷ
for k = 1:length(Index)
    if(len*2<Index(k)+FrameLength*2-1)
        continue;
    end
    c = HexRow(Index(k):Index(k)+FrameLength*2-1);   
    HexColumn = [];
    for i = 1:FrameLength
        HexColumn = vertcat(HexColumn,c(2*i-1:2*i));     % 
    end
    DecColumn = hex2dec(HexColumn);
    DecLen = length(DecColumn);
    [~,CRC16] = CRC16_MODBUS(DecColumn(1:DecLen-2));
    if(~strcmp(CRC16,HexColumn(DecLen-1:DecLen,:)))
        continue;
    end

    LonO = [Lon;LatLon2Double(HexColumn(R1:R2-1,:))];% �ش�������ΪO�����ꡣ
    LatO = [Lat;LatLon2Double(HexColumn(R2:R3-1,:))];
    Angle = [Angle;AngleTransform(HexColumn(R3:R4-1,:),2)];
    Status = [Status;hex2dec(HexColumn(R4,:))];

%     [LonO,LatO] = myRotate(LonC,LatC+DeltaLatA,LonC,LatC,-Angle(end));  % �Ѷ�λ���ߵ����껻��Ϊ����������꣨O�㣩
    [LonA,LatA] = myRotate(LonO,LatO+DeltaLatB,LonO,LatO,270-Angle(end));  % ����Ϊ����ҡ�۹̶����������꣨A�㣩
end
