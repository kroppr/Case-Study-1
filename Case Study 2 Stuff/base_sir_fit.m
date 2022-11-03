data = load("COVIDdata.mat");
COVID_STLmetro = deal(data.COVID_STLmetro);
STLmetroPopFixed=27.3714*100000;

COVID_MO_array=table2array(COVID_STLmetro(:,5:6));
COVID_MO_proportion=COVID_MO_array/STLmetroPopFixed;

coviddata = COVID_MO_proportion; % TO SPECIFY
t = 798; % TO SPECIFY

% The following line creates an 'anonymous' function that will return the cost (i.e., the model fitting error) given a set
% of parameters.  There are some technical reasons for setting this up in this way.
% Feel free to peruse the MATLAB help at
% https://www.mathworks.com/help/optim/ug/fmincon.html
% and see the sectiono on 'passing extra arguments'
% Basically, 'sirafun' is being set as the function siroutput (which you
% will be designing) but with t and coviddata specified.
sirafun= @(x)siroutput(x,t,coviddata);

%% set up rate and initial condition constraints
% Set A and b to impose a parameter inequality constraint of the form A*x < b
% Note that this is imposed element-wise
% If you don't want such a constraint, keep these matrices empty.
A = [0 0 0 .99 .99 .99 .99];
b = [1];

%% set up some fixed constraints
% Set Af and bf to impose a parameter constraint of the form Af*x = bf
% Hint: For example, the sum of the initial conditions should be
% constrained
% If you don't want such a constraint, keep these matrices empty.
Af = [0 0 0 1 1 1 1];
bf = [1];

%% set up upper and lower bound constraints
% Set upper and lower bounds on the parameters
% lb < x < ub
% here, the inequality is imposed element-wise
% If you don't want such a constraint, keep these matrices empty.
ub = [1 1 1 1 1 1 1]';
lb = [0 0 0 0 0 0 0]';

% Specify some initial parameters for the optimizer to start from
x0 = [0 0 0 1 0 0 0]; 

% This is the key line that tries to opimize your model parameters in order to
% fit the data
% note tath you 
x = fmincon(sirafun,x0,A,b,Af,bf,lb,ub);

x_new_1 = x;
x_new_1(1)= 0.20*x(1);

x_new_2 = x;
x_new_2(2)= 0.04*x(2);
x_new_2(1)= 0.20*x(1);

%plot(Y);
%legend('S','I','R','D');
%xlabel('Time')

Y_fit = siroutput_full(x,t);
Y_fit_A = siroutput_full(x_new_1,365);

x_new_2(4) = Y_fit_A(365,1);
x_new_2(5) = Y_fit_A(365,2);
x_new_2(6) = Y_fit_A(365,3);
x_new_2(7) = Y_fit_A(365,4);

Y_fit_B = siroutput_full(x_new_2,t-365);

Y_fit_new=cat(1,Y_fit_A,Y_fit_B);

figure(1);
hold on
plot(COVID_MO_proportion(:,2));
plot(Y_fit(:,4));
legend('Actual Deaths','Modeled Deaths');
xlabel('Time')
title('Actual Deaths versus Modeled Deaths')

hold off

figure(2);
hold on
plot(COVID_MO_proportion(:,1));
plot(1-Y_fit(:,1));
legend('Actual Cases','Modeled Cases');
xlabel('Time')
title('Actual Cases versus Modeled Cases')
hold off

% Make some plots that illustrate your findings.
% TO ADD
figure(3);
hold on
plot(COVID_MO_proportion(:,1));
plot(1-Y_fit(:,1));
plot(1-Y_fit_new(:,1));
legend('Actual Cases','Modeled Cases', 'New Modeled Cases');
xlabel('Time')
title('Proportion of Population Infected')
hold off

figure(4);
hold on
plot(COVID_MO_proportion(:,2));
plot(Y_fit(:,4));
plot(Y_fit_new(:,4));
legend('Actual Deaths','Modeled Deaths', 'New Modeled Deaths');
xlabel('Time')
title('Proportion of Population Deceased')
hold off