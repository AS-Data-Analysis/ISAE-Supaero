try
    close(1);
catch
end
try
    ishghandle(thg_est)
catch
    thg_est = struct();
    thg_true = struct();
end
if not(ishghandle(thg_est))
    figure(1);
    ax = subplot(2,2,1);
    vert=[-1 1 0.1
        -1 -1 0.1
        -1 -1 -0.1
        -1 1 -0.1
        1 1 0.1
        1 -1 0.1
        1 -1 -0.1
        1 1 -0.1
        -1.01 0.2 0.1
        -1.01 -0.2 0.1
        -1.01 -0.2 -0.1
        -1.01 0.2 -0.1
        ];
    fac=[1 2 3 4
        2 6 7 3
        5 6 7 8
        1 5 8 4
        1 2 6 5
        4 3 7 8
        9 10 11 12];
    tcolor=[1 1 1;0 1 0;1 1 1;1 0 0;1 1 1;0 0 0;0 0 0];
    h=patch('Faces',fac,'Vertices',vert,'FaceVertexCData',tcolor,'FaceColor','flat');
    grid off;
    axis equal;
%     view(90,0);    
    view(-90,0);    
    thg_est = hgtransform('Parent',ax);
    set(h,'Parent',thg_est);
    if useSimulation_visuals
        h_true = patch('Faces',fac,'Vertices',vert,'FaceVertexCData',tcolor,'FaceColor','flat');
        thg_true = hgtransform('Parent',ax);
        set(h_true,'Parent',thg_true);
    end
    set(gcf,'Renderer','zbuffer');
    set(ax, 'XTickLabelMode', 'manual', 'XTickLabel', []);
    set(ax, 'YTickLabelMode', 'manual', 'YTickLabel', []);
    set(ax, 'ZTickLabelMode', 'manual', 'ZTickLabel', []);
    drawnow;
end
