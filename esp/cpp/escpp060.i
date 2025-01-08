DEFINE VARIABLE c-mac        AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-mac-gpon   AS CHARACTER   NO-UNDO EXTENT 3.
DEFINE VARIABLE c-mac-QRCode AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i            AS INTEGER     NO-UNDO.
DEFINE VARIABLE c-master     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-acesso     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i-conta      AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-seq        AS INTEGER     NO-UNDO.
DEFINE VARIABLE iColuna      AS INTEGER     NO-UNDO.

IF VALID-HANDLE(h-acomp) THEN
    RUN pi-seta-titulo IN h-acomp (INPUT IF pTpImpressao = "1" THEN "Imprimindo etiqueta..."
                                         ELSE "Imprimindo etiqueta...").
//TARGET "IBM850" SOURCE "ISO8859-1".
IF v_nom_disposit_so NE "" 
THEN DO:
    
    IF item-ean.modelo-mac-address <> 7 
    THEN OUTPUT TO VALUE(v_nom_disposit_so) PAGE-SIZE 0 CONVERT TARGET SESSION:CHARSET.
        //OUTPUT TO VALUE ("C:\temp\teste-etqMAC.txt").
    ELSE OUTPUT TO VALUE(v_nom_disposit_so) PAGE-SIZE 0 CONVERT TARGET "IBM850" SOURCE "ISO8859-1".
    //OUTPUT TO VALUE ("C:\temp\teste-etqMAC.txt").
   
END.
ELSE DO:
    RUN utp/ut-msgs.p (INPUT "SHOW":U,
                       INPUT 17006,
                       INPUT "Impressora invÿlida!":U).

    RETURN "NOK":U.
END.

PUT "^XA"    SKIP.   /* Inicio Label */
PUT "^PW832" SKIP.   /* Width 832 */
PUT "^MNY"   SKIP.   /* Papel de etiquetas n’o continuo */
PUT "^MTT"   SKIP.   /* Papel Comum - usa ribon */
PUT "^BY2"   SKIP.   /* Magnitude EAN */ 
PUT "^PRA"   SKIP.   /* Velocidade 50mm/seg */
PUT "^JUS"   SKIP.   /* Grava Configuracao */
PUT "^PON"   SKIP.
PUT "^FWN"   SKIP.
PUT "^LL296" SKIP.
PUT "^XZ"    SKIP.


