Sets
    i "Insumos" /in1*in8/
    p "Proveedores" /p1*p3/
    pl "Plantas" /pl1, pl2/ ;


Table cpp(p, pl) "Costos de envios de P a PL"
        pl1     pl2
    p1  53.2    31.5
    p2  68.3    32.6
    p3  31.1    33.5  ;

Table din(i, pl) "Demanda de insumos por planta"
            pl1         pl2
        in1 293.488042  199.513887
        in2 39.3968587  223.570924
        in3 105.066594  14.2996516
        in4 36.36573    89.58935
        in5 74.2142661  192.415696
        in6 109.405438  161.48599
        in7 119.400449  178.298803
        in8 34.1026231  193.555699  ;
Parameters
    cdi(i) "Costos de insumos (Kg)"
    /   in1 25
        in2 50
        in3 35.6
        in4 38.5
        in5 60
        in6 10
        in7 9.8
        in8 5.6 /
$ontext
    x(p,i,pl) "Envios de los insumos";
    x(p,i,pl) = cpp(p,pl);
Parameter
    y(p, pl) "Sumatorias de insumos";
    y(p, pl) = sum(i, x(p,i,pl));

Parameter
    w(i, pl) "Sumatorias de proveedores";
    w(i, pl) = sum(p, x(p,i,pl));
display x, y, w;
$offtext

Variables
    env(p,i,pl) "Envios totales de los proveedores a las plantas"
    z "Costos totales";

Positive Variables env;

Equations
    obj "funcion objetivo"
    demanda(i, pl) "Comprobacion de la demanda";

obj.. z =e= sum((p,pl), sum(i, env(p,i,pl)) * cpp(p,pl)) + sum(i, sum((p,pl), env(p,i,pl)*cdi(i)));
demanda(i, pl).. sum(p, env(p, i, pl))=g=din(i, pl);

Model Insumos /all/;
Solve Insumos using lp minimizing Z;

Display env.l, z.l;
