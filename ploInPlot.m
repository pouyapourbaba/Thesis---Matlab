% x =  -pi:0.01:pi;
% y = 2*sin(12*x) + 3*cos(0.2*pi+2);
% plot(x,y, 'k');
% 
% p = get(gca, 'Position');
% h = axes('Parent', gcf, 'Position', [p(1)+.06 p(2)+.06 p(3)-.5 p(4)-.5]);
% 
% plot(h, x, y, 'r');
% set(h, 'Xlim', [-0.2 0], 'Ylim', [-5 -4]);
% set(h, 'XTick', [], 'YTick', []);


% r1 = [1:100]'.*rand(100,1);
% figure;
% a1 = axes();
% plot(a1,r1);
% a2 = axes();
% a2.Position = [0.300 0.600 0.2 0.2]; % xlocation, ylocation, xsize, ysize
% plot(a2,r1(50:70)); axis tight
% annotation('ellipse',[.2 .3 .2 .2])
% annotation('arrow',[.1 .2],[.1 .2])
% legend(a1,'u')

t = linspace(0,2*pi,1000); % values in time
x = cos(t); % a sinusoid
perturbation = 0.1*exp((-(t-5*pi/4).^2)/.01).*sin(200*t); % a perturbation
signal = x+perturbation; % a signal to plot
% plot signal on new figure
figure,plot(t,x+perturbation)
xlabel('time'),ylabel('signal')
% create a new pair of axes inside current figure
axes('position',[.65 .175 .25 .25])
box on % put box around new pair of axes
indexOfInterest = (t < 11*pi/8) & (t > 9*pi/8); % range of t near perturbation
plot(t(indexOfInterest),signal(indexOfInterest)) % plot on new axes
axis tight