/************************* COM C…DIGO DE BARRAS SIMPLES *******************************/
IF item-ean.modelo-mac-address < 3 OR item-ean.modelo-mac-address = 9 THEN DO: /* ELSE DO */

    ASSIGN iColuna = 1
           c-mac = "".
    
    FOR EACH tt-mac-address USE-INDEX ch-pri NO-LOCK
        WHERE tt-mac-address.impresso = YES:

        IF VALID-HANDLE(h-acomp) THEN
            RUN pi-acompanhar IN h-acomp (INPUT "MAC: ":U + tt-mac-address.mac).

        /* COM FORMATA°€O */
        IF rs-formata:SCREEN-VALUE IN FRAME fPage0 = "1" THEN DO:
    
            IF iColuna = 1 THEN DO:
                
                PUT "^XA" SKIP.
    
                ASSIGN c-mac =  SUBSTRING (tt-mac-address.mac,1,2) + "?" +
                                SUBSTRING (tt-mac-address.mac,3,2) + "?" +
                                SUBSTRING (tt-mac-address.mac,5,2) + "?" +
                                SUBSTRING (tt-mac-address.mac,7,2) + "?" +
                                SUBSTRING (tt-mac-address.mac,9,2) + "?" +
                                SUBSTRING (tt-mac-address.mac,11,2).
    
                /************ CODIGO DE BARRAS + GPONSN ***************/
                IF item-ean.modelo-mac-address = 2 /* tg-gponsn:CHECKED IN FRAME fpage0 */ THEN DO:
                    PUT UNFORMATTED "^FO40,3^BY1,2.0,10 ^BCN,50,N,N,N,N^FD" c-mac "^FS" SKIP. 
                   
                    PUT UNFORMATTED "^FO35,58^A0N,15,15^FD"
                        SUBSTRING (tt-mac-address.mac,1,2) + ":" +              
                        SUBSTRING (tt-mac-address.mac,3,2) + ":" +             
                        SUBSTRING (tt-mac-address.mac,5,2) + ":" +             
                        SUBSTRING (tt-mac-address.mac,7,2) + ":" +             
                        SUBSTRING (tt-mac-address.mac,9,2) + ":" +             
                        SUBSTRING (tt-mac-address.mac,11,2) "^FS" SKIP. 
    
                    
                        PUT UNFORMATTED "^FO163,58^A0N,15,15^FDGPONSN:"
                                        SUBSTRING (tt-mac-address.mac,5,2) +
                                        SUBSTRING (tt-mac-address.mac,7,2) +
                                        SUBSTRING (tt-mac-address.mac,9,2) +           
                                        SUBSTRING (tt-mac-address.mac,11,2) "^FS" SKIP. 
                END.
                ELSE DO:
                    PUT UNFORMATTED "^FO40,3^BY1,2.0,10 ^BCN,50,N,N,N,N^FD" c-mac "^FS" SKIP. 

                    PUT UNFORMATTED "^FO50,57^ADN1^FD"
                        SUBSTRING (tt-mac-address.mac,1,2) + ":" +              
                        SUBSTRING (tt-mac-address.mac,3,2) + ":" +             
                        SUBSTRING (tt-mac-address.mac,5,2) + ":" +             
                        SUBSTRING (tt-mac-address.mac,7,2) + ":" +             
                        SUBSTRING (tt-mac-address.mac,9,2) + ":" +             
                        SUBSTRING (tt-mac-address.mac,11,2) "^FS" SKIP. 
                END.
    
               ASSIGN iColuna = 2.
            END.
            ELSE DO:
    
                ASSIGN c-mac =  SUBSTRING (tt-mac-address.mac,1,2) + "?" +
                                SUBSTRING (tt-mac-address.mac,3,2) + "?" +
                                SUBSTRING (tt-mac-address.mac,5,2) + "?" +
                                SUBSTRING (tt-mac-address.mac,7,2) + "?" +
                                SUBSTRING (tt-mac-address.mac,9,2) + "?" +
                                SUBSTRING (tt-mac-address.mac,11,2).

                /************ SOMENTE CODIGO DE BARRAS ***************/
                IF item-ean.modelo-mac-address  = 1 OR 
                    item-ean.modelo-mac-address = 9 /* NOT tg-gponsn:CHECKED IN FRAME fpage0 */ THEN DO:
                    PUT UNFORMATTED "^FO340,3^BY1,2.0,10 ^BCN,50,N,N,N^FD" c-mac "^FS" SKIP. 
                    
                    PUT UNFORMATTED "^FO350,57^ADN1^FD"
                        SUBSTRING (tt-mac-address.mac,1,2) + ":" +            
                        SUBSTRING (tt-mac-address.mac,3,2) + ":" +            
                        SUBSTRING (tt-mac-address.mac,5,2) + ":" +            
                        SUBSTRING (tt-mac-address.mac,7,2) + ":" +            
                        SUBSTRING (tt-mac-address.mac,9,2) + ":" +            
                        SUBSTRING (tt-mac-address.mac,11,2) "^FS" SKIP.
                END.
                ELSE DO:

                    PUT UNFORMATTED "^FO340,3^BY1,2.0,10 ^BCN,50,N,N,N,N^FD" c-mac "^FS" SKIP. 

                    PUT UNFORMATTED "^FO335,58^A0N,15,15^FD"
                        SUBSTRING (tt-mac-address.mac,1,2) + ":" +              
                        SUBSTRING (tt-mac-address.mac,3,2) + ":" +             
                        SUBSTRING (tt-mac-address.mac,5,2) + ":" +             
                        SUBSTRING (tt-mac-address.mac,7,2) + ":" +             
                        SUBSTRING (tt-mac-address.mac,9,2) + ":" +             
                        SUBSTRING (tt-mac-address.mac,11,2) "^FS" SKIP. 
                    
                        PUT UNFORMATTED "^FO463,58^A0N,15,15^FDGPONSN:"
                                        SUBSTRING (tt-mac-address.mac,5,2) +
                                        SUBSTRING (tt-mac-address.mac,7,2) +
                                        SUBSTRING (tt-mac-address.mac,9,2) +           
                                        SUBSTRING (tt-mac-address.mac,11,2) "^FS" SKIP. 

                END.
    
                PUT "^XZ" SKIP.
                
                ASSIGN iColuna = 1.
            END.
        END.
        /* SEM FORMATA°€O */
        ELSE DO:
    

            /* C…DIGO DE BARRAS */
            IF item-ean.modelo-mac-address = 1 /* NOT tg-gponsn:CHECKED IN FRAME fpage0 */ THEN DO:
                IF iColuna = 1 THEN DO:
                    PUT "^XA" SKIP.
                    PUT UNFORMATTED "^FO63,3^BY1,2.0,10 ^BCN,50,N,N,N,N^FD"  tt-mac-address.mac  "^FS" SKIP.
                    PUT UNFORMATTED "^FO50,57^ADN^FDMAC:" tt-mac-address.mac "^FS" SKIP.
             
                    ASSIGN iColuna = 2.
                END.
                ELSE DO: 
                    PUT UNFORMATTED "^FO363,3^BY1,2.0,10 ^BCN,50,N,N,N^FD" tt-mac-address.mac "^FS" SKIP.
                    PUT UNFORMATTED "^FO350,57^ADN^FDMAC:" tt-mac-address.mac "^FS" SKIP.
                    PUT "^XZ" SKIP.
             
                    ASSIGN iColuna = 1.
                END.
            END.
            ELSE DO:

                IF iColuna = 1 THEN DO:
                    PUT "^XA" SKIP.
                    PUT UNFORMATTED "^FO63,3^BY1,2.0,10 ^BCN,50,N,N,N,N^FD" tt-mac-address.mac "^FS" SKIP. 
                    PUT UNFORMATTED "^FO35,58^A0N,15,15^FDMAC:" tt-mac-address.mac "^FS" SKIP.

                    IF item-ean.modelo-mac-address NE 9 THEN
                        PUT UNFORMATTED "^FO163,58^A0N,15,15^FDGPONSN:" SUBSTRING (tt-mac-address.mac,5,2) +
                                                                        SUBSTRING (tt-mac-address.mac,7,2) +
                                                                        SUBSTRING (tt-mac-address.mac,9,2) +
                                                                        SUBSTRING (tt-mac-address.mac,11,2) "^FS" SKIP. 
                        
                    ASSIGN iColuna = 2.
                END.
                ELSE DO: 
                    PUT UNFORMATTED "^FO363,3^BY1,2.0,10 ^BCN,50,N,N,N,N^FD" tt-mac-address.mac "^FS" SKIP.
                    PUT UNFORMATTED "^FO331,58^A0N,15,15^FDMAC:" tt-mac-address.mac "^FS" SKIP.

                    IF item-ean.modelo-mac-address NE 9 THEN
                        PUT UNFORMATTED "^FO459,58^A0N,15,15^FDGPONSN:" SUBSTRING (tt-mac-address.mac,5,2) +
                                                                        SUBSTRING (tt-mac-address.mac,7,2) +
                                                                        SUBSTRING (tt-mac-address.mac,9,2) +
                                                                        SUBSTRING (tt-mac-address.mac,11,2) "^FS" SKIP. 
                    PUT "^XZ" SKIP.
             
                    ASSIGN iColuna = 1.
                END.

            END.
        END.
        
        IF  pTpImpressao = "2" THEN do: /* Reinpress’o */
            FIND FIRST mac-address
                WHERE ROWID(mac-address) = tt-mac-address.r-Rowid EXCLUSIVE-LOCK NO-ERROR.
        
            IF AVAILABLE mac-address THEN
                ASSIGN mac-address.re-impr   = mac-address.re-impr + 1
                       mac-address.dt-ult-re = NOW
                       mac-address.us-ult-re = c-seg-usuario.
                       /*mac-address.motiv-re  = pMotivo.*/
        END.
    END.
    
    IF iColuna = 2 THEN
        PUT "^XZ" SKIP.
END.

