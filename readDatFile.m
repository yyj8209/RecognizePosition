%  SavePath = characteristicValue
% CHMean ��ÿ��ͨ���ı�׼ֵ ��
% ��ȡ����ֵ��
% clear;

    % % ѡ�������ļ�·��
    FolderName = uigetdir('..\OriginDat','��ѡ�������ļ�·����');   
    % FolderName = 'E:\matlab\OriginDat\20190305';    % ����ʱ�����Ĭ��·����
    A = dir(fullfile(FolderName,'*.dat'));
    % %�б�ѡ��Ի���
    AllFileNames = cell(size(A));
    for i=1:size(A,1)
        AllFileNames{i,1} = A(i,1).name;
    end
    [Sel,Ok]=listdlg('liststring',AllFileNames,...
        'listsize',[360 480],'OkString','ȷ��','CancelString','ȡ��',...
        'promptstring','��ѡ�������ļ�','name','��ѡ�������ļ�����ѡ��',...
        'selectionmode','multiple');
    if(Ok == 0)
        msgbox('��ȡ����ѡ���ļ���');
        return;
    end
    FileName = A(Sel,1);
    FullName = A(Sel,1);
    FileNumSel = size(FileName,1);
    for k=1:FileNumSel
        FullName(k,1).name = strcat(FolderName,'\', FileName(k,1).name);
    end

    % ----------------- ��ÿ�������ļ�������¼������----------------- %
    % 1����ȡǰ���У���������Чͨ�������ݣ�
    % 2����ȡÿ��ͨ���ĵ�һ����ֵ��������ֵ�ͷ��
    % 3����������������������������б�ʣ���б�ʱȡ������ȣ�
    % 4������Ŀ��ʶ�𣬲������ݱ��浽Excel���
    % ----------------------------------------------------------------- %
%     Fpass = 1;   Fstop = 5;  fs = 100; rpL = 1; rsL = 60;
%     [bL,~] = LPFDesign(Fpass,Fstop,fs,rpL,rsL);
    load('.\Settings\LPFParameter.mat');     % �����˲���ϵ����
    ButtonName = questdlg('�Ƿ���Ҫ��ѡ�е��ļ���ͼ?', ...
                             '�Ƿ���Ҫ��ÿ���ļ���ͼ?������Ҫ�ȴ������ӡ�', '��', '��', '��');
    if(ButtonName =='��')    % ��ȷ����ť�������
        figure;
    end


    for i = 1:FileNumSel
    % 1����ȡǰ���У���������Чͨ�������ݣ�
    % ----------------------------------------------------------------- %
        fid = fopen(FullName(i,1).name);
        fseek(fid,0,'eof');
        filelength = ftell(fid);
        fseek(fid,0,'bof');
        [A,count]=fread(fid,(filelength)/4,'float32');
        fclose(fid);
        A = reshape(A,6,count/6);
        x = ([A(1,:);A(2,:);A(3,:)])*5000/32768;

    % 2����ȡ'ͨ��1��ֵV1','ͨ��2��ֵV2','ͨ��3��ֵV3','Kr=б��1/б��2','V1/V3','��ֵEV1','EV2','����DV1','DV2'��
    % ----------------------------------------------------------------- %
    %     m = mean(x(:,20:150),2);
        y = zeros(size(x));
        Sign = 1;
        for k1 = 3:-1:1     % x ��3��ͨ��������������ɡ�
            x1 = x(k1,:);
            % ����һ��ȥ������ĺ������ٶ����ֻ��һ�����壩������˼·�ǣ���Ծ����500ʱ��ȷ���õ�Ϊ���壬ȥ��֮��2019.03.19
            [loc] = find(abs(diff(x1))>200);   % 
            if(~isempty(loc))     % ����ȥ����㡣���ж��������find������
                x1(loc+1) = x1(loc+3);
            end
            x2 = x1 - mean(x1);      % ȥֱ����

            y1 = [zeros(1,length(bL)),x2,zeros(1,length(bL))];    % �˲������źŵ���β�������䣬���ü����ݷ�������
            y2 = filtfilt(bL,1,y1);                               % ���е�ͨ�˲�
            y3 = y2(length(bL)+1:length(y2)-length(bL));
            y(k1,:) = y3 - mean(y3) + mean(x1);    % ����һ���Ѿ��ָ����źš�

            [Value] = find(y(k1,:) >  mean(x1));
            if(length(Value)>0.5*length(y(k1,:)))
                Sign = -1;    % �ȵ���״����Ҫ��ת�����ֵ��
            end

        end
        % ��ͨ��1�����ֵ�㣬ȷ��Ϊ�о��õĵ㡣

        % -----------------��ͼ ----------------- %
        if(ButtonName =='��')    % ��ȷ����ť�������
            plot([x',y']);
            legend('ͨ��1','ͨ��2','ͨ��3','�˲�1','�˲�2','�˲�3','Location','NorthWest');
            title(['�����ļ���', FileName(k,1).name]);
            grid on;
    %         saveas(gcf,['.\PIC\����0411\',FileStr],'png');
            saveas(gcf,['.\PIC4UI\', FileName(k,1).name],'png');
    %         text([lsor(1),lsor(1),lsor(1)],[psor(1)+m(1),psor(2)+m(2),psor(3)+m(3)],{'1','2','3'});
        end
    end
    close all;


% ================================ ���Ӽ������� ============================== %

