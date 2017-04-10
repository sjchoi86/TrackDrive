function flag = is_insidetrack(myinfo)

if myinfo.lane_idx < 0
    flag = false;
else
    flag = true;
end
