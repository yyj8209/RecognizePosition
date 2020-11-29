len = size(Data);
figure;
for i=1:len(2)
    hold on;
    if(mod(i,2))
        plot(Data{1,i});
    else
        plot(fliplr(Data{1,i}));
    end
%     plot(Data{4,i},Data{5,i});
    hold off;
    
end
legend;