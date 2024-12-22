primitive mux_2to1 (output y, input sel, a, b);
    table
 // sel  a   b     y
     0   0   ?  :  0;
     0   1   ?  :  1;
     1   ?   0  :  0;
     1   ?   1  :  1;
    endtable
endprimitive