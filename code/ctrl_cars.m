function [othercars, emsec] = ctrl_cars(othercars, track)
iclk = clock;

for i = 1:othercars.n
    ctrlmode = othercars.car{i}.ctrlmode;
    carpos   = othercars.car{i}.pos;
    switch ctrlmode
        case 'stop'
            
        case 'normal'
            dinfo = get_trackinfo(track, [carpos(1:2) 0]);
            hinfo = get_trackinfo(track, carpos, othercars);
            
            % SET DIRECTIONAL VELOCITY 
            dirvel = 10000;
            fdist = hinfo.center_fb_dists(1); 
            if isfield(hinfo, 'tlinfo') % IF TRRAFFIC LIGHT EXISTS
                % SLOW DOWN IN THE YELLOW OR RED LIGHT
                if (isequal(hinfo.tlinfo.type, 'y') || ...
                        isequal(hinfo.tlinfo.type, 'r'))...
                        && hinfo.tlinfo.dist2tf < 15000
                    dirvel = 5000;
                end
                % STOP IN FRONT OF THE RED LIGHT
                if isequal(hinfo.tlinfo.type, 'r') ...
                        && hinfo.tlinfo.dist2tf < 4000
                    dirvel = 0;
                end
            end
            if fdist < 7000 % IF ANOTHER CAR IS INFRONT
                dirvel = 0;
            end
            
            
            % SET ANGULAR VELOCITY
            lanedeg = -dinfo.deg;
            degdiff = carpos(3) - lanedeg;
            if degdiff >= 180, degdiff = degdiff - 360; end;
            if degdiff <= -180, degdiff = degdiff + 360; end;
            w = -degdiff*15 + hinfo.lane_dev * 0.3;
            wmax = 200;
            w = max(min(w, wmax), -wmax);
            othercars.car{i}.vel = [dirvel, w];
            
    end
end

emsec = etime(clock, iclk)*1000;
