function data = generate_data(data_type)
tspan = 0:0.01:10;

x10 = -1:0.1:1;
x20 = -1:0.1:1;
[X10,X20] = meshgrid(x10,x20);
initial_conditions  = [X10(:),X20(:)];
f = 1;
a = 1;

if strcmp(data_type,'train')
    data = [];
    plot_data = [];
    figure;
    for i=1:length(initial_conditions)
        x0 = initial_conditions(i,:)';
        [t,x] = ode45(@(t,x)dynamics_duffing(t,x, a, f, data_type), tspan, x0);
        [~,u]= dynamics_duffing(t,x,a,f,data_type);
        t = t(1:10:end-1,:);
        x_1 = x(1:10:end-1,:);
        x_2 = x(11:10:end,:);
        u = u(1:10:end-1,:);
        trajectory = [x_1,x_2,u];
        data = [data;trajectory];

        subplot(3,1,1)
        plot(t,x_1)
        xlabel('$t$','FontSize',14,'FontWeight','bold','Interpreter','latex');
        ylabel('$x_2$','FontSize',14,'FontWeight','bold','Interpreter','latex');
        hold on

        subplot(3,1,2)
        plot(t,x_1)
        xlabel('$t$','FontSize',14,'FontWeight','bold','Interpreter','latex');
        ylabel('$x_2$','FontSize',14,'FontWeight','bold','Interpreter','latex');
        hold on

        subplot(3,1,3)
        plot(t,u)
        xlabel('$t$','FontSize',14,'FontWeight','bold','Interpreter','latex');
        ylabel('$u$','FontSize',14,'FontWeight','bold','Interpreter','latex');
        hold on

    end
    hold off
    sgtitle('Training Data','FontSize',16,'FontWeight','bold')

elseif strcmp(data_type,'test')
    data = [];
    plot_data = [];
    figure;
    for i=1:length(initial_conditions)
        x0 = initial_conditions(i,:)';
        [t,x] = ode45(@(t,x)dynamics_duffing(t,x, a, f, data_type), tspan, x0);
        [~,u]= dynamics_duffing(t,x,a,f,data_type);
        t = t(1:10:end-1,:);
        x_1 = x(1:10:end-1,:);
        x_2 = x(11:10:end,:);
        u = u(1:10:end-1,:);
        trajectory = [x_1,x_2,u];
        data = [data,trajectory];

        subplot(3,1,1)
        plot(t,x_1)
        xlabel('$t$','FontSize',14,'FontWeight','bold','Interpreter','latex');
        ylabel('$x_2$','FontSize',14,'FontWeight','bold','Interpreter','latex');
        hold on

        subplot(3,1,2)
        plot(t,x_1)
        xlabel('$t$','FontSize',14,'FontWeight','bold','Interpreter','latex');
        ylabel('$x_2$','FontSize',14,'FontWeight','bold','Interpreter','latex');
        hold on

        subplot(3,1,3)
        plot(t,u)
        xlabel('$t$','FontSize',14,'FontWeight','bold','Interpreter','latex');
        ylabel('$u$','FontSize',14,'FontWeight','bold','Interpreter','latex');
        hold on

    end
    hold off
    sgtitle('Test Data','FontSize',16,'FontWeight','bold')
else
 error('Invalid Data Type')
end
end