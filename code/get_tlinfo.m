function myinfo = get_tlinfo(myinfo, track)
% GET TRAFFIC LIGHT INFORMATION
% THIS SHOULD BE CALLED 'AFTER' CALLING GET_TRACKINFO()

tlinfo.type = track.traffic.type;
tlinfo.dist2tf = track.traffic.dist - myinfo.dist;
MAX_DIST2TF = 15000;
tlinfo.MAX_DIST2TF = MAX_DIST2TF;
if tlinfo.dist2tf < 0
    tlinfo.dist2tf = MAX_DIST2TF;
elseif tlinfo.dist2tf > MAX_DIST2TF
    tlinfo.dist2tf = MAX_DIST2TF;
end

% ADD TO INFO
myinfo.tlinfo = tlinfo;