/************************* SOMENTE QR-CODE *******************************/
IF item-ean.modelo-mac-address = 3 /* pCodBarras = "2" */ THEN DO:

    ASSIGN iColuna = 1
           c-mac = "".
    
    FOR EACH tt-mac-address USE-INDEX ch-pri NO-LOCK
        WHERE tt-mac-address.impresso = YES:
        IF VALID-HANDLE(h-acomp) THEN
            RUN pi-acompanhar IN h-acomp (INPUT "MAC: ":U + tt-mac-address.mac).
        
        /* COM FORMATA°€O */
        IF rs-formata:SCREEN-VALUE IN FRAME fPage0 = "1" THEN DO:
    
            ASSIGN c-mac =  SUBSTRING (tt-mac-address.mac,1,2) + "?" +
                            SUBSTRING (tt-mac-address.mac,3,2) + "?" +
                            SUBSTRING (tt-mac-address.mac,5,2) + "?" +
                            SUBSTRING (tt-mac-address.mac,7,2) + "?" +
                            SUBSTRING (tt-mac-address.mac,9,2) + "?" +
                            SUBSTRING (tt-mac-address.mac,11,2).
            
            ASSIGN c-mac-QRCode = SUBSTRING (tt-mac-address.mac,1,2) + ":" +              
                                  SUBSTRING (tt-mac-address.mac,3,2) + ":" +             
                                  SUBSTRING (tt-mac-address.mac,5,2) + ":" +             
                                  SUBSTRING (tt-mac-address.mac,7,2) + ":" +             
                                  SUBSTRING (tt-mac-address.mac,9,2) + ":" +             
                                  SUBSTRING (tt-mac-address.mac,11,2). 
            CASE iColuna:
                WHEN 1 THEN DO:
                    PUT "^XA" SKIP.
                    PUT UNFORMATTED "^FO32,30^BQN,2,6^FDQA," c-mac "^FS" SKIP.  /* QR Code */
                    PUT UNFORMATTED "^FO31,210^A0N,20,20^FD" c-mac-QRCode "^FS" SKIP.
             
                    ASSIGN iColuna = 2.
                END.
                WHEN 2 THEN DO:
                    PUT UNFORMATTED "^FO246,30^BQN,2,6^FDQA," c-mac "^FS" SKIP. 
                    PUT UNFORMATTED "^FO245,210^A0N,20,20^FD" c-mac-QRCode "^FS" SKIP.
             
                    ASSIGN iColuna = 3.
                END.
                WHEN 3 THEN DO:
                    PUT UNFORMATTED "^FO460,30^BQN,2,6^FDQA," c-mac "^FS" SKIP. 
                    PUT UNFORMATTED "^FO459,210^A0N,20,20^FD" c-mac-QRCode "^FS" SKIP.
             
                    ASSIGN iColuna = 4.
                END.
                WHEN 4 THEN DO:
                    PUT UNFORMATTED "^FO674,30^BQN,2,6^FDQA," c-mac "^FS" SKIP. 
                    PUT UNFORMATTED "^FO673,210^A0N,20,20^FD" c-mac-QRCode "^FS" SKIP.
                    PUT "^XZ" SKIP.
             
                    ASSIGN iColuna = 1.
                END.
            END CASE.
        END.
        /* SEM FORMATA°€O */
        ELSE DO:

            CASE iColuna:
                WHEN 1 THEN DO:
                    PUT "^XA" SKIP.
                    PUT UNFORMATTED "^FO46,40^BQN,2,6^FDQA," tt-mac-address.mac "^FS" SKIP.  /* QR Code */
                    PUT UNFORMATTED "^FO43,200^A0N,16,16^FDMAC:" tt-mac-address.mac "^FS" SKIP.
             
                    ASSIGN iColuna = 2.
                END.
                WHEN 2 THEN DO:
                    PUT UNFORMATTED "^FO260,40^BQN,2,6^FDQA," tt-mac-address.mac "^FS" SKIP. 
                    PUT UNFORMATTED "^FO257,200^A0N,16,16^FDMAC:" tt-mac-address.mac "^FS" SKIP.
             
                    ASSIGN iColuna = 3.
                END.
                WHEN 3 THEN DO:
                    PUT UNFORMATTED "^FO475,40^BQN,2,6^FDQA," tt-mac-address.mac "^FS" SKIP. 
                    PUT UNFORMATTED "^FO472,200^A0N,16,16^FDMAC:" tt-mac-address.mac "^FS" SKIP.
             
                    ASSIGN iColuna = 4.
                END.
                WHEN 4 THEN DO:
                    PUT UNFORMATTED "^FO689,40^BQN,2,6^FDQA," tt-mac-address.mac "^FS" SKIP. 
                    PUT UNFORMATTED "^FO686,200^A0N,16,16^FDMAC:" tt-mac-address.mac "^FS" SKIP.
                    PUT "^XZ" SKIP.
             
                    ASSIGN iColuna = 1.
                END.
            END CASE.
            
        END.
        
        IF  pTpImpressao = "2" THEN do: /* Reinpress’o */
            FIND FIRST mac-address
                WHERE ROWID(mac-address) = tt-mac-address.r-Rowid EXCLUSIVE-LOCK NO-ERROR.
        
            IF AVAILABLE mac-address THEN
                ASSIGN mac-address.re-impr   = mac-address.re-impr + 1
                       mac-address.dt-ult-re = NOW
                       mac-address.us-ult-re = c-seg-usuario
                       mac-address.motiv-re  = pMotivo.
        END.
    END.

    IF iColuna <> 1 THEN
        PUT "^XZ" SKIP.
END.

