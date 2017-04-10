function fs = get_fontsize()

comtype = computer;
if isequal(comtype(1:3), 'MAC')
    fs = 25;
else
    fs = 15;
end