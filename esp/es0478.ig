/* include para impressao de etiquetas de AE em impressoras Godex
   criado em 10/08/2000 */
               
disp "^Q40,2" skip
     "^S7" skip
     "^H3" skip
     "^E12" skip
     "^L"   skip
     "AE,5,10,1,1,1,0,"  
     substring(item.it-codigo,1,6) + "-" +
     substring(item.it-codigo,7,1) no-label skip
     "AE,250,10,1,1,1,0," + ae-item.localizacao format "X(70)" no-label skip
     "AB,5,65,1,1,1,0,  AE " string(ae-item.nr-ae,">999999") no-label skip
     "AB,220,65,1,1,1,0,Seq." string(ae-item.sequencia,"999") no-label skip
     "AB,340,65,1,1,1,0," +  string(ae-item.data,"99/99/9999")
     format "x(70)" no-label skip 
     "AB,13,95,1,1,1,0, ROT " string(ae-item.roteiro,">>>>>9") skip
     "AB,220,95,1,1,1,0," userid("mgadm") skip
     "AB,18,140,1,1,1,0," +
     item.descricao-1 + item.descricao-2 format "X(76)" no-label skip
     "AF,178,180,1,1,1,0," + string(ae-item.quantidade,">,>>>,>>9") 
             format "x(70)" no-label skip
     "BU,35,230,2,5,50,0,1," + c-linha format "X(60)" no-label skip
     "E".

