/*------------------------------------------------------------------------------
  Purpose:    Etiqueta (24x8mm)
  Notes:      Emerson Colla - 23/12/2016
  Parameters:  1-Quandrupla, 2-Qu¡ntupla
------------------------------------------------------------------------------*/
CASE item-ean.etiq-1-tipo: 
    WHEN 1 THEN DO: /* N£m S‚rie */
     //   PUT UNFORMATTED "^FO435,235^ABN^FB210,1,0,C^FD" item-ean.nome-abrev "^FS" SKIP. 
     //   PUT UNFORMATTED "^FO435,255^ABN^FB210,1,0,C^FDNS:" num-serie.n-serie  "^FS" SKIP. 
        PUT UNFORMATTED "^FO420,230^A0N,13,13^FB200,1,0,C^FD" CAPS(item-ean.nome-abrev) "^FS" SKIP.
        PUT UNFORMATTED "^FO420,250^ABN^FB210,1,0,C^FDNS:" num-serie.n-serie  "^FS" SKIP. 
    END.
    WHEN 2 THEN /*C¢d. Item.*/
        PUT UNFORMATTED "^FO440,235^A0N,28,28^FB210,1,0,C^FD" item-ean.it-codigo "^FS" SKIP. 
    WHEN 3 THEN DO: /* Outros */
        PUT UNFORMATTED "^FO415,235^A0N,20,18^FB210,1,0,C^FD"    item-ean.etiq-1-info[1] "^FS" SKIP. 
        PUT UNFORMATTED "^FO415,255^A0N,20,18^FB210,1,0,C^FD" item-ean.etiq-1-info[2] "^FS" SKIP. 
    END.
    WHEN 4 THEN DO:
        PUT UNFORMATTED "^FO430,204^XGlocal-anatelpp.GRF^FS" /* Impressao da Imagem ANATEL */ 
                        "^FO400,240^A0N,14,14^FB200,1,0,R^FD" item-ean.homolog "^FS"   SKIP.
    END.
    WHEN 6 THEN DO:
        PUT UNFORMATTED "^FO420,230^A0N,13,13^FB200,1,0,C^FDANATEL: " item-ean.homolog "^FS" SKIP.
        PUT UNFORMATTED "^FH^FO420,250^A0N,13,13^FB200,1,0,C^FD" REPLACE(item-ean.origem,'é','_e9')   "^FS" SKIP. 
    END.
END CASE.
        

CASE item-ean.etiq-2-tipo: 
    WHEN 1 THEN DO: /* N£m S‚rie */
       // PUT UNFORMATTED "^FO645,235^ABN^FB210,1,0,C^FD" item-ean.nome-abrev "^FS" SKIP. 
       // PUT UNFORMATTED "^FO645,255^ABN^FB210,1,0,C^FDNS:" num-serie.n-serie  "^FS" SKIP. 
        PUT UNFORMATTED "^FO630,230^A0N,13,13^FB200,1,0,C^FD" CAPS(item-ean.nome-abrev) "^FS" SKIP. 
        PUT UNFORMATTED "^FO630,250^ABN^FB210,1,0,C^FDNS:" num-serie.n-serie  "^FS" SKIP. 

    END.
    WHEN 2 THEN /*C¢d. Item.*/
        PUT UNFORMATTED "^FO650,235^A0N,28,28^FB210,1,0,C^FD" item-ean.it-codigo "^FS" SKIP. 
    WHEN 3 THEN DO: /* Outros */
        PUT UNFORMATTED "^FO635,235^A0N,20,18^FB210,1,0,C^FD" item-ean.etiq-2-info[1] "^FS" SKIP. 
        PUT UNFORMATTED "^FO635,255^A0N,20,18^FB210,1,0,C^FD" item-ean.etiq-2-info[2]  "^FS" SKIP. 
    END.
  /*  WHEN 4 THEN DO:
        PUT UNFORMATTED "^FO650,204^XGlocal-anatelpp.GRF^FS" /* Impressao da Imagem ANATEL */ 
                        "^FO620,240^A0N,14,14^FB200,1,0,R^FD" item-ean.homolog "^FS"   SKIP.
    END.*/
    WHEN 6 THEN DO:
        PUT UNFORMATTED "^FO630,230^A0N,13,13^FB200,1,0,C^FDANATEL: " item-ean.homolog "^FS" SKIP. 
        PUT UNFORMATTED "^FH^FO630,250^A0N,13,13^FB200,1,0,C^FD" REPLACE(item-ean.origem,'é','_e9')  "^FS" SKIP. 
    END.
END CASE.

IF "{1}" = "2" THEN DO:
    CASE item-ean.etiq-3-tipo: 
        WHEN 1 THEN DO: /* N£m S‚rie */
            PUT UNFORMATTED "^FO790,10^A0B,13,13^FB200,1,0,C^FD" CAPS(item-ean.nome-abrev) "^FS" SKIP.
            PUT UNFORMATTED "^FO807,20^ABB^FB170,1,0,C^FDNS:" num-serie.n-serie "^FS" SKIP.
        END.
        WHEN 2 THEN /*C¢d. Item.*/
            PUT UNFORMATTED "^FO790,10^A0B,28,28^FB200,1,0,C^FD" item-ean.it-codigo "^FS" SKIP. 
        WHEN 3 THEN DO: /* Outros */
            PUT UNFORMATTED "^FO790,10^A0B,20,18^FB200,1,0,C^FD"    item-ean.etiq-3-info[1] "^FS" SKIP. 
            PUT UNFORMATTED "^FO807,10^A0B,20,18^FB200,1,0,C^FD" item-ean.etiq-3-info[2] "^FS" SKIP. 
        END.
        WHEN 6 THEN DO:
            PUT UNFORMATTED "^FO790,10^A0B,13,13^FB200,1,0,C^FDANATEL: " item-ean.homolog "^FS" SKIP.
            PUT UNFORMATTED "^FH^FO807,20^A0B,13,13^FB200,1,0,C^FD" REPLACE(item-ean.origem,'é','_e9') "^FS" SKIP.
        END.
    END CASE.
END.

   
/*

IF "{1}" = "2" THEN DO:
   // PUT UNFORMATTED "^FO782,20^ABB^FB170,1,0,C^FD" item-ean.nome-abrev "^FS" SKIP.
    PUT UNFORMATTED "^FO790,10^A0B,13,13^FB200,1,0,C^FD" CAPS(item-ean.nome-abrev) "^FS" SKIP.
    PUT UNFORMATTED "^FO807,20^ABB^FB170,1,0,C^FDNS:" num-serie.n-serie "^FS" SKIP.
END.*/

/*
IF "{1}" = "2" THEN DO:
    PUT UNFORMATTED "^FO782,20^A0B,20,18^FB170,1,0,C^FD" item-ean.nome-abrev "^FS" SKIP. 
    PUT UNFORMATTED "^FO807,20^A0B,20,18^FB170,1,0,C^FDNS:" num-serie.n-serie "^FS" SKIP.
END.
*/
