Sets
    in1 pr_in1 /p11, p21, p31/
    in2 pr_in2 /p12, p22, p32/
    in3 pr_in3 /p13, p23, p33/
    in4 pr_in4 /p14, p24, p34/
    in5 pr_in5 /p15, p25, p35/
    in6 pr_in6 /p16, p26, p36/
    in7 pr_in7 /p17, p27, p37/
    in8 pr_in8 /p18, p28, p38/
    
    p1 plantasPR1  /pl11, pl21/
    p2 plantasPR2  /pl12, pl22/
    p3 plantasPR3  /pl13, pl23/
    p4 plantasPR4  /pl14, pl24/
    p5 plantasPR5  /pl15, pl25/
    p6 plantasPR6  /pl16, pl26/
    p7 plantasPR7  /pl17, pl27/
    
    c1 cdPR1 /cd11, cd21/
    c2 cdPR2 /cd12, cd22/
    c3 cdPR3 /cd13, cd23/
    c4 cdPR4 /cd14, cd24/
    c5 cdPR5 /cd15, cd25/
    c6 cdPR6 /cd16, cd26/
    c7 cdPR7 /cd17, cd27/
    
    cl1 clPR1 /cl11, cl21, cl31, cl31/
    cl2 clPR2 /cl12, cl22, cl32, cl42/
    cl3 clPR3 /cl13, cl23, cl33, cl43/
    cl4 clPR4 /cl14, cl24, cl34, cl44/
    cl5 clPR5 /cl15, cl25, cl35, cl45/
    cl6 clPR6 /cl16, cl26, cl36, cl46/
    cl7 clPR7 /cl17, cl27, cl37, cl47/;
    
    i1 plantasIntegral  /p1I, p2I/
    i2 plantasFortificado /p1F, p2F/
    j1 ciudadesIntegral /bogI, calI, medI/
    j2 ciudadesFortificado /bogF, calF, medF/;

Parameters
    capPR1(p1) capacidad de produccion del producto 1
        /   pl11 5000
            pl21 6500 /
    capPR2(p2) capacidad de produccion del producto 2
        /   pl12 6500
            pl22 3000 /
    capPR3(p3) capacidad de produccion del producto 3
        /   pl13 3500
            pl23 0 /
    capPR4(p4) capacidad de produccion del producto 4
        /   pl14 2500
            pl24 0 /
    capPR5(p5) capacidad de produccion del producto 5
        /   pl15 0
            pl25 2500 /
    capPR6(p6) capacidad de produccion del producto 6
        /   pl16 0
            pl26 1820 /
    capPR7(p7) capacidad de produccion del producto 7
        /   pl17 0
            pl27 3400 /
            
    demPR1(cl1) demanda producto 1
        /   cl11 35
            cl21 12.74
            cl31 0
            cl41 24.5 /
    demPR2(cl2) demanda producto 1
        /   cl12 52
            cl22 0
            cl32 36/
    demPR3(cl3) demanda producto 1
        /   cl13 105
            cl23 0
            cl33 /
    demPR4(cl4) demanda producto 1
        /   cl14 
            cl24 
            cl34 /
    demPR5(cl5) demanda producto 1
        /   cl15 
            cl25 
            cl35 /
    demPR6(cl6) demanda producto 1
        /   cl16 
            cl26 
            cl36 /
    demPR7(cl7) demanda producto 1
        /   cl17 
            cl27 
            cl37 /
    
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
