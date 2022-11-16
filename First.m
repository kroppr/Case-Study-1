load ("lightField.mat");

%% Sample Plot
d = 0.1;
M = [1 d 0 0;
     0 1 0 0;
     0 0 1 d;
     0 0 0 1];

rays_in0 = [0 0 0 0 0;
           10 5 0 -5 -10;
           0 0 0 0 0;
           10 5 0 -5 -10];
rays_out0 = M*rays_in0;
rays_in10 = [10 10 10 10 10;
           10 5 0 -5 -10;
           10 10 10 10 10;
           10 5 0 -5 -10];
rays_out10 = M*rays_in10;
ray_z = [zeros(1,size(rays_in0,2)); d*ones(1,size(rays_in0,2))];

figure(1)
plot(ray_z, [rays_in0(1,:); rays_out0(1,:)], Color="r");
hold on;
plot(ray_z, [rays_in10(1,:); rays_out10(1,:)], Color="b");
hold off;

%% Light Field
img = rays2img(rays(1,:),rays(3,:),0.008,200);
figure(2);
hold on;
image(img);
colormap ("gray")
hold off;

new = M*rays;
img = rays2img(new(1,:),new(3,:),0.008,200);
figure(3);
hold on;
image(img);
colormap ("gray")
hold off;


%% Focus

d1 = 2;
d2 = 4;
f = 0.05;

M1= [1 d1 0 0;
     0 1 0 0;
     0 0 1 d1;
     0 0 0 1];
M2= [1 d2 0 0;
     0 1 0 0;
     0 0 1 d2;
     0 0 0 1];
Mf= [1 0 0 0;
     -1/f 1 0 0;
     0 0 1 0;
     0 0 -1/f 1];

rays_in0 = [0 0 0 0 0;
           10 5 0 -5 -10;
           0 0 0 0 0;
           10 5 0 -5 -10];
rays_out10 = M1*rays_in0;

rays_out20 = Mf*rays_out10;

rays_in1 = [10 10 10 10 10;
           10 5 0 -5 -10;
           10 10 10 10 10;
           10 5 0 -5 -10];
rays_out11 = M1*rays_in0;

rays_out21 = Mf*rays_out11;

rays_out10 = cat(2,rays_out10, rays_out11);
rays_out20 = cat(2,rays_out20, rays_out21);
ray_z = [zeros(1,size(rays_in10,2)); d*ones(1,size(rays_in10,2))];

figure(4)
plot(ray_z, [rays_in0(1,:); rays_out10(1,:)], Color="r");
hold on;
plot(ray_z, [rays_in10(1,:); rays_out11(1,:)], Color="b");
hold off;

