function scatter_plot(X, marker, color)

hold on
for i = 1:size(X,1)
  plot(X(i,1), X(i, 2), 'Marker', marker(i,:), ...
      'MarkerEdgeColor', color(i,:),...
      'MarkerFaceColor', color(i,:))   
end
