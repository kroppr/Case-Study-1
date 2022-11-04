
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


%Segments to focus on:
%0-100, 101-250, 251-350, 351-500, 500-650, 651-700, 701-end

%Model section for segment 1
segment_1 = coviddata(1:100,:);
fun1= @(x)siroutput(x,100,segment_1);
x1 = fmincon(fun1,x0,A,b,Af,bf,lb,ub);
Y_fit_1 = siroutput_full(x1, 100);

%determine new parameters for next segment
New1(1) = Y_fit_1(100, 1);
New1(2) = Y_fit_1(100, 2);
New1(3) = Y_fit_1(100, 3);
New1(4) = Y_fit_1(100, 4);

%model section for segment 2 using new parameters
segment_2 = coviddata(101:250, :);
fun2= @(x)siroutput(x,150,segment_2);
params2 = [0 0 0 New1(1) New1(2) New1(3) New1(4)];
x2 = fmincon(fun2, params2, A, b, Af, bf, lb, ub);
Y_fit_2 = siroutput_full(x2, 150);

segment_3 = coviddata(251:350,:);
fun3= @(x)siroutput(x,100,segment_3);

segment_4 = coviddata(351:500,:);
fun4= @(x)siroutput(x,150,segment_4);

segment_5 = coviddata(501:650,:);
fun5= @(x)siroutput(x,150,segment_5);

segment_6 = coviddata(651:700,:);
fun6= @(x)siroutput(x,50,segment_6);

segment_7 = coviddata(701:798,:);
fun7= @(x)siroutput(x,t-700,segment_7);


%% SEGMENTS OF BASE MODEL

%Adjust first segment of pandemic
x_new_1 = x;
%Adjust infection rate
x_new_1(1)= x(1);
%Adjust fatality rate
x_new_1(2) = x(2);

%adjust second segment of pandemic
x_new_2 = x;
%Adjust Infection Rate
x_new_2(1)= x(1);
%Adjust fatalities
x_new_2(2)= x(2);

%adjust 3rd segment of pandemic
x_new_3 = x;
%Adjust Infection Rate
x_new_3(1)= x(1);
%Adjust fatalities
x_new_3(2)= x(2);

%adjust 4th segment of pandemic
x_new_4 = x;
%Adjust Infection Rate
x_new_4(1)= x(1);
%Adjust fatalities
x_new_4(2)= x(2);

%adjust 5th segment of pandemic
x_new_5 = x;
%Adjust Infection Rate
x_new_5(1)= x(1);
%Adjust fatalities
x_new_5(2)= x(2);

%adjust 6th segment of pandemic
x_new_6 = x;
%Adjust Infection Rate
x_new_6(1)= x(1);
%Adjust fatalities
x_new_6(2)= x(2);

%adjust 7th segment of pandemic
x_new_7 = x;
%Adjust Infection Rate
x_new_7(1)= x(1);
%Adjust fatalities
x_new_7(2)= x(2);

%plot(Y);
%legend('S','I','R','D');
%xlabel('Time')

%Full data model without segmenting (No touchy!)
Y_fit = siroutput_full(x,t);

%Segment out portions of data
Y_fit_A = siroutput_full(x_new_1,100);
x_new_2(4) = Y_fit_A(100,1);
x_new_2(5) = Y_fit_A(100,2);
x_new_2(6) = Y_fit_A(100,3);
x_new_2(7) = Y_fit_A(100,4);

Y_fit_B = siroutput_full(x_new_2,150);
x_new_3(4) = Y_fit_B(150,1);
x_new_3(5) = Y_fit_B(150,2);
x_new_3(6) = Y_fit_B(150,3);
x_new_3(7) = Y_fit_B(150,4);

Y_fit_C = siroutput_full(x_new_3,100);
x_new_4(4) = Y_fit_C(100,1);
x_new_4(5) = Y_fit_C(100,2);
x_new_4(6) = Y_fit_C(100,3);
x_new_4(7) = Y_fit_C(100,4);

Y_fit_D = siroutput_full(x_new_4,150);
x_new_5(4) = Y_fit_D(150,1);
x_new_5(5) = Y_fit_D(150,2);
x_new_5(6) = Y_fit_D(150,3);
x_new_5(7) = Y_fit_D(150,4);

Y_fit_E = siroutput_full(x_new_5,150);
x_new_6(4) = Y_fit_E(150,1);
x_new_6(5) = Y_fit_E(150,2);
x_new_6(6) = Y_fit_E(150,3);
x_new_6(7) = Y_fit_E(150,4);

Y_fit_F = siroutput_full(x_new_6,50);
x_new_7(4) = Y_fit_F(50,1);
x_new_7(5) = Y_fit_F(50,2);
x_new_7(6) = Y_fit_F(50,3);
x_new_7(7) = Y_fit_F(50,4);

Y_fit_G = siroutput_full(x_new_7,t-700);

Y_fit_new = cat(1, Y_fit_A, Y_fit_B, Y_fit_C, Y_fit_D, Y_fit_E, Y_fit_F, Y_fit_G);

%Y_fit_B = siroutput_full(x_new_2,t-365);

%Y_fit_new=cat(1,Y_fit_A,Y_fit_B);

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