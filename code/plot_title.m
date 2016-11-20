function plot_title(titlestr, flag)
persistent first_flag h
if isempty(first_flag)
    first_flag = true;
end

switch flag
    case -1
        col = 'r';
    case 0
        col = 'y';
    case 1
        col = 'w';
end

if first_flag
    first_flag = false;
    h.title = title(titlestr, 'FontSize', 25, 'Color', col);
else
    h.title.String = titlestr;
    h.title.Color = col;
end