/************************* QR-CODE COM SENHA MASTER *****************************/
IF item-ean.modelo-mac-address = 4 THEN DO:

    ASSIGN iColuna = 1
           c-mac = "".
    
    FOR EACH tt-mac-address USE-INDEX ch-pri NO-LOCK
        WHERE tt-mac-address.impresso = YES:
        IF VALID-HANDLE(h-acomp) THEN
            RUN pi-acompanhar IN h-acomp (INPUT "MAC: ":U + tt-mac-address.mac).
        

        IF pTpImpressao = "1" /* Impressao */ THEN DO:
            FIND CURRENT tt-mac-address EXCLUSIVE-LOCK NO-ERROR.
            IF AVAIL tt-mac-address THEN 
                ASSIGN tt-mac-address.senha-master = INT(fnGeraSenha("master", "")).
            FIND FIRST mac-address
                WHERE mac-address.mac = tt-mac-address.mac EXCLUSIVE-LOCK NO-ERROR.
            IF AVAIL mac-address THEN
                ASSIGN mac-address.senha-master = tt-mac-address.senha-master.
        END.

        ASSIGN c-master = string(tt-mac-address.senha-master,"9999").

        /* SEM FORMATA°€O */

        /* ETIQUETA DUN 14 SIMPLES */
        PUT "^XA" SKIP.
        PUT UNFORMATTED "^FO110,75^A0N,26,19^FDINTELBRAS CLOUD^FS" SKIP. 
        PUT UNFORMATTED "^FO110,90^BQN,2,6^FDQA," tt-mac-address.mac "#" c-master "#" c-acesso "^FS" SKIP.  /* QR Code */
        PUT UNFORMATTED "^FO300,120^A0N,24,16^FDMAC: " tt-mac-address.mac "^FS" SKIP.
        PUT UNFORMATTED "^FO300,190^A0N,24,16^FDSENHA MASTER: " c-master "^FS" SKIP.

        PUT UNFORMATTED "^FO645,20^A0B,20,20^FB170,1,0,C^FDMAC:" tt-mac-address.mac "^FS" SKIP.

        /*********** NAO APAGAR - IMPRESSAO PARA ETIQUETA DUN 14 DUPLA - SERAH UTILIZADA FUTURAMENTE *********
        CASE iColuna:
            WHEN 1 THEN DO:
                PUT "^XA" SKIP.
                PUT UNFORMATTED "^FO46,75^A0N,26,19^FDINTELBRAS CLOUD^FS" SKIP. 
                PUT UNFORMATTED "^FO46,90^BQN,2,6^FDQA," tt-mac-address.mac "#" c-master "^FS" SKIP.  /* QR Code */
                PUT UNFORMATTED "^FO220,145^A0N,24,16^FDMAC: " tt-mac-address.mac "^FS" SKIP.
                PUT UNFORMATTED "^FO220,215^A0N,24,16^FDSENHA MASTER: " c-master "^FS" SKIP.
                ASSIGN iColuna = 2.
            END.
            WHEN 2 THEN DO:
                PUT UNFORMATTED "^FO470,75^A0N,26,19^FDINTELBRAS CLOUD^FS" SKIP. 
                PUT UNFORMATTED "^FO470,90^BQN,2,6^FDQA," tt-mac-address.mac "#" c-master "^FS" SKIP. 
                PUT UNFORMATTED "^FO644,145^A0N,24,16^FDMAC: " tt-mac-address.mac "^FS" SKIP.
                PUT UNFORMATTED "^FO644,215^A0N,24,16^FDSENHA MASTER: " c-master "^FS" SKIP.
                ASSIGN iColuna = 1.
            END.
        END CASE.
        ****************************************************************************************************/
        
        IF  pTpImpressao = "2" THEN do: /* Reimpress’o */
            /*
            FIND FIRST mac-address
                WHERE ROWID(mac-address) = tt-mac-address.r-Rowid EXCLUSIVE-LOCK NO-ERROR.
              */
            IF AVAILABLE mac-address THEN
                ASSIGN mac-address.re-impr   = mac-address.re-impr + 1
                       mac-address.dt-ult-re = NOW
                       mac-address.us-ult-re = c-seg-usuario
                       mac-address.motiv-re  = pMotivo.
        END.

        IF iColuna = 1 THEN
        PUT "^XZ" SKIP.
    END.

    IF iColuna <> 1 THEN
        PUT "^XZ" SKIP.
END.

/************************* QR-CODE COM SENHA MASTER E ACESSO REMOTO *****************************/
IF item-ean.modelo-mac-address = 5 THEN DO:

    ASSIGN iColuna = 1
           c-mac = "".
    
    FOR EACH tt-mac-address USE-INDEX ch-pri NO-LOCK
        WHERE tt-mac-address.impresso = YES:
        IF VALID-HANDLE(h-acomp) THEN
            RUN pi-acompanhar IN h-acomp (INPUT "MAC: ":U + tt-mac-address.mac).
        

       IF pTpImpressao = "1" /* Impressao */ THEN DO:
           FIND CURRENT tt-mac-address EXCLUSIVE-LOCK NO-ERROR.
           IF AVAIL tt-mac-address THEN 
               ASSIGN tt-mac-address.senha-master = INT(fnGeraSenha("master", ""))
                      tt-mac-address.senha-acesso = INT(fnGeraSenha("remoto", STRING(tt-mac-address.senha-master,"9999"))).

           FIND FIRST mac-address
                WHERE mac-address.mac = tt-mac-address.mac EXCLUSIVE-LOCK NO-ERROR.

            IF AVAIL mac-address THEN
                ASSIGN mac-address.senha-master = tt-mac-address.senha-master
                       mac-address.senha-acesso = tt-mac-address.senha-acesso.
       END.

       ASSIGN c-master = string(tt-mac-address.senha-master,"9999")
              c-acesso = string(tt-mac-address.senha-acesso,"999999").

       /* SEM FORMATA°€O */

       /* ETIQUETA DUN 14 SIMPLES */
       PUT "^XA" SKIP.
       PUT UNFORMATTED "^FO80,75^A0N,26,19^FDINTELBRAS CLOUD^FS" SKIP. 
       PUT UNFORMATTED "^FO80,90^BQN,2,6^FDQA," tt-mac-address.mac "#" c-master "#" c-acesso "^FS" SKIP.  /* QR Code */
       PUT UNFORMATTED "^FO270,90^A0N,24,16^FDMAC: " tt-mac-address.mac "^FS" SKIP.
       PUT UNFORMATTED "^FO270,160^A0N,24,16^FDSENHA MASTER: " c-master "^FS" SKIP.
       PUT UNFORMATTED "^FO270,230^A0N,24,16^FDSENHA ACESSO REMOTO: " c-acesso "^FS" SKIP.

       PUT UNFORMATTED "^FO645,20^A0B,20,20^FB170,1,0,C^FDMAC:" tt-mac-address.mac "^FS" SKIP.

       
       /*********** NAO APAGAR - IMPRESSAO PARA ETIQUETA DUN 14 DUPLA - SERAH UTILIZADA FUTURAMENTE *********
       CASE iColuna:
          WHEN 1 THEN DO:
              PUT "^XA" SKIP.
              PUT UNFORMATTED "^FO46,55^A0N,26,19^FDINTELBRAS CLOUD^FS" SKIP. 
              PUT UNFORMATTED "^FO46,70^BQN,2,6^FDQA," tt-mac-address.mac "#" c-master "#" c-acesso "^FS" SKIP.  /* QR Code */
              PUT UNFORMATTED "^FO220,125^A0N,24,16^FDMAC: " tt-mac-address.mac "^FS" SKIP.
              PUT UNFORMATTED "^FO220,195^A0N,24,16^FDSENHA MASTER: " c-master "^FS" SKIP.
              PUT UNFORMATTED "^FO148,260^A0N,24,16^FDSENHA ACESSO REMOTO: " c-acesso "^FS" SKIP.
              ASSIGN iColuna = 2.
          END.
          WHEN 2 THEN DO:
              PUT UNFORMATTED "^FO470,55^A0N,26,19^FDINTELBRAS CLOUD^FS" SKIP. 
              PUT UNFORMATTED "^FO470,70^BQN,2,6^FDQA," tt-mac-address.mac "#" c-master "#" c-acesso "^FS" SKIP. 
              PUT UNFORMATTED "^FO644,125^A0N,24,16^FDMAC: " tt-mac-address.mac "^FS" SKIP.
              PUT UNFORMATTED "^FO644,195^A0N,24,16^FDSENHA MASTER: " c-master "^FS" SKIP.
              PUT UNFORMATTED "^FO570,260^A0N,24,16^FDSENHA ACESSO REMOTO: " c-acesso "^FS" SKIP.
              ASSIGN iColuna = 1.
          END.     
       END CASE.
       ****************************************************************************************************/
       
        IF  pTpImpressao = "2" THEN do: /* Reinpress’o */
            /*
            FIND FIRST mac-address
                WHERE ROWID(mac-address) = tt-mac-address.r-Rowid EXCLUSIVE-LOCK NO-ERROR.
              */
            IF AVAILABLE mac-address THEN
                ASSIGN mac-address.re-impr   = mac-address.re-impr + 1
                       mac-address.dt-ult-re = NOW
                       mac-address.us-ult-re = c-seg-usuario
                       mac-address.motiv-re  = pMotivo.
        END.

        IF iColuna = 1 THEN
        PUT "^XZ" SKIP.
    END.

    IF iColuna <> 1 THEN
        PUT "^XZ" SKIP.
