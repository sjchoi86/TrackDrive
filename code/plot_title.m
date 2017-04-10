function ems = plot_title(titlestr, col, fs)
% PLOT TITLE
persistent first_flag h
if isempty(first_flag)
    first_flag = true;
end

iclk = clock;
if first_flag
    first_flag = false;
    h.title = title(titlestr, 'FontSize', fs, 'Color', col);
else
    h.title.String = titlestr;
    h.title.Color = col;
end
ems = etime(clock, iclk)*1000;
