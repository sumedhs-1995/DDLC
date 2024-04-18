function Koopman_validate(X_pred,X_actual,n_val, control_enabled)
dim =2;
tspan = 0:0.1:9.9;

Percent_error_x1 = [];
Percent_error_x2 = [];
for i=1:n_val
    x_1_pred = X_pred(:,dim*i-1);
    x_2_pred = X_pred(:,dim*i);
    x_1_actual = X_actual(:,dim*i-1);
    x_2_actual = X_actual(:,dim*i);

    error1 = mean(abs(x_1_actual - x_1_pred)./abs(x_1_actual));
    Percent_error_x1 = [Percent_error_x1;error1];

    error2 = mean(abs(x_2_actual - x_2_pred)./abs(x_2_actual));
    Percent_error_x2 = [Percent_error_x2;error2];

    figure;
    subplot(2,1,1)
    plot(tspan, x_1_pred, "Color",'blue',LineWidth=2)
    hold on
    plot(tspan, x_1_actual,"Color",'red',LineWidth=2)
    hold off
    xlabel('$t$','FontSize',14,'FontWeight','bold','Interpreter','latex');
    ylabel('$x_1$','FontSize',14,'FontWeight','bold','Interpreter','latex');
    legend('Predicted','Actual')

    subplot(2,1,2)
    plot(tspan, x_2_pred, "Color",'blue',LineWidth=2)
    hold on
    plot(tspan, x_2_actual,"Color",'red',LineWidth=2)
    hold off
    xlabel('$t$','FontSize',14,'FontWeight','bold','Interpreter','latex');
    ylabel('$x_2$','FontSize',14,'FontWeight','bold','Interpreter','latex');
    legend('Predicted','Actual')

    if strcmp(control_enabled,'true')
        control_status = 'Controlled Trajectory';
    else
        control_status = 'Without Control';
    end
    sgtitle(strcat('Actual vs Predicted: ',control_status),'FontSize',14,'FontWeight','bold')
end
Percent_error_x1 = mean(Percent_error_x1)
Percent_error_x2 = mean(Percent_error_x2)
end