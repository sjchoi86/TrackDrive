function plot_axis(axisinfo, caxisinfo)
axis equal off; 
axis(axisinfo); 
xlabel('X'); ylabel('Y');
shading flat; 
colormap jet; 
caxis(caxisinfo); 
colorbar; 