END.

/************************* MAC + GPON Codigo de Barras *****************************/
IF item-ean.modelo-mac-address = 6 THEN DO:

    DEFINE VARIABLE c-nome-wifi AS CHAR     NO-UNDO.

    ASSIGN iColuna = 1
           c-mac   = "".
    
    FOR EACH tt-mac-address USE-INDEX ch-pri NO-LOCK
        WHERE tt-mac-address.impresso = YES:

        ASSIGN i-conta = i-conta + 1.

        IF VALID-HANDLE(h-acomp) THEN
            RUN pi-acompanhar IN h-acomp (INPUT "MAC: ":U + tt-mac-address.mac).

        IF  pTpImpressao = "2" THEN do: /* Reinpress’o */
            FIND FIRST mac-address
                WHERE mac-address.mac = tt-mac-address.mac EXCLUSIVE-LOCK NO-ERROR.

            IF AVAILABLE mac-address THEN
                ASSIGN mac-address.re-impr   = mac-address.re-impr + 1
                       mac-address.dt-ult-re = NOW
                       mac-address.us-ult-re = c-seg-usuario
                       mac-address.motiv-re  = pMotivo.
        END.

        FIND FIRST mac-address
                WHERE mac-address.mac = tt-mac-address.mac NO-LOCK NO-ERROR.


        IF item-ean.operadora = 1 THEN /* CLARO */
           ASSIGN c-nome-wifi = CAPS(TRIM(item-ean.texto[5])) + '_' + UPPER(SUBSTRING(mac-address.mac,7,6)).
        ELSE
           ASSIGN c-nome-wifi = CAPS(TRIM(item-ean.texto[5])) + '_' + LOWER(SUBSTRING(mac-address.mac,9,4)).
        

        CASE iColuna:
            WHEN 1 THEN DO:

                PUT "^XA" SKIP.
                
                PUT UNFORMATTED "^FT240,135^A0B,17,16^FDUsuario: Admin^FS" SKIP.
                PUT UNFORMATTED "^FT259,135^A0B,17,16^FDSenha:" mac-address.char-2 "^FS" SKIP.
                PUT UNFORMATTED "^FT85,154^A0N,17,16^FD" c-nome-wifi  "^FS" SKIP.
                PUT UNFORMATTED "^FT43,154^A0N,17,16^FDWIFI:^FS" SKIP.
                PUT UNFORMATTED "^FT90,137^A0N,17,16^FD" mac-address.char-1 "^FS" SKIP.
                PUT UNFORMATTED "^FT42,137^A0N,17,16^FDSenha:^FS" SKIP.
                PUT UNFORMATTED "^BY1,3,34^FT47,49^BCN,,Y,N" SKIP.
                PUT UNFORMATTED "^FD>:ITBS" SUBSTRING (tt-mac-address.mac,5,2) +
                                            SUBSTRING (tt-mac-address.mac,7,2) +
                                            SUBSTRING (tt-mac-address.mac,9,2) +
                                            SUBSTRING (tt-mac-address.mac,11,2) "^FS" SKIP. 
        
                PUT UNFORMATTED "^BY1,3,34^FT47,103^BCN,,Y,N" SKIP.
                PUT UNFORMATTED "^FD>:" tt-mac-address.mac "^FS" SKIP.
                PUT UNFORMATTED "^FT65,117^A0N,11,12^FDMAC:^FS"   SKIP.
                PUT UNFORMATTED "^FT48,63^A0N,11,12^FDGPONSN:^FS" SKIP.

                ASSIGN iColuna = 2.
            END.
            WHEN 2 THEN DO:

            
                PUT UNFORMATTED "^FT525,135^A0B,17,16^FDUsuario: Admin^FS" SKIP.
                PUT UNFORMATTED "^FT544,135^A0B,17,16^FDSenha:" mac-address.char-2 "^FS" SKIP.
                PUT UNFORMATTED "^FT369,154^A0N,17,16^FD" c-nome-wifi  "^FS" SKIP.
                PUT UNFORMATTED "^FT327,154^A0N,17,16^FDWIFI:^FS" SKIP.
                PUT UNFORMATTED "^FT376,137^A0N,17,16^FD" mac-address.char-1 "^FS" SKIP.
                PUT UNFORMATTED "^FT327,137^A0N,17,16^FDSenha:^FS" SKIP.
                PUT UNFORMATTED "^BY1,3,34^FT333,49^BCN,,Y,N" SKIP.
                PUT UNFORMATTED "^FD>:ITBS" SUBSTRING (tt-mac-address.mac,5,2) +
                                            SUBSTRING (tt-mac-address.mac,7,2) +
                                            SUBSTRING (tt-mac-address.mac,9,2) +
                                            SUBSTRING (tt-mac-address.mac,11,2) "^FS" SKIP. 

                PUT UNFORMATTED "^BY1,3,34^FT333,103^BCN,,Y,N" SKIP.
                PUT UNFORMATTED "^FD>:" tt-mac-address.mac "^FS" SKIP.
                PUT UNFORMATTED "^FT350,117^A0N,11,12^FDMAC:^FS"  SKIP.
                PUT UNFORMATTED "^FT333,63^A0N,11,12^FDGPONSN:^FS"  SKIP.

                ASSIGN iColuna = 3.
            END.
            WHEN 3 THEN DO:
            
                PUT UNFORMATTED "^FT810,135^A0B,17,16^FDUsuario: Admin^FS" SKIP.
                PUT UNFORMATTED "^FT829,135^A0B,17,16^FDSenha:" mac-address.char-2 "^FS" SKIP. 
                PUT UNFORMATTED "^FT653,154^A0N,17,16^FD" c-nome-wifi  "^FS" SKIP. 
                PUT UNFORMATTED "^FT612,154^A0N,17,16^FDWIFI:^FS" SKIP.
                PUT UNFORMATTED "^FT660,137^A0N,17,16^FD" mac-address.char-1 "^FS" SKIP. 
                PUT UNFORMATTED "^FT612,137^A0N,17,16^FDSenha:^FS"   SKIP.
                PUT UNFORMATTED "^BY1,3,34^FT617,49^BCN,,Y,N"   SKIP.
                PUT UNFORMATTED "^FD>:ITBS" SUBSTRING (tt-mac-address.mac,5,2) +
                                            SUBSTRING (tt-mac-address.mac,7,2) +
                                            SUBSTRING (tt-mac-address.mac,9,2) +
                                            SUBSTRING (tt-mac-address.mac,11,2) "^FS" SKIP. 

                PUT UNFORMATTED "^BY1,3,34^FT617,103^BCN,,Y,N"   SKIP.
                PUT UNFORMATTED "^FD>:" tt-mac-address.mac "^FS" SKIP.
                PUT UNFORMATTED "^FT635,117^A0N,11,12^FDMAC:^FS"   SKIP.
                PUT UNFORMATTED "^FT617,63^A0N,11,12^FDGPONSN:^FS"   SKIP.
           
                PUT UNFORMATTED "^XZ" SKIP.

                ASSIGN iColuna = 1.

            END.

        END CASE.

       


        /*
        PUT UNFORMATTED "^FO483,25^BY1,2.0,10 ^BCN,35,N,N,N,N^FDITBS" SUBSTRING (tt-mac-address.mac,5,2) +
                                                                      SUBSTRING (tt-mac-address.mac,7,2) +
                                                                      SUBSTRING (tt-mac-address.mac,9,2) +
                                                                      SUBSTRING (tt-mac-address.mac,11,2) "^FS" SKIP.
        //PUT UNFORMATTED "^FO331,58^A0N,15,15^FDMAC:" tt-mac-address.mac "^FS" SKIP.
        PUT UNFORMATTED "^FO482,65^A0N,16,17^FDGPONSN:ITBS" SUBSTRING (tt-mac-address.mac,5,2) +
                                                            SUBSTRING (tt-mac-address.mac,7,2) +
                                                            SUBSTRING (tt-mac-address.mac,9,2) +
                                                            SUBSTRING (tt-mac-address.mac,11,2) "^FS" SKIP. 

        PUT UNFORMATTED "^FO483,90^BY1,2.0,10 ^BCN,50,N,N,N,N^FD"  tt-mac-address.mac  "^FS" SKIP.
        PUT UNFORMATTED "^FO482,145^A0N,17,20^FDMAC:" tt-mac-address.mac "^FS" SKIP.

        PUT UNFORMATTED "^FO660,48^A0B,15,15^FD" "Usuario: admin" "^FS" SKIP. /* Imprime Data Vertical */
        PUT UNFORMATTED "^FO680,40^A0B,15,15^FD" "Senha: intelbras" "^FS" SKIP. /* Imprime Data Vertical */
        
        PUT "^XZ" SKIP.
        */    

    END.

    IF iColuna <> 1 THEN
       PUT UNFORMATTED "^XZ" SKIP.
