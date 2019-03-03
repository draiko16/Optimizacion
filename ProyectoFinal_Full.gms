*Listas de todos los nodos que se van a manejar
Set p "Proveedores" /p1*p3/
    i "Insumos" /in1*in8/
    pl "Plantas de produccion" /pl1, pl2/
    cd "Centros de distribucion" /cd1, cd2/
    pr "Productos" /pr1*pr7/
    cl "Clientes" /cl1*cl4/  ;

Table cdp(pl, pr) "Capacidad de produccion de las plantas (Kg)"
            pr1     pr2     pr3     pr4     pr5     pr6     pr7
    pl1     350     520     1050    300     0       0       0
    pl2     455     240     0       0       125     655.2   1768    ;

Table rdi(pr, i) "Requerimiento de insumos"
            in1         in2         in3         in4         in5         in6         in7         in8
    pr1     0.070833    0.191666    0.258333    0           0           0.25        0.20833333  0.0208333
    pr2     0.2971135   0           0.271646    0.0195246   0.012733    0.1273344   0           0.2716468
    pr3     0.5434782   0.028985    0.054347    0           0.126811    0.0833333   0.16304347  0
    pr4     0           0.078291    0.185053    0.2206405   0.088967    0.2419928   0.18505338  0
    pr5     0.0674157   0.168539    0           0           0.151685    0.3651685   0.17977528  0.06741573
    pr6     0.1742160   0.006968    0.041811    0.1114982   0.118466    0.2787456   0.11149826  0.15679443
    pr7     0.15763547  0.246305    0           0.0591133   0.167487    0.0591133   0.15270936  0.15763547  ;
    
Table enppl(p,pl) "Costos de envios de proveedores a plantas ($/Kg)"
        pl1     pl2
    p1  53.2    31.5
    p2  68.3    32.6
    p3  31.1    33.5    ;

Table enplcd(pl,cd) "Costos de envios de plantas a los centros de distribucion ($/Kg)"
        cd1     cd2
    pl1 30.3    35.3
    pl2 35.3    46.5    ;

Table encdcl(cd, cl)  "Costos de envios de cd a clientes ($/Kg)"
        cl1     cl2     cl3     cl4
    cd1 89.3    58.5    64.5    65.3
    cd2 95.6    95.6    94.3    98.2    ;

Table demandaPR(pr, cl) "Datos de la demanda de los clientes"
        cl1     cl2     cl3     cl4
    pr1 35      12.74   0       24.5
    pr2 52      0       36      32
    pr3 105     0       210     150
    pr4 30      16.2    42      66
    pr5 32.5    7.75    0       0
    pr6 108     234     0       0
    pr7 130     358.28  130     252.2 ;


Table preciosPR(pr, cl) "Datos de los precios de venta de los productos"
        cl1         cl2         cl3         cl4
    pr1 4285.714286 4285.714286 4285.714286 4285.714286
    pr2 3125        3125        3125        3125
    pr3 3333.333333 3333.333333 333.333333  3333.333333
    pr4 9166.666667 9166.666667 833.333333  9166.666667
    pr5 18000       18000       18000       18000
    pr6 2222.222222 2222.222222 2222.222222 2222.222222
    pr7 1826.923077 1826.923077 1826.923077 1826.923077;


Parameters
    cdi(i) "Costos de insumos (Kg)"
    /   in1 25
        in2 50
        in3 35.6
        in4 38.5
        in5 60
        in6 10
        in7 9.8
        in8 5.6 /;

Variables
    reqIn(p, i, pl) "Envios de insumos a las plantas"
    x(pl, pr, cd) "Envios de plantas a cd por producto"
    y(cd, pr, cl) "Envios de cd a clientes"    
    Z "Ganancias totales"   ;
    
Positive Variables reqIn, x,y;

Equations
    ganancias "Funcion objetivo"
    enviosPR(i,  pl) "Revisa los requerimientos de insumos para las plantas"
    enviosPL(pl, pr) "Revisa los limites de produccion"
    inter(cd, pr) "Revisa que los cd entreguen todos los productos que reciban"
    demandaCL(pr, cl) "Revisa el cumplimiento de las demandas"  ;

ganancias.. Z =e= sum((pr,cl), preciosPR(pr, cl)*sum(cd, y(cd, pr, cl)))
*sumatoria de los costos de los insumos
                -sum(i, sum((p, pl, pr), reqIn(p,i,pl)*cdi(i)))
*sumatoria de los costos de envios desde los proveedores hasta las plantas
                -sum((p, pl), sum((i,pr), reqIn(p,i,pl)) * enppl(p,pl))
*sumatoria de los costos de envios desde las plantas hasta los cd
                -sum((pl,cd), sum(pr, x(pl,pr,cd)) * enplcd(pl,cd))
*sumatoria de los costos de envios desde los cd hasta los clientes
                -sum((cd,cl), sum(pr, y(cd,pr,cl)) * encdcl(cd,cl));

*Se unifican los envios desde los centros de distribucion
*para obtener el total de los productos
*para cada cliente
demandaCL(pr, cl)..  sum((cd),y(cd,pr,cl)) =e= demandaPR(pr, cl);

*Se unifican los envios a los cd para encontrar
*el total de productos enviados por cada planta
enviosPL(pl, pr)..  sum(cd,x(pl,pr,cd)) =l= cdp(pl, pr);

*Se unifica la parte de lo que enviaron de cada planta y lo que
*le llegó a cada cliente para ver claramente cuantos productos
*pasaron por los CD y se comprueba que sean los mismos
inter(cd,pr).. sum(pl,x(pl, pr, cd)) =e= sum((cl),y(cd,pr,cl));

*Se unifica los envios a los diferentes CD, para saber la cantidad de productos
*por cada planta, se multiplican por la matriz de requerimientos y se comprueba que de
*igual a los requerimientos de productos a producir
enviosPR(i,  pl).. sum((cd,pr), x(pl, pr, cd)*rdi(pr, i)) =e= sum(p, reqIn(p, i, pl));

Model Insumos /all/;
Solve Insumos using lp maximizing Z;

Display reqIn.l, x.l, y.l, Z.l;
