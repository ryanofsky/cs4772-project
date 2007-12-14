function scatter_plot(X, marker, color, show_neighbors, neighbors, legend_candidate_names, legend_candidate_colors, legend_issue_names, legend_issue_markers)

clf
hold on

% set axis limits
lx = min(X(:,1));
hx = max(X(:,1));
ly = min(X(:,2));
hy = max(X(:,2));
set(gca, 'XLimMode', 'manual', 'YLimMode', 'manual', ...
    'XLim', [lx, hx], 'YLim', [ly hy]);

% show neighbors
if show_neighbors
  for i=1:size(neighbors, 1)
    for j=1:size(neighbors, 2)
      if neighbors(i, j) == 1
        line( [X(i, 1), X(j, 1)], [X(i, 2), X(j, 2)], 'Color', [.9, .9, .9]);
      end
    end
  end
end

% plot points
for i = 1:size(X,1)
  plot(X(i,1), X(i, 2), 'Marker', marker(i,:), ...
      'MarkerEdgeColor', color(i,:),...
      'MarkerFaceColor', color(i,:))   
end


% plot points for legend offscreen
n = 1
for i = 1:size(legend_candidate_colors, 1)
  handles(n) = plot(lx-1, ly-1, 'Color', legend_candidate_colors(i,:), ...
                    'LineWidth', 10);
  labels{n} = deblank(legend_candidate_names(i,:));
  n = n + 1;
end
for i = 1:size(legend_issue_markers, 1)
  handles(n) = plot(lx-1, ly-1, ...
      'Color', [0 0 0], ...
      'MarkerEdgeColor', [0 0 0],...
      'MarkerFaceColor', [0 0 0],...
      'Marker', legend_issue_markers(i,:));
  labels{n} = deblank(legend_issue_names(i,:));
  n = n + 1;
end

legend(handles, labels)
