function [output] = LatLon2Bytes(input)
% [output] = LatLon2Bytes(input)
% �ڴ��ڴ����У���/γ��ռ5���ֽڡ��˺�������ת����/�����ڵĸ�ʽ��
% inv = 1ʱ����ʾ��/γ��ת�ֽڣ�inv=2ʱ��ʾ5�ֽ�ת��/γ�ȣ�ͬʱ�е��ǶȺͰ뾶��ת������

% output =0;
% 
% switch inv
%     case 1
        output = ['00';'00';'00';'00';'00'];
        tmpDec = fix(input*1e9);  % С�����ƶ�9λ��ȡ��
        tmpHex = dec2hex(tmpDec);
        while(length(tmpHex)<10)
            tmpHex = ['0',tmpHex];
        end
%         for i = 1:5
%             output(i,:) = tmpHex(2*i-1:2*i);
%         end
        output(1,:) = tmpHex(9:10);
        output(2,:) = tmpHex(7:8);
        output(3,:) = tmpHex(5:6);
        output(4,:) = tmpHex(3:4);
        output(5,:) = tmpHex(1:2);
%  output =0;
%     case 2
%         tmpHex = ['00','00','00','00','00'];
% %         for i = 1:5
% %             tmpHex(2*i-1:2*i) = input(i,:);
% %         end
%         tmpHex(9:10) = input(1,:);
%         tmpHex(7:8) = input(2,:);
%         tmpHex(5:6) = input(3,:);
%         tmpHex(3:4) = input(4,:);
%         tmpHex(1:2) = input(5,:);
%         output = hex2dec(tmpHex)*1e-9;
%     otherwise
% end