END.

/************************* QR-CODE COM SENHA MASTER E ACESSO REMOTO POSITRON *****************************/
IF item-ean.modelo-mac-address = 7 THEN DO:

    ASSIGN iColuna = 1
           c-mac = "".
    
    FOR EACH tt-mac-address USE-INDEX ch-pri NO-LOCK
        WHERE tt-mac-address.impresso = YES:
        IF VALID-HANDLE(h-acomp) THEN
            RUN pi-acompanhar IN h-acomp (INPUT "MAC: ":U + tt-mac-address.mac).
        

       IF pTpImpressao = "1" /* Impressao */ THEN DO:
           FIND CURRENT tt-mac-address EXCLUSIVE-LOCK NO-ERROR.
           IF AVAIL tt-mac-address THEN 
               ASSIGN tt-mac-address.senha-master = INT(fnGeraSenha("master", ""))
                      tt-mac-address.senha-acesso = INT(fnGeraSenha("remoto", STRING(tt-mac-address.senha-master,"9999"))).

           FIND FIRST mac-address
                WHERE mac-address.mac = tt-mac-address.mac EXCLUSIVE-LOCK NO-ERROR.

            IF AVAIL mac-address THEN
                ASSIGN mac-address.senha-master = tt-mac-address.senha-master
                       mac-address.senha-acesso = tt-mac-address.senha-acesso.
       END.

       ASSIGN c-master = string(tt-mac-address.senha-master,"9999")
              c-acesso = string(tt-mac-address.senha-acesso,"999999").

       /* SEM FORMATA°€O */

       /* ETIQUETA DUN 14 SIMPLES */
       PUT "^XA" SKIP.
       PUT UNFORMATTED "^FO80,75^A0N,26,19^FDPàSITRON CLOUD^FS" SKIP. 
       PUT UNFORMATTED "^FO80,90^BQN,2,6^FDQA," tt-mac-address.mac "#" c-master "#" c-acesso "^FS" SKIP.  /* QR Code */
       PUT UNFORMATTED "^FO270,90^A0N,24,16^FDMAC: " tt-mac-address.mac "^FS" SKIP.
       PUT UNFORMATTED "^FO270,160^A0N,24,16^FDCONTRASE¥A MASTER: " c-master "^FS" SKIP.
       PUT UNFORMATTED "^FO270,230^A0N,24,16^FDCONTRASE¥A ACCESO REMOTO: " c-acesso "^FS" SKIP.

       /*********** NAO APAGAR - IMPRESSAO PARA ETIQUETA DUN 14 DUPLA - SERAH UTILIZADA FUTURAMENTE *********
       CASE iColuna:
          WHEN 1 THEN DO:
              PUT "^XA" SKIP.
              PUT UNFORMATTED "^FO46,55^A0N,26,19^FDINTELBRAS CLOUD^FS" SKIP. 
              PUT UNFORMATTED "^FO46,70^BQN,2,6^FDQA," tt-mac-address.mac "#" c-master "#" c-acesso "^FS" SKIP.  /* QR Code */
              PUT UNFORMATTED "^FO220,125^A0N,24,16^FDMAC: " tt-mac-address.mac "^FS" SKIP.
              PUT UNFORMATTED "^FO220,195^A0N,24,16^FDSENHA MASTER: " c-master "^FS" SKIP.
              PUT UNFORMATTED "^FO148,260^A0N,24,16^FDSENHA ACESSO REMOTO: " c-acesso "^FS" SKIP.
              ASSIGN iColuna = 2.
          END.
          WHEN 2 THEN DO:
              PUT UNFORMATTED "^FO470,55^A0N,26,19^FDINTELBRAS CLOUD^FS" SKIP. 
              PUT UNFORMATTED "^FO470,70^BQN,2,6^FDQA," tt-mac-address.mac "#" c-master "#" c-acesso "^FS" SKIP. 
              PUT UNFORMATTED "^FO644,125^A0N,24,16^FDMAC: " tt-mac-address.mac "^FS" SKIP.
              PUT UNFORMATTED "^FO644,195^A0N,24,16^FDSENHA MASTER: " c-master "^FS" SKIP.
              PUT UNFORMATTED "^FO570,260^A0N,24,16^FDSENHA ACESSO REMOTO: " c-acesso "^FS" SKIP.
              ASSIGN iColuna = 1.
          END.     
       END CASE.
       ****************************************************************************************************/
       
        IF  pTpImpressao = "2" THEN do: /* Reinpress’o */
            /*
            FIND FIRST mac-address
                WHERE ROWID(mac-address) = tt-mac-address.r-Rowid EXCLUSIVE-LOCK NO-ERROR.
              */
            IF AVAILABLE mac-address THEN
                ASSIGN mac-address.re-impr   = mac-address.re-impr + 1
                       mac-address.dt-ult-re = NOW
                       mac-address.us-ult-re = c-seg-usuario
                       mac-address.motiv-re  = pMotivo.
        END.

        IF iColuna = 1 THEN
        PUT "^XZ" SKIP.
    END.

    IF iColuna <> 1 THEN
        PUT "^XZ" SKIP.
