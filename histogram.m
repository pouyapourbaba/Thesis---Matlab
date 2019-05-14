function histogram(selecteds, data)
    figure;
    b = bar(1:64,selecteds);
    xlabel('Actions')
    ylabel('Number of selections')
    [~, max_index] = max(selecteds);
    b.FaceColor = 'flat';
    b.CData(max_index,:) = [.9 0.5 .13];
    
    % Find the second largest value in the selecteds vector
    sorted = sort(selecteds, 'descend');
    best_arm = sorted(1);
    best_index = find(selecteds == best_arm);
    second_arm = sorted(2);
	second_index = find(selecteds == second_arm);
    third_arm = sorted(3);
	third_index = find(selecteds == third_arm);

    best_arm = fitdist(data(:,best_index), 'Normal'); 
    other_arm1 = fitdist(data(:,second_index), 'Normal');
    other_arm2 = fitdist(data(:,third_index(1)), 'Normal');
    
    % Create and Plot the PDFs
    x_values = 0:0.0001:2;
    best_arm_pdf = pdf(best_arm,x_values);
    other_arm1_pdf = pdf(other_arm1,x_values);
    other_arm2_pdf = pdf(other_arm2,x_values);

    figure
    plot(x_values,best_arm_pdf,'LineWidth',2)
    hold on
    grid on
    plot(x_values,other_arm1_pdf,'Color','r','LineWidth',2)
    plot(x_values,other_arm2_pdf,'Color','g','LineWidth',2)
    legend(['best, std=',num2str(best_arm.sigma)],['second, std=',num2str(other_arm1.sigma)],['third, std=',num2str(other_arm2.sigma)])  
    hold off
    
    % Create and Plot the CDFs
    x_value_cdf = -3:0.01:3;
    best_arm_cdf = cdf(best_arm,x_values);
    other_arm1_cdf = cdf(other_arm1,x_values);
    other_arm2_cdf = cdf(other_arm2,x_values);
    figure
    plot(x_values,best_arm_cdf,'LineWidth',2)
    hold on
    grid on
    plot(x_values,other_arm1_cdf,'Color','r','LineWidth',2)
    plot(x_values,other_arm2_cdf,'Color','g','LineWidth',2)
%     legend(['best, std=',num2str(best_arm.sigma)],['second, std=',num2str(other_arm1.sigma)],['third, std=',num2str(other_arm2.sigma)])  
    hold off
end