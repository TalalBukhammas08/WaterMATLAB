clear all;
clc;
[X, Y] = meshgrid(1:1:128);
Z = zeros(size(X));
iterations = 60 * 10;
figure('units','normalized','outerposition',[0 0 1 1]);
% lightangle(-45,30)
% lighting gouraud;
hold on;
grid on;
daspect([1;1;1]);
%axis([0 256 0 256 0 100]);
set(gca, 'XLim', [0 128], 'YLim', [0 128], 'ZLim', [0 100]);
kx = 0.05;
ky = 0.05;
omega = 0.25/3;

xsi_r = randn(128, 128);
xsi_i = randn(128, 128);

xsi_r_2 = randn(128, 128);
xsi_i_2 = randn(128, 128);

view(28, 24);
for iteration=1:iterations
%     disp(['Iteration: ' num2str(iteration)]);
    colour = zeros(size(X));
    colour(:, :, 2) = zeros(size(X));
    colour(:, :, 3) = ones(size(X));

    [Z, Xdisp, Ydisp] = generatezdisplacements(xsi_r, xsi_i, xsi_r_2, xsi_i_2, iteration/120);
    [X, Y] = meshgrid(1:1:128);
     X = X + real(Xdisp)*0.25;
     Y = Y + real(Ydisp)*0.25;
    
    Zreal = real(Z);
    
    mesh1 = mesh(X, Y, Zreal,colour);
    F(iteration) = getframe(gcf);
    %pause(0.1);
    delete(mesh1);
end
hold off;

video = VideoWriter('Water.avi', 'Uncompressed AVI');
video.FrameRate = 60;
open(video);
writeVideo(video, F);
close(video);