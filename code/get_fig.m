function fig = get_fig(figsz, figtitle, axespos)
% GET FIGURE WITH SIZE AND TITLE

fig = figure(1);
sz = get(0, 'ScreenSize');
figpos = [figsz(1)*sz(3) figsz(2)*sz(4) ...
    figsz(3)*sz(3) figsz(4)*sz(4)];
set(fig, 'KeyPressFcn', @keyDownListener, 'Position', figpos ...
    , 'MenuBar', 'none', 'NumberTitle', 'off' ...
    , 'Name', figtitle);
axes('Parent', fig, 'Position', axespos);
