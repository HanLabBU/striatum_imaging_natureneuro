function plotMousePath(speed,phi,rot, tvals)
rot = [0; rot(1:end-1)];
dt = tvals(2)-tvals(1);
dir_in_maze = wrapTo2Pi(rot*dt+phi*dt);
xvals = cumsum(speed.*cos(dir_in_maze)*dt);
yvals = cumsum(speed.*sin(dir_in_maze)*dt);

if nargin > 3
    plot3(xvals,yvals,tvals);
    xlabel('X position [cm]');
    ylabel('Y position [cm]');
    zlabel('Time [s]');
else
    plot(xvals,yvals);
    xlabel('X position [cm]');
    ylabel('Y position [cm]');
end
end