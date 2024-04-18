function centers = get_centers(data, RBF_params)
% Find Domain Boundaries of Data
data_min = min(data,[],1);
data_max = max(data,[],1);
N_centers = RBF_params.N_centers;
dim = size(data,2);

if (strcmp(RBF_params.sampling_type,'random'))
    centers = data_min + (data_max - data_min).*(rand(N_centers, size(data,2)));
    if dim == 3
        C1 = centers(:,1);
        C2 = centers(:,2);
        C3 = centers(:,3);
    elseif  dim==2
        C1 = centers(:,1);
        C2 = centers(:,2);
    end

else
    grid_size = round(N_centers^(1/size(data,2)));
    if grid_size < 3
        grid_size = grid_size + mod(3,grid_size);
    end
    if dim==3
        x1 = linspace(data_min(1), data_max(1), grid_size);
        x2 = linspace(data_min(2), data_max(2), grid_size);
        x3 = linspace(data_min(3), data_max(3), grid_size);
        [C1,C2,C3] =meshgrid(x1, x2,x3);
        C1 = C1(:);
        C2 = C2(:);
        C3 = C3(:);
        centers = [C1,C2,C3];
        r1 = linspace(data_min(1), data_max(1), 2);
        r2 = linspace(data_min(2), data_max(2), 2);
        r3 = linspace(data_min(3), data_max(3), 2);
        
        [R1,R2,R3] = meshgrid(r1,r2,r3);
        R1 = R1(:);
        R2 = R2(:);
        R3 = R3(:);
    elseif dim ==2
        x1 = linspace(data_min(1), data_max(1), grid_size);
        x2 = linspace(data_min(2), data_max(2), grid_size);
        [C1,C2] =meshgrid(x1, x2);
        C1 = C1(:);
        C2 = C2(:);
        centers = [C1,C2];
        r1 = linspace(data_min(1), data_max(1), 2);
        r2 = linspace(data_min(2), data_max(2), 2);
        
        [R1,R2] = meshgrid(r1,r2);
        R1 = R1(:);
        R2 = R2(:);
    end


    if length(centers) > N_centers
        indices = 1:length(centers);
        idx = randsample(indices,N_centers);
        centers = centers(idx,:);
    end
end
        
if dim ==3
    figure;
    scatter3(R1,R2,R3,50,'red','filled','LineWidth',2)
    hold on
    scatter3(C1,C2,C3,10,'blue','filled','LineWidth',2)
    hold off
    xlabel('x_1','FontSize',11,'Interpreter','latex');
    ylabel('x_2','FontSize',11,'Interpreter','latex');
    zlabel('x_3','FontSize',11,'Interpreter','latex');
    title('RBF Centers','FontSize',11)
elseif dim==2
    figure;
    % scatter(R1,R2,50,'red','LineWidth',2)
    hold on
    scatter(C1,C2,10,'blue','filled','LineWidth',2)
    hold off
    xlabel('x_1','FontSize',11,'Interpreter','latex');
    ylabel('x_2','FontSize',11,'Interpreter','latex');
    title('RBF Centers','FontSize',11)
end