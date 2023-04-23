if (t-tp)>1/20
    initiate = size(obs, 2) < 10;
    % astuce : quitte si la figure est fermee
    if not(ishghandle(thg_est))
        return;
    end
    p = xtrue(8:10, end);
    T_k=[DCM_k p
        zeros(1,3) 1];
    ax = subplot(2,2,1);
    p0 = xtrue(8:10, 1);
    set(ax, 'XLim',p0(1)+[-2 2],'YLim', p0(2)+[-2 2], 'ZLim',p0(3)+[-2 2],'Visible','on');
    set(thg_est,'Matrix',T_k);
    grid on;
    drawnow;
    if useSimulation_visuals
        % Update true state visual:
        DCM_true = quat2dcm(xtrue(1:4, end)');
        T_true=[DCM_true p
            zeros(1,3) 1];
        set(thg_true,'Matrix',T_true);
    end
    % Plot true Euler angles and estimates:
    [yaw, pitch, roll] = quat2angle(xhat(1:4, :)');
    eulest = [yaw'; pitch'; roll'];
    [yaw, pitch, roll] = quat2angle(xtrue(1:4, :)');
    eultrue = [yaw'; pitch'; roll'];
    lgds = {'yaw', 'pitch', 'roll'};
    cols = {'r', 'g', 'b'};
    if t < 0.1
        axx = [];
        for k=0:2
            euler_ax{k+1} = subplot(2,2,k+2);
            axx(k+1) = euler_ax{k+1};
            hold off;
            plot(obs(1, :) - obs(1, 1), rad2deg(eulest(1+k, :)), ['-.' cols{k+1}]);
            legend({'estimated'});
            if useSimulation_visuals
                hold on;
                plot(obs(1, :) - obs(1, 1), rad2deg(eultrue(1+k, :)), cols{k+1});
                legend({'estimated', 'true (simulation)'});
            end
            title(lgds{k+1});
            grid on;
            xlabel('time [s]');
            ylabel('Euler angle [deg]');
            %ylim([-180; 180]);
        end
        %linkaxes(axx, 'x');
    else
        for k=0:2
            if useSimulation_visuals
                euler_ax{k+1}.Children(1).XData = obs(1, :) - obs(1, 1);
                euler_ax{k+1}.Children(1).YData = rad2deg(eultrue(1+k, :));
                euler_ax{k+1}.Children(2).XData = obs(1, :) - obs(1, 1);
                euler_ax{k+1}.Children(2).YData = rad2deg(eulest(1+k, :));
            else
                euler_ax{k+1}.Children(1).XData = obs(1, :) - obs(1, 1);
                euler_ax{k+1}.Children(1).YData = rad2deg(eulest(1+k, :));
            end
        end
    end
    drawnow;
    tp = t;
end