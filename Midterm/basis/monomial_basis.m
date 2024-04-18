function Psi = monomial_basis(x, deg)
x1 = x(:,1)
x2 = x(:,2)
[exponents1, exponents2] = meshgrid(1:deg)
exponents = [exponents1(:),exponents2(:)];
Psi = ((x1.^(exponents(:,1)')).*(x2.^(exponents(:,2)')))'
end