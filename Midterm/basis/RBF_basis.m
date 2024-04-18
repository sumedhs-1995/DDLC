function Psi = RBF_basis(x, centers, RBF_params)
Psi = [];
scale = RBF_params.scale;
gamma_ = RBF_params.gamma_;
for i=1:length(centers)
    psi = [];
    center = centers(i,:);
    for j=1:size(x,1)
        distance= (norm(x(j,:) -center)^2);
        if (strcmp(RBF_params.function_type,'gaussian'))
            rbf = scale*exp(-gamma_*distance);
        else
            rbf = scale*distance*log(sqrt(distance));
        end
        psi = [psi, rbf];
    end
    Psi = [Psi;psi];
end
if strcmp(RBF_params.show_plot,'true')
    figure;
    plot(Psi)
    xlabel('$t$','FontSize',14,'FontWeight','bold','Interpreter','latex')
    ylabel('$\Psi (x)$','FontSize',14,'FontWeight','bold','Interpreter','latex');
    title('Basis Functions', 'FontSize',16,'FontWeight','bold')
    hold off
end

end