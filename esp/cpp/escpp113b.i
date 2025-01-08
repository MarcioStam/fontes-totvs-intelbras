DEFINE VARIABLE i-seq-qrcode AS INTEGER NO-UNDO.
DEFINE VARIABLE i-cont-aux   AS INTEGER NO-UNDO.
    
IF SUBSTRING(c-etiqueta,1,3) <> 'ECO' THEN DO:
    MESSAGE 'Faáa a leitura de uma Etiqueta ECO'
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.

    RETURN 'ERROR'.
END.

EMPTY TEMP-TABLE tt-qrcode-eco.

ASSIGN i-seq-qrcode = 1.

FOR EACH ns-volume NO-LOCK
    WHERE ns-volume.volume-pai = c-etiqueta 
    BREAK BY ns-volume.volume-filho:

    ASSIGN i-cont-aux = i-cont-aux + 1.

    IF i-cont-aux > 50 THEN DO:
       ASSIGN i-seq-qrcode = i-seq-qrcode + 1.
       ASSIGN i-cont-aux   = 1.
    END.

    FIND FIRST tt-qrcode-eco
         WHERE tt-qrcode-eco.volume-pai = ns-volume.volume-pai
           AND tt-qrcode-eco.seq-qrcode = i-seq-qrcode
    NO-ERROR.

    IF NOT AVAIL tt-qrcode-eco THEN DO:
       CREATE tt-qrcode-eco.
       ASSIGN tt-qrcode-eco.volume-pai = ns-volume.volume-pai
              tt-qrcode-eco.seq-qrcode = i-seq-qrcode 
              tt-qrcode-eco.contador   = 1
              tt-qrcode-eco.qrcode     = ns-volume.volume-filho.
    END.
    ELSE
       ASSIGN tt-qrcode-eco.contador  = tt-qrcode-eco.contador + 1
              tt-qrcode-eco.qrcode    = tt-qrcode-eco.qrcode + ';' + ns-volume.volume-filho.
        
    /*
    IF FIRST(ns-volume.volume-filho) THEN
       ASSIGN c-qrcode-eco = ns-volume.volume-filho.
    ELSE DO:
       ASSIGN c-qrcode-eco = c-qrcode-eco + ';' + ns-volume.volume-filho.
    END. */
END.

PUT "^XA"         SKIP.   /* Inicio Label */
PUT "^PW832"      SKIP.   /* Width 832 */
PUT "^MNY"        SKIP.   /* Papel de etiquetas n∆o continuo */
PUT "^MTT"        SKIP.   /* Papel Comum - usa ribon */
PUT "^BY2"        SKIP.   /* Magnitude EAN */ 
PUT "^PRA"        SKIP.   /* Velocidade 50mm/seg */
PUT "^JUS"        SKIP.   /* Grava Configuracao */
PUT "^XZ"         SKIP.

FOR EACH tt-qrcode-eco:

    PUT "^XA" SKIP.

    /*
    MESSAGE tt-qrcode-eco.contador skip(2) tt-qrcode-eco.qrcode 
        VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.*/
    
    IF tt-qrcode-eco.contador <= 5 THEN
       PUT UNFORMATTED "^FO60,30^BQR,2,5^FDQA," tt-qrcode-eco.qrcode "^FS" SKIP. 
    ELSE DO:
      
       IF tt-qrcode-eco.contador <= 20 THEN
          PUT UNFORMATTED "^FO50,20^BQR,2,3^FDQA," tt-qrcode-eco.qrcode "^FS" SKIP.  
       ELSE 
          PUT UNFORMATTED "^FO50,20^BQR,2,2^FDQA," tt-qrcode-eco.qrcode "^FS" SKIP.  
    END.

    PUT "^PQ" STRING(1, "99999") SKIP.  /* Quantidade de etiquetas a imprimir */
    PUT "^XZ" SKIP.
END.

