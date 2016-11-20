function [bd, p1, p2, p3, p4] = get_bd4straight(startpos, width, d)

currxy = startpos(1:2); currdeg = startpos(3);
c = cos(currdeg*pi/180); s = sin(currdeg*pi/180);

p1 = currxy + width/2*[s -c];
p2 = p1 + d*[c s];
p3 = p2 + width*[-s c];
p4 = currxy + width/2*[-s c];
bd = [p1 ; p2 ; p3 ; p4 ; p1];