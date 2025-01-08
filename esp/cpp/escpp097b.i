
CASE i-cont:
    WHEN 1 THEN DO: /* Etiqueta 1 */

       ASSIGN i-vert[i-cont] = 0
              i-hori[i-cont] = 60.
      
       /* QRcode */
       PUT UNFORMATTED "^FT" string(180 + i-hori[i-cont]) "," string(300 + i-vert[i-cont]) "^BQN,2,50^FH\^FDLA," c-qrcode "^FS" SKIP.
       
       /* Barcode */
       PUT UNFORMATTED "^FWR" SKIP.
       PUT UNFORMATTED "^FO" string(50 + i-hori[i-cont]) "," string(70 + i-vert[i-cont]) "^AD^BY4" SKIP.
       PUT UNFORMATTED "^BC,90,N,N,N" SKIP.
       PUT UNFORMATTED "^FD" c-ID "^FS" SKIP.
    /*   PUT UNFORMATTED "^FO" string(50 + i-hori[i-cont]) "," string(160 + i-vert[i-cont]) "^BY1^BCN,25,N,N,N,N^FD" c-ID "^FS" SKIP. */       

       /* PO */
       PUT UNFORMATTED "^^FO" string(180 + i-hori[i-cont]) "," string(350 + i-vert[i-cont]) "^A0N,50,50^FB1000,1,0,L^FDPO:^FS" SKIP.
       PUT UNFORMATTED "^^FO" string(260 + i-hori[i-cont]) "," string(350 + i-vert[i-cont]) "^A0N,50,50^FB1000,1,0,L^FD" STRING(mac-address.num-pedido) "^FS" SKIP.

       /* ID */
       PUT UNFORMATTED "^FO" string(180 + i-hori[i-cont]) "," string(400 + i-vert[i-cont]) "^A0N,50,50^FB1000,1,0,L^FD" c-ID "^FS" SKIP.
       
       /* Chave */
       PUT UNFORMATTED "^FO" string(180 + i-hori[i-cont]) "," string(450 + i-vert[i-cont]) "^A0N,50,50^FB1000,1,0,L^FD" string(c-ch-acesso) "^FS" SKIP.

       /* Seq */
       PUT UNFORMATTED "^FO" string(180 + i-hori[i-cont]) "," string(500 + i-vert[i-cont]) "^A0N,50,50^FB1000,1,0,L^FDSEQ:^FS" SKIP.
       PUT UNFORMATTED "^FO" string(290 + i-hori[i-cont]) "," string(500 + i-vert[i-cont]) "^A0N,50,50^FB1000,1,0,L^FD" STRING(mac-address.seq-imp) "^FS" SKIP.

    END. /* FIM etiqueta 1 */

    WHEN 2 THEN DO: /* Etiqueta 2 */

       ASSIGN i-vert[i-cont] = 0
              i-hori[i-cont] = 690.

       /* QRcode */
       PUT UNFORMATTED "^FT" string(180 + i-hori[i-cont]) "," string(300 + i-vert[i-cont]) "^BQN,2,50^FH\^FDLA," c-qrcode "^FS" SKIP.
       
       /* Barcode */
       PUT UNFORMATTED "^FWR" SKIP.
       PUT UNFORMATTED "^FO" string(50 + i-hori[i-cont]) "," string(70 + i-vert[i-cont]) "^AD^BY4" SKIP.
       PUT UNFORMATTED "^BC,90,N,N,N" SKIP.
       PUT UNFORMATTED "^FD" c-ID "^FS" SKIP.
    /*   PUT UNFORMATTED "^FO" string(50 + i-hori[i-cont]) "," string(160 + i-vert[i-cont]) "^BY1^BCN,25,N,N,N,N^FD" c-ID "^FS" SKIP. */       

       /* PO */
       PUT UNFORMATTED "^^FO" string(180 + i-hori[i-cont]) "," string(350 + i-vert[i-cont]) "^A0N,50,50^FB1000,1,0,L^FDPO:^FS" SKIP.
       PUT UNFORMATTED "^^FO" string(260 + i-hori[i-cont]) "," string(350 + i-vert[i-cont]) "^A0N,50,50^FB1000,1,0,L^FD" STRING(mac-address.num-pedido) "^FS" SKIP.

       /* ID */
       PUT UNFORMATTED "^FO" string(180 + i-hori[i-cont]) "," string(400 + i-vert[i-cont]) "^A0N,50,50^FB1000,1,0,L^FD" c-ID "^FS" SKIP.
       
       /* Chave */
       PUT UNFORMATTED "^FO" string(180 + i-hori[i-cont]) "," string(450 + i-vert[i-cont]) "^A0N,50,50^FB1000,1,0,L^FD" string(c-ch-acesso) "^FS" SKIP.

       /* Seq */
       PUT UNFORMATTED "^FO" string(180 + i-hori[i-cont]) "," string(500 + i-vert[i-cont]) "^A0N,50,50^FB1000,1,0,L^FDSEQ:^FS" SKIP.
       PUT UNFORMATTED "^FO" string(290 + i-hori[i-cont]) "," string(500 + i-vert[i-cont]) "^A0N,50,50^FB1000,1,0,L^FD" STRING(mac-address.seq-imp) "^FS" SKIP.
    END. /* FIM etiqueta 2 */

    WHEN 3 THEN DO: /* Etiqueta 3 */

       ASSIGN i-vert[i-cont] = 0
              i-hori[i-cont] = 1320.

       /* QRcode */
       PUT UNFORMATTED "^FT" string(180 + i-hori[i-cont]) "," string(300 + i-vert[i-cont]) "^BQN,2,50^FH\^FDLA," c-qrcode "^FS" SKIP.
       
       /* Barcode */
       PUT UNFORMATTED "^FWR" SKIP.
       PUT UNFORMATTED "^FO" string(50 + i-hori[i-cont]) "," string(70 + i-vert[i-cont]) "^AD^BY4" SKIP.
       PUT UNFORMATTED "^BC,90,N,N,N" SKIP.
       PUT UNFORMATTED "^FD" c-ID "^FS" SKIP.
    /*   PUT UNFORMATTED "^FO" string(50 + i-hori[i-cont]) "," string(160 + i-vert[i-cont]) "^BY1^BCN,25,N,N,N,N^FD" c-ID "^FS" SKIP. */       

       /* PO */
       PUT UNFORMATTED "^^FO" string(180 + i-hori[i-cont]) "," string(350 + i-vert[i-cont]) "^A0N,50,50^FB1000,1,0,L^FDPO:^FS" SKIP.
       PUT UNFORMATTED "^^FO" string(260 + i-hori[i-cont]) "," string(350 + i-vert[i-cont]) "^A0N,50,50^FB1000,1,0,L^FD" STRING(mac-address.num-pedido) "^FS" SKIP.

       /* ID */
       PUT UNFORMATTED "^FO" string(180 + i-hori[i-cont]) "," string(400 + i-vert[i-cont]) "^A0N,50,50^FB1000,1,0,L^FD" c-ID "^FS" SKIP.
       
       /* Chave */
       PUT UNFORMATTED "^FO" string(180 + i-hori[i-cont]) "," string(450 + i-vert[i-cont]) "^A0N,50,50^FB1000,1,0,L^FD" string(c-ch-acesso) "^FS" SKIP.

       /* Seq */
       PUT UNFORMATTED "^FO" string(180 + i-hori[i-cont]) "," string(500 + i-vert[i-cont]) "^A0N,50,50^FB1000,1,0,L^FDSEQ:^FS" SKIP.
       PUT UNFORMATTED "^FO" string(290 + i-hori[i-cont]) "," string(500 + i-vert[i-cont]) "^A0N,50,50^FB1000,1,0,L^FD" STRING(mac-address.seq-imp) "^FS" SKIP. 
    END. /* FIM etiqueta 3 */

    WHEN 4 THEN DO: /* Etiqueta 4 */

       ASSIGN i-vert[i-cont] = 0
              i-hori[i-cont] = 1960.

       /* QRcode */
       PUT UNFORMATTED "^FT" string(180 + i-hori[i-cont]) "," string(300 + i-vert[i-cont]) "^BQN,2,50^FH\^FDLA," c-qrcode "^FS" SKIP.
       
       /* Barcode */
       PUT UNFORMATTED "^FWR" SKIP.
       PUT UNFORMATTED "^FO" string(50 + i-hori[i-cont]) "," string(70 + i-vert[i-cont]) "^AD^BY4" SKIP.
       PUT UNFORMATTED "^BC,90,N,N,N" SKIP.
       PUT UNFORMATTED "^FD" c-ID "^FS" SKIP.
    /*   PUT UNFORMATTED "^FO" string(50 + i-hori[i-cont]) "," string(160 + i-vert[i-cont]) "^BY1^BCN,25,N,N,N,N^FD" c-ID "^FS" SKIP. */       

       /* PO */
       PUT UNFORMATTED "^^FO" string(180 + i-hori[i-cont]) "," string(350 + i-vert[i-cont]) "^A0N,50,50^FB1000,1,0,L^FDPO:^FS" SKIP.
       PUT UNFORMATTED "^^FO" string(260 + i-hori[i-cont]) "," string(350 + i-vert[i-cont]) "^A0N,50,50^FB1000,1,0,L^FD" STRING(mac-address.num-pedido) "^FS" SKIP.

       /* ID */
       PUT UNFORMATTED "^FO" string(180 + i-hori[i-cont]) "," string(400 + i-vert[i-cont]) "^A0N,50,50^FB1000,1,0,L^FD" c-ID "^FS" SKIP.
       
       /* Chave */
       PUT UNFORMATTED "^FO" string(180 + i-hori[i-cont]) "," string(450 + i-vert[i-cont]) "^A0N,50,50^FB1000,1,0,L^FD" string(c-ch-acesso) "^FS" SKIP.

       /* Seq */
       PUT UNFORMATTED "^FO" string(180 + i-hori[i-cont]) "," string(500 + i-vert[i-cont]) "^A0N,50,50^FB1000,1,0,L^FDSEQ:^FS" SKIP.
       PUT UNFORMATTED "^FO" string(290 + i-hori[i-cont]) "," string(500 + i-vert[i-cont]) "^A0N,50,50^FB1000,1,0,L^FD" STRING(mac-address.seq-imp) "^FS" SKIP.  
    END. /* FIM etiqueta 4 */


    
