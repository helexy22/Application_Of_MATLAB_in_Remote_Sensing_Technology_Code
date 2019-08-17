function ComplexStepDifferenceDemo()
F = @(x) exp(x)./((cos(x)).^3 + (sin(x)).^3);
ezplot(F,[-pi/4,pi/2])%��ʾ�����ֲ��ʹ���һ��΢�ִ��ĵ�λ��
axis([-pi/4,pi/2,0,6])
set(gca,'xtick',[-pi/4,0,pi/4,pi/2])
line([pi/4,pi/4],[F(pi/4),F(pi/4)],'marker','.','markersize',18)

tolNum = 16;%������
Fpc = @(x,h) imag(F(x+i*h))./h;%����΢�ַ����������
Fpd = @(x,h) (F(x+h) - F(x-h))./(2*h);%�������޷����������

format long
disp('           h             complex step     finite differerence');
h = (10.^(-(1:tolNum)))';
disp([h Fpc(pi/4,h) Fpd(pi/4,h)]);

%���Ŵ�������Ĭ��Ϊ��ֵ
syms x
F = exp(x)/((cos(x))^3 + (sin(x))^3);
Fps = simple(diff(F));
exact = subs(Fps,pi/4);
flexact = double(exact);

%���㸴��΢�ַ����������޷�����ֵ�Ĳ���
errs = zeros(tolNum,2);
errs(:,1) = abs(Fpc(pi/4,h)-exact);
errs(:,2) = abs(Fpd(pi/4,h)-exact);

%��ʾ���
figure;
%loglog(h,errs)
loglog(h,errs(:,1),'b-',h,errs(:,2),'r-.')
axis([eps 1 eps 1])
set(gca,'xdir','rev')
legend('complex step','finite difference','location','southwest')
xlabel('step size h')
ylabel('error')
end
