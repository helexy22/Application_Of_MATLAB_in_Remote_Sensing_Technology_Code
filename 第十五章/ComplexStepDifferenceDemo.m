function ComplexStepDifferenceDemo()
F = @(x) exp(x)./((cos(x)).^3 + (sin(x)).^3);
ezplot(F,[-pi/4,pi/2])%显示函数局部和待求一阶微分处的点位置
axis([-pi/4,pi/2,0,6])
set(gca,'xtick',[-pi/4,0,pi/4,pi/2])
line([pi/4,pi/4],[F(pi/4),F(pi/4)],'marker','.','markersize',18)

tolNum = 16;%误差个数
Fpc = @(x,h) imag(F(x+i*h))./h;%复数微分法，存在误差
Fpd = @(x,h) (F(x+h) - F(x-h))./(2*h);%函数极限法，存在误差

format long
disp('           h             complex step     finite differerence');
h = (10.^(-(1:tolNum)))';
disp([h Fpc(pi/4,h) Fpd(pi/4,h)]);

%符号代数法，默认为真值
syms x
F = exp(x)/((cos(x))^3 + (sin(x))^3);
Fps = simple(diff(F));
exact = subs(Fps,pi/4);
flexact = double(exact);

%计算复数微分法、函数极限法与真值的差异
errs = zeros(tolNum,2);
errs(:,1) = abs(Fpc(pi/4,h)-exact);
errs(:,2) = abs(Fpd(pi/4,h)-exact);

%显示结果
figure;
%loglog(h,errs)
loglog(h,errs(:,1),'b-',h,errs(:,2),'r-.')
axis([eps 1 eps 1])
set(gca,'xdir','rev')
legend('complex step','finite difference','location','southwest')
xlabel('step size h')
ylabel('error')
end
