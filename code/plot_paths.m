function plot_paths(paths, pathweights)
persistent first_flag h
if isempty(first_flag)
    first_flag = true;
end
npaths = size(paths, 1)/3;
pathlist = cell(npaths, 1);
for i = 1:npaths
    xs = paths((i-1)*3+1, :);
    ys = paths((i-1)*3+2, :);
    path = [xs' ys'];
    pathlist{i} = path;
end
[~, sortidx] = sort(pathweights, 'ascend');
colors = jet(npaths);
if first_flag
    first_flag = false;
    h.paths = cell(npaths, 1);
    for i = sortidx'
        path = pathlist{i};
        col = colors(find(sortidx==i), :);
        h.paths{i} = plot(path(:, 1), path(:, 2) ...
            , '-', 'Color', col, 'LineWidth', 1);
    end
else
    for i = sortidx'
        path = pathlist{i};
        col = colors(find(sortidx==i), :);
        h.paths{i}.XData = path(:, 1);
        h.paths{i}.YData = path(:, 2);
        h.paths{i}.Color = col;
    end
end