END.

/************************* MAC + GPON Codigo de Barras Tripla *****************************/
IF item-ean.modelo-mac-address = 8 THEN DO:

    ASSIGN iColuna = 1
           c-mac   = ""
           i-conta = 0.
    
    //FOR EACH tt-mac-address USE-INDEX ch-pri NO-LOCK
    //    WHERE tt-mac-address.impresso = YES:
    FOR EACH tt-mac-address NO-LOCK
        WHERE tt-mac-address.impresso = YES
        BREAK BY tt-mac-address.mac:

        ASSIGN i-conta = i-conta + 1.

        IF VALID-HANDLE(h-acomp) THEN
            RUN pi-acompanhar IN h-acomp (INPUT "MAC: ":U + tt-mac-address.mac).

        IF  pTpImpressao = "2" THEN do: /* Reinpress’o */
            FIND FIRST mac-address
                WHERE mac-address.mac = tt-mac-address.mac EXCLUSIVE-LOCK NO-ERROR.

            IF AVAILABLE mac-address THEN
                ASSIGN mac-address.re-impr   = mac-address.re-impr + 1
                       mac-address.dt-ult-re = NOW
                       mac-address.us-ult-re = c-seg-usuario
                       mac-address.motiv-re  = pMotivo.
        END.

        ASSIGN c-mac-gpon[i-conta] = tt-mac-address.mac.

        //Come‡o de linha
        IF i-conta = 1 
        THEN DO:
            PUT "^XA" SKIP.
        END.

        //Final de linha
        IF i-conta = 3 
        THEN DO:
            //Etiqueta 1 na linha
            PUT UNFORMATTED "^FO35,25^BY1,2.0,10 ^BCN,35,N,N,N,N^FDITBS" SUBSTRING (c-mac-gpon[1],5,2) +
                                                                          SUBSTRING (c-mac-gpon[1],7,2) +
                                                                          SUBSTRING (c-mac-gpon[1],9,2) +
                                                                          SUBSTRING (c-mac-gpon[1],11,2) "^FS" SKIP.
            
            PUT UNFORMATTED "^FO35,65^A0N,16,17^FDGPONSN:ITBS" SUBSTRING (c-mac-gpon[1],5,2) +
                                                                SUBSTRING (c-mac-gpon[1],7,2) +
                                                                SUBSTRING (c-mac-gpon[1],9,2) +
                                                                SUBSTRING (c-mac-gpon[1],11,2) "^FS" SKIP. 
            
            PUT UNFORMATTED "^FO35,90^BY1,2.0,10 ^BCN,50,N,N,N,N^FD"  c-mac-gpon[1]  "^FS" SKIP.
            PUT UNFORMATTED "^FO35,145^A0N,17,20^FDMAC:" c-mac-gpon[1] "^FS" SKIP.
            
            PUT UNFORMATTED "^FO210,48^A0B,15,15^FD" "Usuario: admin" "^FS" SKIP. /* Imprime Data Vertical */
            PUT UNFORMATTED "^FO225,40^A0B,15,15^FD" "Senha: intelbras" "^FS" SKIP. /* Imprime Data Vertical */
            //Fim Etiqueta 1
            
            //Etiqueta 2 na linha
            PUT UNFORMATTED "^FO320,25^BY1,2.0,10 ^BCN,35,N,N,N,N^FDITBS" SUBSTRING (c-mac-gpon[2],5,2) +
                                                                          SUBSTRING (c-mac-gpon[2],7,2) +
                                                                          SUBSTRING (c-mac-gpon[2],9,2) +
                                                                          SUBSTRING (c-mac-gpon[2],11,2) "^FS" SKIP.
            
            PUT UNFORMATTED "^FO320,65^A0N,16,17^FDGPONSN:ITBS" SUBSTRING (c-mac-gpon[2],5,2) +
                                                                SUBSTRING (c-mac-gpon[2],7,2) +
                                                                SUBSTRING (c-mac-gpon[2],9,2) +
                                                                SUBSTRING (c-mac-gpon[2],11,2) "^FS" SKIP. 
            
            PUT UNFORMATTED "^FO320,90^BY1,2.0,10 ^BCN,50,N,N,N,N^FD"  c-mac-gpon[2] "^FS" SKIP.
            PUT UNFORMATTED "^FO320,145^A0N,17,20^FDMAC:" c-mac-gpon[2] "^FS" SKIP.
            
            PUT UNFORMATTED "^FO495,48^A0B,15,15^FD" "Usuario: admin" "^FS" SKIP. /* Imprime Data Vertical */
            PUT UNFORMATTED "^FO510,40^A0B,15,15^FD" "Senha: intelbras" "^FS" SKIP. /* Imprime Data Vertical */
            //Fim Etiqueta 2
            
            //Etiqueta 3 na linha
            PUT UNFORMATTED "^FO600,25^BY1,2.0,10 ^BCN,35,N,N,N,N^FDITBS" SUBSTRING (c-mac-gpon[3],5,2) +
                                                                          SUBSTRING (c-mac-gpon[3],7,2) +
                                                                          SUBSTRING (c-mac-gpon[3],9,2) +
                                                                          SUBSTRING (c-mac-gpon[3],11,2) "^FS" SKIP.
            
            PUT UNFORMATTED "^FO600,65^A0N,16,17^FDGPONSN:ITBS" SUBSTRING (c-mac-gpon[3],5,2) +
                                                                SUBSTRING (c-mac-gpon[3],7,2) +
                                                                SUBSTRING (c-mac-gpon[3],9,2) +
                                                                SUBSTRING (c-mac-gpon[3],11,2) "^FS" SKIP. 
            
            PUT UNFORMATTED "^FO600,90^BY1,2.0,10 ^BCN,50,N,N,N,N^FD"  c-mac-gpon[3]  "^FS" SKIP.
            PUT UNFORMATTED "^FO600,145^A0N,17,20^FDMAC:" c-mac-gpon[3] "^FS" SKIP.
            
            PUT UNFORMATTED "^FO775,48^A0B,15,15^FD" "Usuario: admin" "^FS" SKIP. /* Imprime Data Vertical */
            PUT UNFORMATTED "^FO790,40^A0B,15,15^FD" "Senha: intelbras" "^FS" SKIP. /* Imprime Data Vertical */
            //Fim Etiqueta 3
            PUT "^XZ" SKIP. 
            ASSIGN i-conta = 0
                   c-mac-gpon[1] = ""
                   c-mac-gpon[2] = ""
                   c-mac-gpon[3] = "".
        END.

        IF LAST(tt-mac-address.mac) AND 
           i-conta <> 3
        THEN DO:
            //Etiqueta 1 na linha
            PUT UNFORMATTED "^FO35,25^BY1,2.0,10 ^BCN,35,N,N,N,N^FDITBS" SUBSTRING (c-mac-gpon[1],5,2) +
                                                                          SUBSTRING (c-mac-gpon[1],7,2) +
                                                                          SUBSTRING (c-mac-gpon[1],9,2) +
                                                                          SUBSTRING (c-mac-gpon[1],11,2) "^FS" SKIP.
            
            PUT UNFORMATTED "^FO35,65^A0N,16,17^FDGPONSN:ITBS" SUBSTRING (c-mac-gpon[1],5,2) +
                                                                SUBSTRING (c-mac-gpon[1],7,2) +
                                                                SUBSTRING (c-mac-gpon[1],9,2) +
                                                                SUBSTRING (c-mac-gpon[1],11,2) "^FS" SKIP. 
            
            PUT UNFORMATTED "^FO35,90^BY1,2.0,10 ^BCN,50,N,N,N,N^FD"  c-mac-gpon[1]  "^FS" SKIP.
            PUT UNFORMATTED "^FO35,145^A0N,17,20^FDMAC:" c-mac-gpon[1] "^FS" SKIP.
            
            PUT UNFORMATTED "^FO210,48^A0B,15,15^FD" "Usuario: admin" "^FS" SKIP. /* Imprime Data Vertical */
            PUT UNFORMATTED "^FO225,40^A0B,15,15^FD" "Senha: intelbras" "^FS" SKIP. /* Imprime Data Vertical */
            //Fim Etiqueta 1
            
            IF c-mac-gpon[2] <> "" 
            THEN DO:
                //Etiqueta 2 na linha
                PUT UNFORMATTED "^FO320,25^BY1,2.0,10 ^BCN,35,N,N,N,N^FDITBS" SUBSTRING (c-mac-gpon[2],5,2) +
                                                                              SUBSTRING (c-mac-gpon[2],7,2) +
                                                                              SUBSTRING (c-mac-gpon[2],9,2) +
                                                                              SUBSTRING (c-mac-gpon[2],11,2) "^FS" SKIP.
                
                PUT UNFORMATTED "^FO320,65^A0N,16,17^FDGPONSN:ITBS" SUBSTRING (c-mac-gpon[2],5,2) +
                                                                    SUBSTRING (c-mac-gpon[2],7,2) +
                                                                    SUBSTRING (c-mac-gpon[2],9,2) +
                                                                    SUBSTRING (c-mac-gpon[2],11,2) "^FS" SKIP. 
                
                PUT UNFORMATTED "^FO320,90^BY1,2.0,10 ^BCN,50,N,N,N,N^FD"  c-mac-gpon[2] "^FS" SKIP.
                PUT UNFORMATTED "^FO320,145^A0N,17,20^FDMAC:" c-mac-gpon[2] "^FS" SKIP.
                
                PUT UNFORMATTED "^FO495,48^A0B,15,15^FD" "Usuario: admin" "^FS" SKIP. /* Imprime Data Vertical */
                PUT UNFORMATTED "^FO510,40^A0B,15,15^FD" "Senha: intelbras" "^FS" SKIP. /* Imprime Data Vertical */
                //Fim Etiqueta 2
            END.

            IF c-mac-gpon[3] <> "" 
            THEN DO:
                //Etiqueta 3 na linha
                PUT UNFORMATTED "^FO600,25^BY1,2.0,10 ^BCN,35,N,N,N,N^FDITBS" SUBSTRING (c-mac-gpon[3],5,2) +
                                                                              SUBSTRING (c-mac-gpon[3],7,2) +
                                                                              SUBSTRING (c-mac-gpon[3],9,2) +
                                                                              SUBSTRING (c-mac-gpon[3],11,2) "^FS" SKIP.
                
                PUT UNFORMATTED "^FO600,65^A0N,16,17^FDGPONSN:ITBS" SUBSTRING (c-mac-gpon[3],5,2) +
                                                                    SUBSTRING (c-mac-gpon[3],7,2) +
                                                                    SUBSTRING (c-mac-gpon[3],9,2) +
                                                                    SUBSTRING (c-mac-gpon[3],11,2) "^FS" SKIP. 
                
                PUT UNFORMATTED "^FO600,90^BY1,2.0,10 ^BCN,50,N,N,N,N^FD"  c-mac-gpon[3]  "^FS" SKIP.
                PUT UNFORMATTED "^FO600,145^A0N,17,20^FDMAC:" c-mac-gpon[3] "^FS" SKIP.
                
                PUT UNFORMATTED "^FO775,48^A0B,15,15^FD" "Usuario: admin" "^FS" SKIP. /* Imprime Data Vertical */
                PUT UNFORMATTED "^FO790,40^A0B,15,15^FD" "Senha: intelbras" "^FS" SKIP. /* Imprime Data Vertical */
                //Fim Etiqueta 3
            END.
            PUT "^XZ" SKIP. 
            ASSIGN i-conta = 0
                   c-mac-gpon[1] = ""
                   c-mac-gpon[2] = ""
                   c-mac-gpon[3] = "".
        END.

    END.
END.

OUTPUT CLOSE.
