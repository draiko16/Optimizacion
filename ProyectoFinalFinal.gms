Sets
    i1 plantasIntegral  /p1I, p2I/
    i2 plantasFortificado /p1F, p2F/
    j1 ciudadesIntegral /bogI, calI, medI/
    j2 ciudadesFortificado /bogF, calF, medF/;

Parameters
    capI(i1) capacidad de las plantas para integral
        /   p1I 1250
            p2I 1500 /
    capF(i2) capacidad de las plantas para fortificado
        /   p1F 2500
            p2F 2000 /
    demI(j1) demanda de las ciudades de arroz integral
        /   bogI 800
            calI 800
            medI 900 /
    demF(j2) demanda de las ciudades de arroz fortificado
        /   bogF 1800
            calF 1000
            medF 1700 / ;

Table int(i1, j1) costos de envÃ¬o de arroz integral
            bogI        calI        medI
    p1I     700         600         800
    p2I     650         800         1050    ;

Table fort(i2, j2) costos de envÃ¬o de arroz fortificado
            bogF        calF        medF
    p1F     500         400         600
    p2F     300         350         700     ;

Variables
    XI(i1, j1)  unidades por envÃ­o de arroz integral
    XF(i2, j2)  unidades por envÃ¬o de arroz fortificado
    Z           costos de transporte totales    ;

Equations
    costos          define la funcion objetivo
    enviosInt(i1)   revisa los lÃ¬mites de las plantas por envÃ­o integral
    enviosFor(i2)   revisa los lÃ¬mites de las plantas por envÃ­o fortificado
    demandaI(j1)    satisface la demanda de arroz integral
    demandaF(j2)    satisface la demanda de arroz fortificado   ;

costos..        Z =e= sum((i1,j1), int(i1,j1)*XI(i1,j1)) + sum((i2,j2), fort(i2,j2)*XF(i2,j2));
enviosInt(i1).. sum(j1, XI(i1,j1)) =l= capI(i1) ;
enviosFor(i2).. sum(j2, XF(i2,j2)) =l= capF(i2) ;
demandaI(j1).. sum(i1, XI(i1,j1)) =g= demI(j1) ;
demandaF(j2).. sum(i2, XF(i2,j2)) =g= demF(j2) ;

Model Arroz /all/;
Solve Arroz using lp minimizing Z;

Display XI.l, XF.l, Z.l;