/*
    WHEN 5 THEN DO: /* Etiqueta 5 */

       ASSIGN i-vert[i-cont] = 200
              i-hori[i-cont] = 0.

       PUT UNFORMATTED "^FT" string(70 + i-hori[i-cont]) "," string(140 + i-vert[i-cont]) "^BQN,2,4^FH\^FDLA," c-qrcode "^FS" SKIP.  /* C½digo de Barras do Nœmero de S²rie */
       
       PUT UNFORMATTED "^^FO" string(50 + i-hori[i-cont]) "," string(140 + i-vert[i-cont]) "^A0N,15,15^FB1000,1,0,L^FDPO:^FS" SKIP.
       PUT UNFORMATTED "^^FO" string(70 + i-hori[i-cont]) "," string(140 + i-vert[i-cont]) "^A0N,15,15^FB1000,1,0,L^FD999999^FS" SKIP. /* inserir pedido */
       
       PUT UNFORMATTED "^FO" string(50 + i-hori[i-cont]) "," string(160 + i-vert[i-cont]) "^BY1^BCN,25,N,N,N,N^FD" c-ID "^FS" SKIP.
       
       PUT UNFORMATTED "^FO" string(50 + i-hori[i-cont]) "," string(190 + i-vert[i-cont]) "^A0N,15,15^FB1000,1,0,L^FD" c-ID "^FS" SKIP.
       
       PUT UNFORMATTED "^FO" string(135 + i-hori[i-cont]) "," string(190 + i-vert[i-cont]) "^A0N,15,15^FB1000,1,0,L^FD" string(c-ch-acesso) "^FS" SKIP.
       
    END. /* FIM etiqueta 5 */

    WHEN 6 THEN DO: /* Etiqueta 6 */

       ASSIGN i-vert[i-cont] = 200
              i-hori[i-cont] = 170.

       PUT UNFORMATTED "^FT" string(70 + i-hori[i-cont]) "," string(140 + i-vert[i-cont]) "^BQN,2,4^FH\^FDLA," c-qrcode "^FS" SKIP.  /* C½digo de Barras do Nœmero de S²rie */
       
       PUT UNFORMATTED "^^FO" string(50 + i-hori[i-cont]) "," string(140 + i-vert[i-cont]) "^A0N,15,15^FB1000,1,0,L^FDPO:^FS" SKIP.
       PUT UNFORMATTED "^^FO" string(70 + i-hori[i-cont]) "," string(140 + i-vert[i-cont]) "^A0N,15,15^FB1000,1,0,L^FD999999^FS" SKIP. /* inserir pedido */
       
       PUT UNFORMATTED "^FO" string(50 + i-hori[i-cont]) "," string(160 + i-vert[i-cont]) "^BY1^BCN,25,N,N,N,N^FD" c-ID "^FS" SKIP.
       
       PUT UNFORMATTED "^FO" string(50 + i-hori[i-cont]) "," string(190 + i-vert[i-cont]) "^A0N,15,15^FB1000,1,0,L^FD" c-ID "^FS" SKIP.
       
       PUT UNFORMATTED "^FO" string(135 + i-hori[i-cont]) "," string(190 + i-vert[i-cont]) "^A0N,15,15^FB1000,1,0,L^FD" string(c-ch-acesso) "^FS" SKIP.
       
    END. /* FIM etiqueta 6 */

    WHEN 7 THEN DO: /* Etiqueta 7 */

       ASSIGN i-vert[i-cont] = 200
              i-hori[i-cont] = 340.

       PUT UNFORMATTED "^FT" string(70 + i-hori[i-cont]) "," string(140 + i-vert[i-cont]) "^BQN,2,4^FH\^FDLA," c-qrcode "^FS" SKIP.  /* C½digo de Barras do Nœmero de S²rie */
       
       PUT UNFORMATTED "^^FO" string(50 + i-hori[i-cont]) "," string(140 + i-vert[i-cont]) "^A0N,15,15^FB1000,1,0,L^FDPO:^FS" SKIP.
       PUT UNFORMATTED "^^FO" string(70 + i-hori[i-cont]) "," string(140 + i-vert[i-cont]) "^A0N,15,15^FB1000,1,0,L^FD999999^FS" SKIP. /* inserir pedido */
       
       PUT UNFORMATTED "^FO" string(50 + i-hori[i-cont]) "," string(160 + i-vert[i-cont]) "^BY1^BCN,25,N,N,N,N^FD" c-ID "^FS" SKIP.
       
       PUT UNFORMATTED "^FO" string(50 + i-hori[i-cont]) "," string(190 + i-vert[i-cont]) "^A0N,15,15^FB1000,1,0,L^FD" c-ID "^FS" SKIP.
       
       PUT UNFORMATTED "^FO" string(135 + i-hori[i-cont]) "," string(190 + i-vert[i-cont]) "^A0N,15,15^FB1000,1,0,L^FD" string(c-ch-acesso) "^FS" SKIP.
       
    END. /* FIM etiqueta 7 */

    WHEN 8 THEN DO: /* Etiqueta 8 */

       ASSIGN i-vert[i-cont] = 200
              i-hori[i-cont] = 510.

       PUT UNFORMATTED "^FT" string(70 + i-hori[i-cont]) "," string(140 + i-vert[i-cont]) "^BQN,2,4^FH\^FDLA," c-qrcode "^FS" SKIP.  /* C½digo de Barras do Nœmero de S²rie */
       
       PUT UNFORMATTED "^^FO" string(50 + i-hori[i-cont]) "," string(140 + i-vert[i-cont]) "^A0N,15,15^FB1000,1,0,L^FDPO:^FS" SKIP.
       PUT UNFORMATTED "^^FO" string(70 + i-hori[i-cont]) "," string(140 + i-vert[i-cont]) "^A0N,15,15^FB1000,1,0,L^FD999999^FS" SKIP. /* inserir pedido */
       
       PUT UNFORMATTED "^FO" string(50 + i-hori[i-cont]) "," string(160 + i-vert[i-cont]) "^BY1^BCN,25,N,N,N,N^FD" c-ID "^FS" SKIP.
       
       PUT UNFORMATTED "^FO" string(50 + i-hori[i-cont]) "," string(190 + i-vert[i-cont]) "^A0N,15,15^FB1000,1,0,L^FD" c-ID "^FS" SKIP.
       
       PUT UNFORMATTED "^FO" string(135 + i-hori[i-cont]) "," string(190 + i-vert[i-cont]) "^A0N,15,15^FB1000,1,0,L^FD" string(c-ch-acesso) "^FS" SKIP.
       
    END. /* FIM etiqueta 8 */

*/
END CASE.
