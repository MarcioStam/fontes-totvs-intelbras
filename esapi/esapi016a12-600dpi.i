/*------------------------------------------------------------------------------
  Purpose:    Etiqueta (24x8mm)
  Notes:      Emerson Colla - 23/12/2016
  Parameters:  1-Quandrupla, 2-Qu¡ntupla
------------------------------------------------------------------------------*/

CASE item-ean.etiq-1-tipo: 
    WHEN 1 THEN DO: /* N£m S‚rie */
        PUT UNFORMATTED "^FO1260,700^ABN,36,20^FB650,1,0,C^FD" item-ean.nome-abrev "^FS" SKIP. 
        PUT UNFORMATTED "^FO1260,770^ABN,36,20^FB650,1,0,C^FDNS:" num-serie.n-serie  "^FS" SKIP. 
    END.
    WHEN 2 THEN /*C¢d. Item.*/
        PUT UNFORMATTED "^FO440,265^A0N,28,28^FB210,1,0,C^FD" item-ean.it-codigo "^FS" SKIP. 
    WHEN 3 THEN DO: /* Outros */
        PUT UNFORMATTED "^FO425,265^A0N,20,18^FB210,1,0,C^FD"    item-ean.etiq-1-info[1] "^FS" SKIP. 
        PUT UNFORMATTED "^FO425,285^A0N,20,18^FB210,1,0,C^FD" item-ean.etiq-1-info[2] "^FS" SKIP. 
    END.
    WHEN 4 THEN DO:
        PUT UNFORMATTED "^FO1500,650^XGlocal-anatel.GRF^FS" /* Impressao da Imagem ANATEL */ 
                        "^FO1260,770^ABN,36,15^FB650,1,0,C^FD" item-ean.homolog "^FS"   SKIP.
    END.
    WHEN 6 THEN DO: /* Homogacao + Origem */
        PUT UNFORMATTED "^FO1260,700^ABN,36,15^FB650,1,0,C^FDANATEL: " item-ean.homolog "^FS" SKIP. 
        PUT UNFORMATTED "^FH^FO1260,770^ABN,36,15^FB650,1,0,C^FD" REPLACE(item-ean.origem,'é','_e9')  "^FS" SKIP. 
    END.

END CASE.
        

CASE item-ean.etiq-2-tipo: 
    WHEN 1 THEN DO: /* N£m S‚rie */
        PUT UNFORMATTED "^FO1870,710^ABN,36,20^FB650,1,0,C^FD" item-ean.nome-abrev "^FS" SKIP. 
        PUT UNFORMATTED "^FO1870,770^ABN,36,20^FB650,1,0,C^FDNS:" num-serie.n-serie  "^FS" SKIP. 
    END.
    WHEN 2 THEN /*C¢d. Item.*/
        PUT UNFORMATTED "^FO650,265^A0N,28,28^FB210,1,0,C^FD" item-ean.it-codigo "^FS" SKIP. 
    WHEN 3 THEN DO: /* Outros */
        PUT UNFORMATTED "^FO635,265^A0N,20,18^FB210,1,0,C^FD" item-ean.etiq-2-info[1] "^FS" SKIP. 
        PUT UNFORMATTED "^FO635,285^A0N,20,18^FB210,1,0,C^FD" item-ean.etiq-2-info[2]  "^FS" SKIP. 
    END.
    WHEN 4 THEN DO:
        PUT UNFORMATTED "^FO2100,650^XGlocal-anatel.GRF^FS" /* Impressao da Imagem ANATEL */ 
                        "^FO1870,770^ABN,36,15^FB650,1,0,C^FD" item-ean.homolog "^FS"   SKIP.
    END.
    WHEN 6 THEN DO: /* Homogacao + Origem */
        PUT UNFORMATTED "^FO1870,710^ABN,36,15^FB650,1,0,C^FDANATEL: " item-ean.homolog "^FS" SKIP. 
        PUT UNFORMATTED "^FH^FO1870,770^ABN,36,15^FB650,1,0,C^FD" REPLACE(item-ean.origem,'é','_e9') "^FS" SKIP. 
    END.
END CASE.
   

IF "{1}" = "2" THEN DO:
    CASE item-ean.etiq-3-tipo:
        WHEN 6 THEN DO: /* Homogacao + Origem */
            PUT UNFORMATTED "^FO2310,20^ABB,36,15^FB570,1,0,C^FDANATEL:" item-ean.homolog "^FS" SKIP. 
            PUT UNFORMATTED "^FO2380,20^ABB,36,15^FB570,1,0,C^FDNS:" item-ean.origem "^FS" SKIP.
        END.
        WHEN 4 THEN DO:
            PUT UNFORMATTED "^FO2100,650^XGlocal-anatel-lado.GRF^FS" /* Impressao da Imagem ANATEL */ 
                            "^FO1870,770^ABN,36,15^FB650,1,0,C^FD" item-ean.homolog "^FS"   SKIP.
        END.
        OTHERWISE DO:
            PUT UNFORMATTED "^FO2310,20^ABB,36,20^FB570,1,0,C^FD" item-ean.nome-abrev "^FS" SKIP. 
            PUT UNFORMATTED "^FO2380,20^ABB,36,20^FB570,1,0,C^FDNS:" num-serie.n-serie "^FS" SKIP.
        END.
    END.
END.

/*
IF "{1}" = "2" THEN DO:
    PUT UNFORMATTED "^FO782,20^A0B,20,18^FB170,1,0,C^FD" item-ean.nome-abrev "^FS" SKIP. 
    PUT UNFORMATTED "^FO807,20^A0B,20,18^FB170,1,0,C^FDNS:" num-serie.n-serie "^FS" SKIP.
END.
*/
