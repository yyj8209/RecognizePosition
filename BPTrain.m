function [E,w1,b1,w2,b2] = BPTrain(LOOPNUM,TRAINSAMPLE,inputn,w1,b1,w2,b2,output_train,THETA)
% ����ѵ��
<<<<<<< HEAD
% ��������NN Toolboxȡ��

=======
>>>>>>> 20200204 Last Main.mlapp
E   = zeros(1,LOOPNUM);
for loopi=1:LOOPNUM
    for i = 1:TRAINSAMPLE
       % ����Ԥ����� 
        x = inputn(:,i);
        % ���������
        I = x'*w1' + b1';
        Iout = 1./(1+exp(-I));
        I2 = w2'*Iout'+b2;
        yn = 1./(1+exp(-I2));
        
       % Ȩֵ��ֵ����
        %�������
        e = .5*sum((output_train(:,i) - yn).^2);     
%         E(loopi) = E(loopi) + std(e);
        E(loopi) = E(loopi) + e;
        
        %����Ȩֵ�仯��
        dw2 = e*Iout;
        db2 = e';
        FI  =Iout.*(1-Iout);

        db1 = FI.*(w2*e)';
        dw1 = x*db1;
        
        w1 = w1+THETA*dw1';
        b1 = b1+THETA*db1';
        w2 = w2+THETA*dw2';
        b2 = b2+THETA*db2';
    end
end