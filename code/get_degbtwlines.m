function deg_diff = get_degbtwlines(org, pntA, pntB)
% GET DEGREE BETWEEN LINES
% org-pntA / org-pntB 

pntA = pntA - org;
pntB = pntB - org;

pntA = pntA / norm(pntA);
pntB = pntB / norm(pntB);

pntC = [-pntA(2) pntA(1)];
flag = sign(pntB(1)*pntC(1) + pntB(2)*pntC(2));

deg_diff = flag*acos(pntA(1)*pntB(1) + pntA(2)*pntB(2))*180/pi;