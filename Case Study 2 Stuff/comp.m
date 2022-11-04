%% Load data and plot

data = load("mockdata_v2.mat");
infected = transpose(deal(data.InfectedProportion));    % Turn these from rows to columns
deaths = transpose(deal(data.cumulativeDeaths));
data = [infected deaths];

figure(1);
hold on;
plot(deaths);                                   % Plot actual data
plot(infected);


%% Setup

A = [0 0 0 .99 .99 .99 .99];
b = 1;
Af = [0 0 0 1 1 1 1];                           % Copied from base_sir_fit. Don't think parameters causing issue.
bf = 1;
ub = [1 1 1 1 1 1 1]';
lb = [0 0 0 0 0 0 0]';

%% First Segment: Days 1-100
t = 100;

x0 = [0 0 0 .998 .001 0 .001];                  % Set x0 to day 1 percentages, roughly. Don't think this is necessary
sirafun= @(x)siroutput(x,t,data(1:100,:));      % Function to optimize over first 100 days
x = fmincon(sirafun,x0,A,b,Af,bf,lb,ub);        % Optimize it

x_next1 = x;                                    % First 'x' is good to plug into siroutput_full
Y_fit_1 = siroutput_full(x_next1,t);            % Get the fit

% In this segment and the others, copied Matt's procedure to generate the best
% fit.

%% Second Segment
t = 25;                                         % Now getting next 25 days, where first "spike" rises.

x0 = [0 0 0 .956 .004 0 0.04];                  % Day 100 percentages. Again, pretty sure this unecessary.
sirafun= @(x)siroutput(x,t,data(101:125,:));    % New function for next 25 days
x = fmincon(sirafun,x0,A,b,Af,bf,lb,ub);        % Optimize this segment

x_next2 = x;                                    % Get k values from optimized x
x_next2(4) = Y_fit_1(100,1);                    % Set ic values so they plot is continuous
x_next2(5) = Y_fit_1(100,2);
x_next2(6) = Y_fit_1(100,3);
x_next2(7) = Y_fit_1(100,4);
Y_fit_2 = siroutput_full(x_next2,t);            % Get the fit

%% Third Segment
t = 50;                                         % Next 50 days: descent from peak

x0 = [0 0 0 .93 .02 0 .05];
sirafun= @(x)siroutput(x,t,data(126:175,:));
x = fmincon(sirafun,x0,A,b,Af,bf,lb,ub);

x_next3 = x;
x_next3(4) = Y_fit_2(25,1);
x_next3(5) = Y_fit_2(25,2);                     % This stuff all same as second segment
x_next3(6) = Y_fit_2(25,3);
x_next3(7) = Y_fit_2(25,4);
Y_fit_3 = siroutput_full(x_next3,t);

Y_fit = cat(1,Y_fit_1,Y_fit_2,Y_fit_3);         % Put 3 fits together

plot(Y_fit(:,2));                               % Plot the stuff
plot(Y_fit(:,4));
legend('deaths','infected','minfections','mdeaths');
title('Plot with first three segment fits')
hold off;


%% Copy base_sir_fit--still gives bad fit

t = 365;

figure(2);
hold on;
plot(deaths);                                   % Plot actual data
plot(infected);

sirafun= @(x)siroutput(x,t,data);

A = [0 0 0 .99 .99 .99 .99];
b = 1;
Af = [0 0 0 1 1 1 1];
bf = 1;
ub = [1 1 1 1 1 1 1]';
lb = [0 0 0 0 0 0 0]';

x0 = [0 0 0 1 0 0 0]; 

x = fmincon(sirafun,x0,A,b,Af,bf,lb,ub);
Y_fit = siroutput_full(x,t);

plot(infected);
plot(Y_fit(:,2));
plot(deaths);
plot(Y_fit(:,4));

title('Plot with model format copied from base sir fit')
hold off;
