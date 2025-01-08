&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*------------------------------------------------------------------------
    File        : Reestruturaá∆o ESAPI016
    Purpose     :

    Syntax      :

    Description : 

    Author(s)   : Carlos Daniel
    Created     : 01/10/2015
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

{cdp/cd0666.i}
{esapi/esapi016.i}
{esapi/esapi023.i}
{upc/btb910za-upc.i}
{esp/es0018.i}

DEFINE BUFFER b-tt-erro  FOR tt-erro.
DEFINE BUFFER b-ns       FOR num-serie.
DEFINE BUFFER b-item-ean FOR item-ean.
DEFINE BUFFER b-item-mat FOR item-mat.

DEFINE NEW GLOBAL SHARED VARIABLE c-seg-usuario     AS CHARACTER NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE v_nom_disposit_so AS CHARACTER NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE i-nr-ord-prod-escpp166 LIKE ord-prod.nr-ord-produ NO-UNDO.

DEFINE VARIABLE c-linha-desc1 AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-linha-desc2 AS CHARACTER NO-UNDO.
DEFINE VARIABLE i-cont        AS INTEGER   NO-UNDO.
DEFINE VARIABLE i-soma        AS INTEGER   NO-UNDO.
DEFINE VARIABLE kit-cont      AS INTEGER   NO-UNDO.
DEFINE VARIABLE iColuna       AS INTEGER   NO-UNDO.
DEFINE VARIABLE c-qr-code     AS CHARACTER NO-UNDO.
DEFINE VARIABLE i-mac-cont    AS INTEGER   NO-UNDO.
DEFINE VARIABLE c-macs        AS CHARACTER NO-UNDO.
DEFINE VARIABLE i-qt-imprimir AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-qtd-vol     AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-cont-2      AS INTEGER     NO-UNDO.

DEFINE VARIABLE c-num-ns         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-monta-qr-code  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-nome-wifi      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-formata-senha  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-senha-wifi     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-senha-adm      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-imei           AS CHARACTER  NO-UNDO.

DEF NEW GLOBAL SHARED VAR c-qr-code-escpp120 AS CHAR NO-UNDO.

DEFINE BUFFER btt-lista-ns FOR tt-lista-ns.
DEFINE VARIABLE l-registra-dup AS LOG NO-UNDO.

DEFINE TEMP-TABLE tt-ns-dup NO-UNDO 
       FIELD n-serie-tmp    AS CHAR FORMAT "X(13)"
       FIELD n-serie-bd     AS CHAR FORMAT "X(13)"
       FIELD modelo         AS INTE
       FIELD it-codigo      AS CHAR
       FIELD duplicado      AS LOG.

DEFINE VARIABLE l-escpp105-imp-data AS LOGICAL INITIAL NO NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
    RETURN "NOK":U.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-piAnoChar) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piAnoChar Procedure 
PROCEDURE piAnoChar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE OUTPUT PARAMETER p-ano AS CHAR NO-UNDO.

DEFINE VARIABLE c-array-char AS CHAR NO-UNDO.
DEFINE VARIABLE i-char AS INTEGER     NO-UNDO.

/*
A - 2012
B - 2013
C - 2014
...
*/

ASSIGN c-array-char = "A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,0,1,2,3,4,5,6,7,8,9".

ASSIGN p-ano = ENTRY(YEAR(TODAY) - 2011,c-array-char).

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piAtualizaNumSerie) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piAtualizaNumSerie Procedure 
PROCEDURE piAtualizaNumSerie :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER p-motivo AS INT     NO-UNDO.
    
FIND CURRENT num-serie EXCLUSIVE-LOCK.

ASSIGN num-serie.re-impr = num-serie.re-impr + 1
       num-serie.dt-ult-re = NOW
       num-serie.us-ult-re = c-seg-usuario
       /*num-serie.motiv-re = p-motivo.*/
       num-serie.tipo-re = p-motivo.

RELEASE num-serie.

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piBuscaEtiq) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piBuscaEtiq Procedure 
PROCEDURE piBuscaEtiq :
/*------------------------------------------------------------------------------
  Purpose: Busca etiqueta atravÇs do filtro informado para re-impress∆o
  Notes:   Carlos Daniel - 29/01/2016
------------------------------------------------------------------------------*/
DEFINE OUTPUT PARAMETER p-qtd-embal AS INTEGER NO-UNDO.

FOR EACH tt-lista-ns:
    FOR FIRST etiq-coletiva
        WHERE etiq-coletiva.cod-etiqueta = tt-lista-ns.num-serie EXCLUSIVE-LOCK:

        CREATE tt-etiq-coletiva.
        BUFFER-COPY etiq-coletiva TO tt-etiq-coletiva.

        ASSIGN p-qtd-embal                = etiq-coletiva.quantidade
               etiq-coletiva.re-impr      = etiq-coletiva.re-impr + 1
               etiq-coletiva.dt-ult-re    = NOW
               etiq-coletiva.usuar-ult-re = c-seg-usuario.
    END.
END.

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piCargaImagem) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piCargaImagem Procedure 
PROCEDURE piCargaImagem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER p-nome   AS CHAR NO-UNDO.

{esapi/esapi016imag.i}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piCopiaImei) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piCopiaImei Procedure 
PROCEDURE piCopiaImei :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER p-qtd-etiquetas      AS INTEGER  NO-UNDO.
DEFINE INPUT PARAMETER p-impressora         AS CHAR     NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR tt-lista-ns.    

DEFINE VARIABLE i-quebras AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-aux AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-cont AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-lin AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-col AS INTEGER     NO-UNDO.
DEFINE VARIABLE cPrinter AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cLayout AS CHARACTER   NO-UNDO.

EMPTY TEMP-TABLE tt-erro.

IF NUM-ENTRIES(p-impressora, ":":U) = 2 THEN DO:

    ASSIGN cPrinter = SUBSTRING(p-impressora, 1, INDEX(p-impressora, ":":U) - 1)
           cLayout  = SUBSTRING(p-impressora, INDEX(p-impressora, ":":U) + 1, LENGTH(p-impressora) - INDEX(p-impressora, ":":U)).

    FIND FIRST imprsor_usuar USE-INDEX imprsrsr_id
        WHERE imprsor_usuar.nom_impressora = cPrinter
          AND imprsor_usuar.cod_usuario    = c-seg-usuario NO-LOCK NO-ERROR.

    IF NOT AVAILABLE imprsor_usuar THEN DO:
        RUN piGeraErro (INPUT 4306,
                        INPUT c-seg-usuario).
    END.

    FIND FIRST layout_impres
        WHERE layout_impres.nom_impressora    = cPrinter
          AND layout_impres.cod_layout_impres = cLayout NO-LOCK NO-ERROR.

    IF NOT AVAILABLE layout_impres THEN DO:
        RUN piGeraErro (INPUT 4306,
                        INPUT c-seg-usuario).
    END.
END.
ELSE DO:
    IF NUM-ENTRIES(p-impressora, ":":U) < 2 THEN DO:
        RUN piGeraErro (INPUT 4306,
                        INPUT c-seg-usuario).
    END.

    ASSIGN cPrinter = ENTRY(1, p-impressora, ":":U)
           cLayout  = ENTRY(2, p-impressora, ":":U).

    FIND FIRST imprsor_usuar USE-INDEX imprsrsr_id
        WHERE imprsor_usuar.nom_impressora = cPrinter
          AND imprsor_usuar.cod_usuario    = c-seg-usuario NO-LOCK NO-ERROR.

    IF NOT AVAILABLE imprsor_usuar THEN DO:
        RUN piGeraErro (INPUT 4306,
                        INPUT c-seg-usuario).
    END.

    FIND FIRST layout_impres
        WHERE layout_impres.nom_impressora = cPrinter
          AND layout_impres.cod_layout_impres = cLayout NO-LOCK NO-ERROR.

    IF NOT AVAILABLE layout_impres THEN DO:
        RUN piGeraErro (INPUT 4306,
                        INPUT c-seg-usuario).
    END.
END.

ASSIGN v_nom_disposit_so = "".

IF AVAIL imprsor_usuar THEN
    ASSIGN v_nom_disposit_so = imprsor_usuar.nom_disposit_so.

IF v_nom_disposit_so = "" THEN DO:
    RUN piGeraErro (INPUT 17006,
                    INPUT "Impressora inv†lida.").
END.

IF CAN-FIND(FIRST tt-erro) THEN
    RETURN "NOK":U.

OUTPUT TO VALUE(v_nom_disposit_so) /* PAGE-SIZE 0 CONVERT TARGET SESSION:CHARSET */.

PUT "^XA"    SKIP.   /* Inicio Label */
PUT "^PW832" SKIP.   /* Width 832 */
PUT "^MNY"   SKIP.   /* Papel de etiquetas n∆o continuo */
PUT "^MTT"   SKIP.   /* Papel Comum - usa ribon */
PUT "^BY2"   SKIP.   /* Magnitude EAN */
PUT "^PRA"   SKIP.   /* Velocidade 50mm/seg */
PUT "^JUS"   SKIP.   /* Grava Configuracao */
PUT "^XZ"    SKIP.

ASSIGN i-quebras = TRUNCATE(p-qtd-etiquetas / 2, 0).

IF (p-qtd-etiquetas / 2) <> TRUNCATE(p-qtd-etiquetas / 2, 0) THEN
    ASSIGN i-quebras = i-quebras + 1.

DO i-aux = 1 TO i-quebras:
    ASSIGN i-col = 40
           i-lin = 36
           i-cont = 0.
       
    PUT "^XA" SKIP.

    FOR EACH tt-lista-ns: 
        PUT UNFORMATTED
            /*"^FO" string(i-col) "," string(i-lin) "^BY1^BCN,40,N,N,N,N^FD" string(tt-lista-ns.num-serie) "^FS" SKIP  /* Codigo de Barras EAN 128 */*/
            /*"^FO" string(i-col) "," string(i-lin) "^BY1^BPN,N,40,Y,N^FD" string(tt-lista-ns.num-serie) "^FS" SKIP  /* Codigo de Barras EAN 128 */*/
            /*"^FO" string(i-col) "," string(i-lin) "^BY1^BMN,A,40,Y,N,N^FD" string(tt-lista-ns.num-serie) "^FS" SKIP  /* Codigo de Barras EAN 128 */*/
            /*"^FO" string(i-col) "," string(i-lin) "^BY1^BLN,40,N^FD" string(tt-lista-ns.num-serie) "^FS" SKIP  /* Codigo de Barras EAN 128 */*/
            /*"^FO" string(i-col) "," string(i-lin) "^BY1^BJN,40,Y,N^FD" string(tt-lista-ns.num-serie) "^FS" SKIP  /* Codigo de Barras EAN 128 */*/
            /*"^FO" string(i-col) "," string(i-lin) "^BY1^BIN,40,Y,N^FD" string(tt-lista-ns.num-serie) "^FS" SKIP  /* Codigo de Barras EAN 128 */*/
            /*"^FO" string(i-col) "," string(i-lin) "^BY2^BAN,40,N,N,N^FD" string(tt-lista-ns.num-serie) "^FS" SKIP  /* Codigo de Barras EAN 128 */*/
            /*"^FO" string(i-col) "," string(i-lin) "^BY2^B9N,40,N,N,N^FD" string(tt-lista-ns.num-serie) "^FS" SKIP  /* Codigo de Barras EAN 128 */*/
            /*"^FO" string(i-col) "," string(i-lin) "^BY1^B3N,N,40,N,N^FD" string(tt-lista-ns.num-serie) "^FS" SKIP  /* Codigo de Barras EAN 128 */*/
            /*"^FO" string(i-col) "," string(i-lin) "^BY2^B2N,40,N,N,N^FD" string(tt-lista-ns.num-serie) "^FS" SKIP  /* Codigo de Barras EAN 128 */*/
            "^FO" string(i-col) "," string(i-lin) "^BY2^B1N,Y,40,N,N^FD" string(tt-lista-ns.num-serie) "^FS" SKIP  /* Codigo de Barras EAN 128 */
            "^FO" string(i-col) "," STRING(i-lin + 50) "^A0N,20,20^FD" "IMEI: " string(tt-lista-ns.num-serie)  "^FS" SKIP.  /* Numero de s?rie - Etiqueta Secundòria*/
            .

        IF i-aux = i-quebras AND
            (p-qtd-etiquetas / 2) <> TRUNCATE(p-qtd-etiquetas / 2, 0)  THEN DO:
            ASSIGN i-lin = i-lin + 90.
            NEXT.
        END.

        PUT UNFORMATTED
            "^FO" string(i-col + 430) "," string(i-lin) "^BY2^B1N,Y,40,N,N^FD" string(tt-lista-ns.num-serie) "^FS" SKIP  /* Codigo de Barras EAN 128 */
            "^FO" string(i-col + 430) "," STRING(i-lin + 50) "^A0N,20,20^FD" "IMEI: " string(tt-lista-ns.num-serie)  "^FS" SKIP.  /* Numero de s?rie - Etiqueta Secundòria*/
            .

        ASSIGN i-lin = i-lin + 90.
    END.

    PUT "^PQ" STRING(1, "99999") SKIP.  /* Quantidade de etiquetas a imprimir */
    PUT "^XZ" SKIP.
END.

OUTPUT CLOSE.

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piGeraErro) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piGeraErro Procedure 
PROCEDURE piGeraErro :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER p-num        AS INTEGER      NO-UNDO.
DEFINE INPUT PARAMETER p-desc       AS CHAR         NO-UNDO.

DEFINE VARIABLE c-msg AS CHARACTER   NO-UNDO.

FOR LAST b-tt-erro
    BY tt-erro.i-sequen:
END.

RUN utp/ut-msgs.p (INPUT "msg",
                   INPUT p-num,
                   INPUT p-desc).

ASSIGN c-msg = RETURN-VALUE.
    
CREATE tt-erro.
ASSIGN tt-erro.i-sequen = IF AVAIL b-tt-erro THEN b-tt-erro.i-sequen + 1 ELSE 1
       tt-erro.cd-erro  = p-num
       tt-erro.mensagem = c-msg.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piGeraEtiq) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piGeraEtiq Procedure 
PROCEDURE piGeraEtiq :
/*------------------------------------------------------------------------------
  Purpose:     
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER p-qtd-etiquetas AS INTEGER NO-UNDO.
DEFINE INPUT PARAMETER p-qtd-embal     AS INTEGER NO-UNDO.

DEFINE VARIABLE c-ns           AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-ano          AS CHARACTER NO-UNDO.
DEFINE VARIABLE i-semana       AS INTEGER   NO-UNDO.
DEFINE VARIABLE c-aux          AS CHARACTER NO-UNDO.
DEFINE VARIABLE i-seq          AS INTEGER   NO-UNDO.
DEFINE VARIABLE i-nr-etiquetas AS INTEGER   NO-UNDO.
DEFINE VARIABLE i-tipo         AS INTEGER   NO-UNDO.

EMPTY TEMP-TABLE tt-erro.
EMPTY TEMP-TABLE tt-etiq-coletiva.

ASSIGN i-semana = INTERVAL(TODAY, DATE(01, 01, YEAR(TODAY)), "weeks") + 1
       i-tipo   = IF modelo-etiq.tipo = 7 THEN 1 ELSE 2.

DO i-nr-etiquetas = 1 TO p-qtd-etiquetas:

    /* ID N£mero de SÇrie */
    IF item-ean.id-ns = "" OR item-ean.id-ns = ? THEN
        RUN piGeraIdNSEAN (INPUT item-ean.it-codigo).

    ASSIGN c-ns = (IF modelo-etiq.tipo = 7 THEN "CX" ELSE "PL") + item-ean.id-ns.
    /* Ano */
    RUN piAnoChar (OUTPUT c-ano).
    ASSIGN c-ns = c-ns + c-ano.

    /* Semana / Sequencia */
    REPEAT:
        FOR LAST etiq-coletiva NO-LOCK USE-INDEX cria
            WHERE etiq-coletiva.it-codigo = item-ean.it-codigo
            AND   etiq-coletiva.ano       = YEAR(TODAY)
            AND   etiq-coletiva.semana    = i-semana
            AND   etiq-coletiva.tipo      = i-tipo:
        END.

        IF NOT AVAIL etiq-coletiva THEN DO:
            ASSIGN i-seq = 1.
            LEAVE.
        END.
        ELSE DO:
            IF etiq-coletiva.sequencia = 99999 THEN DO:
                ASSIGN i-semana = i-semana + 1.
            END.
            ELSE DO:
                ASSIGN i-seq = etiq-coletiva.sequencia + 1.
                LEAVE.
            END.
        END.
    END.

    ASSIGN c-ns = c-ns + STRING(i-semana, "99").
    ASSIGN c-ns = c-ns + STRING(i-seq, "99999").

    /* Criaá∆o da Tabela */
    CREATE tt-etiq-coletiva.
    ASSIGN tt-etiq-coletiva.cod-etiq    = c-ns
           tt-etiq-coletiva.it-codigo   = item-ean.it-codigo
           tt-etiq-coletiva.tipo        = i-tipo
           tt-etiq-coletiva.quantidade  = p-qtd-embal
           tt-etiq-coletiva.ano         = YEAR(TODAY)
           tt-etiq-coletiva.semana      = i-semana
           tt-etiq-coletiva.sequencia   = i-seq
           tt-etiq-coletiva.cod-estabel = IF v_cod_estab_usuar <> "" AND v_cod_estab_usuar <> ? THEN v_cod_estab_usuar ELSE "101"
           tt-etiq-coletiva.data        = NOW
           tt-etiq-coletiva.usuario     = c-seg-usuario
           tt-etiq-coletiva.status-etiq = YES.
    
    CREATE etiq-coletiva.
    BUFFER-COPY tt-etiq-coletiva TO etiq-coletiva.

    RELEASE etiq-coletiva.
END.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piGeraIdNSEAN) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piGeraIdNSEAN Procedure 
PROCEDURE piGeraIdNSEAN :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER p-it-codigo AS CHAR  NO-UNDO.

DEFINE VARIABLE c-id-ns AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-aux AS CHARACTER   NO-UNDO.

REPEAT:
    RUN piRandomChar(OUTPUT c-aux).
    ASSIGN c-id-ns = c-aux.

    RUN piRandomChar(OUTPUT c-aux).
    ASSIGN c-id-ns = c-id-ns + c-aux.

    RUN piRandomChar(OUTPUT c-aux).
    ASSIGN c-id-ns = c-id-ns + c-aux.

    IF NOT CAN-FIND(FIRST item-ean
                    WHERE item-ean.id-ns = c-id-ns) THEN DO:

        FOR FIRST item-ean EXCLUSIVE-LOCK
            WHERE item-ean.it-codigo = p-it-codigo:

            ASSIGN item-ean.id-ns = c-id-ns.
        END.
        LEAVE.
    END.
END.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piGeraKitNS) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piGeraKitNS Procedure 
PROCEDURE piGeraKitNS :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER p-cod-modelo         AS INT      NO-UNDO.
DEFINE INPUT PARAMETER p-sigla              AS CHAR     NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR tt-kit-ns.

DEFINE VARIABLE i-cont-etiq  AS INTEGER     NO-UNDO.

FOR FIRST modelo-etiq NO-LOCK
    WHERE modelo-etiq.cod-modelo = p-cod-modelo:

    IF modelo-etiq.usa-kit THEN DO:
        FOR EACH tt-kit-ns:
            FOR FIRST num-serie NO-LOCK
                WHERE num-serie.n-serie = tt-kit-ns.num-serie:
                FOR EACH int-kit NO-LOCK
                    WHERE int-kit.it-codigo = num-serie.it-codigo:

                    DO i-cont-etiq = 1 TO int-kit.qtd-prod:
                    
                        EMPTY TEMP-TABLE tt-lista-ns.
    
                        RUN piGeraNs (INPUT int-kit.es-codigo,
                                      INPUT p-cod-modelo,
                                      INPUT p-sigla,
                                      INPUT 1,     /* Quantidade */
                                      INPUT 0,     /* Motivo Reimp */
                                      INPUT 0,     /* Pedido */
                                      INPUT "",    /* Impressora */
                                      INPUT 3,     /* Somente Geraá∆o */
                                      INPUT FALSE, /* Trata Astec */
                                      INPUT "",
                                      INPUT "",
                                      OUTPUT TABLE tt-lista-ns).
    
                        FOR EACH tt-lista-ns:
                            IF NOT can-find(FIRST num-serie-fornec
                                            WHERE num-serie-fornec.n-serie     = tt-kit-ns.num-serie
                                            AND   num-serie-fornec.n-serie-sec = tt-lista-ns.num-serie) THEN DO:
        
                                CREATE num-serie-fornec.
                                ASSIGN num-serie-fornec.n-serie     = tt-kit-ns.num-serie
                                       num-serie-fornec.n-serie-sec = tt-lista-ns.num-serie.
                            END.
                        END.
                    END.
                END.
            END.
        END.
    END.
END.


RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piGeraNS) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piGeraNS Procedure 
PROCEDURE piGeraNS :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER p-it-codigo          AS CHAR     NO-UNDO.
DEFINE INPUT PARAMETER p-cod-modelo         AS INT      NO-UNDO.
DEFINE INPUT PARAMETER p-sigla              AS CHAR     NO-UNDO.
DEFINE INPUT PARAMETER p-qtd-etiquetas      AS INTEGER  NO-UNDO.
DEFINE INPUT PARAMETER p-motivo-reimp       AS INTEGER  NO-UNDO.
DEFINE INPUT PARAMETER p-num-pedido         AS INTEGER  NO-UNDO.
DEFINE INPUT PARAMETER p-impressora         AS CHAR     NO-UNDO.
DEFINE INPUT PARAMETER p-tipo-processo      AS INTEGER  NO-UNDO.   /* 1 - Geraá∆o e Impress∆o,  2 - Somente Impress∆o,  3 - Somente Geraá∆o, 4 - N∆o valida (pois j† foi validado no Tipo 1) */
DEFINE INPUT PARAMETER p-trata-astec        AS LOGICAL  NO-UNDO.
DEFINE INPUT PARAMETER p-ID                 AS CHAR     NO-UNDO.
DEFINE INPUT PARAMETER p-Ch-Acesso          AS CHAR     NO-UNDO.
DEFINE OUTPUT PARAMETER TABLE FOR tt-lista-ns.

DEFINE VARIABLE c-ns AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-ano AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i-semana AS INTEGER   NO-UNDO.
DEFINE VARIABLE c-aux AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i-seq AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-nr-etiquetas  AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-nr-duplica    AS INTEGER     NO-UNDO.
DEFINE VARIABLE c-num-serie-pai AS CHARACTER   NO-UNDO.

EMPTY TEMP-TABLE tt-erro.

RUN piValidate (INPUT p-it-codigo,
                INPUT p-cod-modelo,
                INPUT p-sigla,
                INPUT p-qtd-etiquetas,
                INPUT p-motivo-reimp,
                INPUT p-num-pedido,
                INPUT p-impressora,
                INPUT p-tipo-processo).

IF CAN-FIND(FIRST tt-erro) THEN
    RETURN "NOK":U.

EMPTY TEMP-TABLE tt-lista-ns.

IF p-trata-astec THEN
    ASSIGN i-semana = 61.
ELSE
    ASSIGN i-semana = INTERVAL(TODAY, DATE(01, 01, YEAR(TODAY)), "weeks") + 1.

IF NOT AVAIL item-ean THEN DO:
    RUN piGeraErro (INPUT 17006,
                    INPUT "Item n∆o permite geraá∆o de n£mero de sÇrie~~Solicitar parametrizaá∆o Ö Engenharia Industrial.").
    RETURN "NOK".
END.

DO i-nr-etiquetas = 1 TO p-qtd-etiquetas:

    /* ID N£mero de SÇrie */
    IF item-ean.id-ns = "" OR item-ean.id-ns = ? THEN
        RUN piGeraIdNSEAN (INPUT p-it-codigo).

    ASSIGN c-ns = item-ean.id-ns.
    
    /* Ano */
    RUN piAnoChar (OUTPUT c-ano).
    ASSIGN c-ns = c-ns + c-ano.

    /* Semana / Sequencia */
    REPEAT:
        FOR LAST num-serie NO-LOCK USE-INDEX cria
            WHERE num-serie.it-codigo = p-it-codigo
            AND   num-serie.ano       = YEAR(TODAY)
            AND   num-serie.semana    = i-semana:
        END.
    
        IF NOT AVAIL num-serie THEN DO:
            ASSIGN i-seq = 1.
            LEAVE.
        END.
        ELSE DO:
            IF num-serie.sequencia = 99999 THEN DO:
                ASSIGN i-semana = i-semana + 1.
            END.
            ELSE DO:
                ASSIGN i-seq = num-serie.sequencia + 1.
                LEAVE.
            END.
        END.
    END.

    ASSIGN c-ns = c-ns + STRING(i-semana, "99").
    ASSIGN c-ns = c-ns + STRING(i-seq, "99999").

    /* Sufixo */
    RUN piRandomChar (OUTPUT c-aux).
    ASSIGN c-ns = c-ns + c-aux.

    RUN piRandomChar (OUTPUT c-aux).
    ASSIGN c-ns = c-ns + c-aux.

    CREATE tt-lista-ns.
    ASSIGN tt-lista-ns.num-serie = c-ns.
    
    /* Criaá∆o da Tabela */
    CREATE num-serie.
    ASSIGN num-serie.n-serie = c-ns                                    
           num-serie.it-codigo = p-it-codigo                           
           num-serie.ano = YEAR(TODAY)                                 
           num-serie.semana = i-semana                                 
           num-serie.sequencia = i-seq                                 
           num-serie.num-pedido = p-num-pedido
           num-serie.sigla = CAPS(p-sigla)
           num-serie.cod-estabel = IF v_cod_estab_usuar <> "" AND v_cod_estab_usuar <> ? THEN v_cod_estab_usuar ELSE "101"
           num-serie.data = NOW
           num-serie.usuario = c-seg-usuario                           
           num-serie.re-impr = 0
           num-serie.dt-ult-re = ?                                     
           num-serie.us-ult-re = ?                                     
           num-serie.motiv-re = ?                                      
           num-serie.ns-keycode = ""
           num-serie.ID = p-ID
           num-serie.ch-acesso = P-Ch-Acesso .

    RELEASE num-serie.

    IF item-ean.qtd-ns > 1 
    THEN DO:

        ASSIGN c-num-serie-pai = c-ns.

        DO i-nr-duplica = 2 TO item-ean.qtd-ns:
            /* ID N£mero de SÇrie */
            IF item-ean.id-ns = "" OR item-ean.id-ns = ? THEN
                RUN piGeraIdNSEAN (INPUT p-it-codigo).
            
            ASSIGN c-ns = item-ean.id-ns.
            
            /* Ano */
            RUN piAnoChar (OUTPUT c-ano).
            ASSIGN c-ns = c-ns + c-ano.
            
            /* Semana / Sequencia */
            REPEAT:
                FOR LAST num-serie NO-LOCK USE-INDEX cria
                    WHERE num-serie.it-codigo = p-it-codigo
                    AND   num-serie.ano       = YEAR(TODAY)
                    AND   num-serie.semana    = i-semana:
                END.
            
                IF NOT AVAIL num-serie THEN DO:
                    ASSIGN i-seq = 1.
                    LEAVE.
                END.
                ELSE DO:
                    IF num-serie.sequencia = 99999 THEN DO:
                        ASSIGN i-semana = i-semana + 1.
                    END.
                    ELSE DO:
                        ASSIGN i-seq = num-serie.sequencia + 1.
                        LEAVE.
                    END.
                END.
            END.
            
            ASSIGN c-ns = c-ns + STRING(i-semana, "99").
            ASSIGN c-ns = c-ns + STRING(i-seq, "99999").
            
            /* Sufixo */
            RUN piRandomChar (OUTPUT c-aux).
            ASSIGN c-ns = c-ns + c-aux.
            
            RUN piRandomChar (OUTPUT c-aux).
            ASSIGN c-ns = c-ns + c-aux.
            
            CREATE tt-lista-ns.
            ASSIGN tt-lista-ns.num-serie = c-ns.
            
            /* Criaá∆o da Tabela */
            CREATE num-serie.
            ASSIGN num-serie.n-serie = c-ns                                    
                   num-serie.it-codigo = p-it-codigo                           
                   num-serie.ano = YEAR(TODAY)                                 
                   num-serie.semana = i-semana                                 
                   num-serie.sequencia = i-seq                                 
                   num-serie.num-pedido = p-num-pedido
                   num-serie.sigla = CAPS(p-sigla)
                   num-serie.cod-estabel = IF v_cod_estab_usuar <> "" AND v_cod_estab_usuar <> ? THEN v_cod_estab_usuar ELSE "101"
                   num-serie.data = NOW
                   num-serie.usuario = c-seg-usuario                           
                   num-serie.re-impr = 0
                   num-serie.dt-ult-re = ?                                     
                   num-serie.us-ult-re = ?                                     
                   num-serie.motiv-re = ?                                      
                   num-serie.ns-keycode = ""
                   num-serie.ID = p-ID
                   num-serie.ch-acesso = P-Ch-Acesso .
            
            RELEASE num-serie.

            FIND FIRST num-serie-vinc WHERE
                       num-serie-vinc.n-serie      = c-num-serie-pai AND
                       num-serie-vinc.n-serie-vinc = c-ns
                       NO-ERROR.

            IF NOT AVAIL num-serie-vinc 
            THEN DO:
                CREATE num-serie-vinc.
                ASSIGN num-serie-vinc.n-serie      = c-num-serie-pai
                       num-serie-vinc.n-serie-vinc = c-ns.

                RELEASE num-serie-vinc.
            END.    
        END.
    END.
END.


RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piGeraNSeMAC) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piGeraNSeMAC Procedure 
PROCEDURE piGeraNSeMAC :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER p-it-codigo          AS CHAR     NO-UNDO.
DEFINE INPUT PARAMETER p-cod-modelo         AS INT      NO-UNDO.
DEFINE INPUT PARAMETER p-sigla              AS CHAR     NO-UNDO.
DEFINE INPUT PARAMETER p-qtd-etiquetas      AS INTEGER  NO-UNDO.
DEFINE INPUT PARAMETER p-motivo-reimp       AS INTEGER  NO-UNDO.
DEFINE INPUT PARAMETER p-num-pedido         AS INTEGER  NO-UNDO.
DEFINE INPUT PARAMETER p-impressora         AS CHAR     NO-UNDO.
DEFINE INPUT PARAMETER p-tipo-processo      AS INTEGER  NO-UNDO.   /* 1 - Geraá∆o e Impress∆o,  2 - Somente Impress∆o,  3 - Somente Geraá∆o, 4 - N∆o valida (pois j† foi validado no Tipo 1) */
DEFINE INPUT PARAMETER p-trata-astec        AS LOGICAL  NO-UNDO.
DEFINE INPUT PARAMETER p-ID                 AS CHAR     NO-UNDO.
DEFINE INPUT PARAMETER p-Ch-Acesso          AS CHAR     NO-UNDO.
DEFINE OUTPUT PARAMETER TABLE FOR tt-lista-ns.

DEFINE VARIABLE c-ns AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-ano AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i-semana AS INTEGER   NO-UNDO.
DEFINE VARIABLE c-aux AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i-seq AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-nr-etiquetas AS INTEGER     NO-UNDO.

EMPTY TEMP-TABLE tt-erro.

RUN piValidate (INPUT p-it-codigo,
                INPUT p-cod-modelo,
                INPUT p-sigla,
                INPUT p-qtd-etiquetas,
                INPUT p-motivo-reimp,
                INPUT p-num-pedido,
                INPUT p-impressora,
                INPUT p-tipo-processo).

IF CAN-FIND(FIRST tt-erro) THEN
    RETURN "NOK":U.

EMPTY TEMP-TABLE tt-lista-ns.

IF p-trata-astec THEN
    ASSIGN i-semana = 61.
ELSE
    ASSIGN i-semana = INTERVAL(TODAY, DATE(01, 01, YEAR(TODAY)), "weeks") + 1.

IF NOT AVAIL item-ean THEN DO:
    RUN piGeraErro (INPUT 17006,
                    INPUT "Item n∆o permite geraá∆o de n£mero de sÇrie~~Solicitar parametrizaá∆o Ö Engenharia Industrial.").
    RETURN "NOK".
END.

DO i-nr-etiquetas = 1 TO p-qtd-etiquetas:

    /* ID N£mero de SÇrie */
    IF item-ean.id-ns = "" OR item-ean.id-ns = ? THEN
        RUN piGeraIdNSEAN (INPUT p-it-codigo).

    ASSIGN c-ns = item-ean.id-ns.
    
    /* Ano */
    RUN piAnoChar (OUTPUT c-ano).
    ASSIGN c-ns = c-ns + c-ano.

    /* Semana / Sequencia */
    REPEAT:
        FOR LAST num-serie NO-LOCK USE-INDEX cria
            WHERE num-serie.it-codigo = p-it-codigo
            AND   num-serie.ano       = YEAR(TODAY)
            AND   num-serie.semana    = i-semana:
        END.
    
        IF NOT AVAIL num-serie THEN DO:
            ASSIGN i-seq = 1.
            LEAVE.
        END.
        ELSE DO:
            IF num-serie.sequencia = 99999 THEN DO:
                ASSIGN i-semana = i-semana + 1.
            END.
            ELSE DO:
                ASSIGN i-seq = num-serie.sequencia + 1.
                LEAVE.
            END.
        END.
    END.

    ASSIGN c-ns = c-ns + STRING(i-semana, "99").
    ASSIGN c-ns = c-ns + STRING(i-seq, "99999").

    /* Sufixo */
    RUN piRandomChar (OUTPUT c-aux).
    ASSIGN c-ns = c-ns + c-aux.

    RUN piRandomChar (OUTPUT c-aux).
    ASSIGN c-ns = c-ns + c-aux.

    CREATE tt-lista-ns.
    ASSIGN tt-lista-ns.num-serie = c-ns.
    
    /* Criaá∆o da Tabela */
    CREATE num-serie.
    ASSIGN num-serie.n-serie = c-ns                                    
           num-serie.it-codigo = p-it-codigo                           
           num-serie.ano = YEAR(TODAY)                                 
           num-serie.semana = i-semana                                 
           num-serie.sequencia = i-seq                                 
           num-serie.num-pedido = p-num-pedido
           num-serie.sigla = CAPS(p-sigla)
           num-serie.cod-estabel = IF v_cod_estab_usuar <> "" AND v_cod_estab_usuar <> ? THEN v_cod_estab_usuar ELSE "101"
           num-serie.data = NOW
           num-serie.usuario = c-seg-usuario                           
           num-serie.re-impr = 0
           num-serie.dt-ult-re = ?                                     
           num-serie.us-ult-re = ?                                     
           num-serie.motiv-re = ?                                      
           num-serie.ns-keycode = ""
           num-serie.ID = p-ID
           num-serie.ch-acesso = P-Ch-Acesso .

    //Se n∆o informado o numero de ID na chamada persistente ent∆o grava com o NS
    IF num-serie.ID = "" 
    THEN ASSIGN num-serie.ID = num-serie.n-serie.

    //Logica para criar Chave de Acesso
    IF num-serie.ch-acesso = "" 
    THEN DO:
        ASSIGN P-Ch-Acesso = "".

        RUN piGera-ChAcesso(OUTPUT P-Ch-Acesso).  

        ASSIGN num-serie.ch-acesso = P-Ch-Acesso
               P-Ch-Acesso         = "".
    END.

    RUN piGeraMac (INPUT num-serie.it-codigo,
                   INPUT num-serie.num-pedido,
                   INPUT num-serie.n-serie,
                   INPUT num-serie.ID,
                   INPUT num-serie.ch-acesso).

    RELEASE num-serie.

END.


RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piImprimeEscpp097) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piImprimeEscpp097 Procedure 
PROCEDURE piImprimeEscpp097 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER p-it-codigo          AS CHAR     NO-UNDO.
DEFINE INPUT PARAMETER p-cod-modelo         AS INT      NO-UNDO.
DEFINE INPUT PARAMETER p-sigla              AS CHAR     NO-UNDO.
DEFINE INPUT PARAMETER p-qtd-etiquetas      AS INTEGER  NO-UNDO.
DEFINE INPUT PARAMETER p-qtd-embalagem      AS INTEGER  NO-UNDO.
DEFINE INPUT PARAMETER p-motivo-reimp       AS INTEGER  NO-UNDO.
DEFINE INPUT PARAMETER p-num-pedido         AS INTEGER  NO-UNDO.
DEFINE INPUT PARAMETER p-impressora         AS CHAR     NO-UNDO.
DEFINE INPUT PARAMETER p-tipo-processo      AS INTEGER  NO-UNDO.  /* 1 - Geraá∆o e Impress∆o,  2 - Somente Impress∆o,  3 - Somente Geraá∆o, 4 - N∆o valida (pois j† foi validado no Tipo 1) */
DEFINE INPUT PARAMETER lastec               AS LOGICAL  NO-UNDO.
DEFINE INPUT PARAMETER p-capacidade         AS INTEGER  NO-UNDO.
DEFINE INPUT PARAMETER p-ID                 AS CHAR     NO-UNDO.
DEFINE INPUT PARAMETER p-Ch-Acesso          AS CHAR     NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR tt-lista-ns.    

DEFINE VARIABLE c-logo         AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-cnpj         AS CHARACTER NO-UNDO.
DEFINE VARIABLE l-reimp        AS LOGICAL   NO-UNDO.
DEFINE VARIABLE i-motivo-reimp AS INTEGER   NO-UNDO.
DEFINE VARIABLE c-data         AS CHARACTER NO-UNDO.
DEFINE VARIABLE i-cont         AS INTEGER   NO-UNDO.
DEFINE VARIABLE i-tot          AS INTEGER   NO-UNDO.
DEFINE VARIABLE i-col          AS INTEGER   NO-UNDO.
DEFINE VARIABLE c-cgc          AS CHAR FORMAT "99999999/9999-99" NO-UNDO. 
DEFINE VARIABLE i-cont-kit     AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-soma-kit     AS INTEGER     NO-UNDO.
DEFINE VARIABLE c-texto        AS CHARACTER   NO-UNDO.
DEFINE VARIABLE l-coletiva     AS LOGICAL     NO-UNDO.
DEFINE VARIABLE i-lin          AS INTEGER     NO-UNDO.
DEFINE VARIABLE c-qrcode       AS CHAR FORMAT "x(60)" NO-UNDO.

EMPTY TEMP-TABLE tt-erro.

RUN piValidate (INPUT p-it-codigo,
                INPUT p-cod-modelo,
                INPUT p-sigla,
                INPUT p-qtd-etiquetas,
                INPUT p-motivo-reimp,
                INPUT p-num-pedido,
                INPUT p-impressora,
                INPUT p-tipo-processo).

IF modelo-etiq.val-ean THEN DO:
    FOR FIRST item-mat
        WHERE item-mat.it-codigo = p-it-codigo NO-LOCK:
    END.

    IF NOT AVAIL item-mat OR
       (AVAIL item-mat AND item-mat.cod-ean = "") THEN DO:
        RUN piGeraErro (INPUT 17006,
                        INPUT "N∆o existe EAN cadastrado, solicitar a Engenharia industrial.").
    END.
END.

IF NOT AVAIL item-ean THEN
    RUN piGeraErro(INPUT 17006,
                   INPUT "Item n∆o permite geraá∆o de n£mero de sÇrie~~Solicitar parametrizaá∆o Ö Engenharia Industrial.").

IF CAN-FIND(FIRST tt-erro) THEN
    RETURN "NOK":U.

ASSIGN i-motivo-reimp = p-motivo-reimp
       l-reimp        = IF p-motivo-reimp <> 0 AND p-motivo-reimp <> ? THEN YES ELSE NO.

IF modelo-etiq.tipo = 7 OR modelo-etiq.tipo = 8 THEN DO:
    IF NOT CAN-FIND(FIRST tt-lista-ns) THEN
        RUN piGeraEtiq(INPUT p-qtd-etiquetas,
                       INPUT p-qtd-embalagem).
    ELSE
        RUN piBuscaEtiq(OUTPUT p-qtd-embalagem).
END.

{esapi/esapi016-600dpi.i}

RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piImpressao) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piImpressao Procedure 
PROCEDURE piImpressao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER p-num-po             AS INT      NO-UNDO.
DEFINE INPUT PARAMETER p-it-codigo          AS CHAR     NO-UNDO.
DEFINE INPUT PARAMETER p-cod-modelo         AS INT      NO-UNDO.
DEFINE INPUT PARAMETER p-sigla              AS CHAR     NO-UNDO.
DEFINE INPUT PARAMETER p-qtd-etiquetas      AS INTEGER  NO-UNDO.
DEFINE INPUT PARAMETER p-qtd-embalagem      AS INTEGER  NO-UNDO.
DEFINE INPUT PARAMETER p-motivo-reimp       AS INTEGER  NO-UNDO.
DEFINE INPUT PARAMETER p-num-pedido         AS INTEGER  NO-UNDO.
DEFINE INPUT PARAMETER p-impressora         AS CHAR     NO-UNDO.
DEFINE INPUT PARAMETER p-tipo-processo      AS INTEGER  NO-UNDO.  /* 1 - Geraá∆o e Impress∆o,  2 - Somente Impress∆o,  3 - Somente Geraá∆o, 4 - N∆o valida (pois j† foi validado no Tipo 1) */
DEFINE INPUT PARAMETER lastec               AS LOGICAL  NO-UNDO.
DEFINE INPUT PARAMETER p-capacidade         AS INTEGER  NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR tt-lista-ns.    

DEFINE VARIABLE c-logo         AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-cnpj         AS CHARACTER NO-UNDO.
DEFINE VARIABLE l-reimp        AS LOGICAL   NO-UNDO.
DEFINE VARIABLE i-motivo-reimp AS INTEGER   NO-UNDO.
DEFINE VARIABLE c-data         AS CHARACTER NO-UNDO.
DEFINE VARIABLE i-cont         AS INTEGER   NO-UNDO.
DEFINE VARIABLE i-tot          AS INTEGER   NO-UNDO.
DEFINE VARIABLE i-col          AS INTEGER   NO-UNDO.
DEFINE VARIABLE c-cgc          AS CHAR FORMAT "99999999/9999-99" NO-UNDO. 
DEFINE VARIABLE i-cont-kit     AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-soma-kit     AS INTEGER     NO-UNDO.
DEFINE VARIABLE c-texto        AS CHARACTER   NO-UNDO.
DEFINE VARIABLE l-coletiva     AS LOGICAL     NO-UNDO.
DEFINE VARIABLE i-lin          AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-tot-mac      AS INTEGER     NO-UNDO.
DEFINE VARIABLE c-mac          AS CHAR        NO-UNDO.
DEFINE VARIABLE c-mac-ext      AS CHAR EXTENT 2  NO-UNDO.

EMPTY TEMP-TABLE tt-erro.

RUN piValidate (INPUT p-it-codigo,
                INPUT p-cod-modelo,
                INPUT p-sigla,
                INPUT p-qtd-etiquetas,
                INPUT p-motivo-reimp,
                INPUT p-num-pedido,
                INPUT p-impressora,
                INPUT p-tipo-processo).

IF modelo-etiq.val-ean THEN DO:
    FOR FIRST item-mat
        WHERE item-mat.it-codigo = p-it-codigo NO-LOCK:
    END.

    IF NOT AVAIL item-mat OR
       (AVAIL item-mat AND item-mat.cod-ean = "") THEN DO:
        RUN piGeraErro (INPUT 17006,
                        INPUT "N∆o existe EAN cadastrado, solicitar a Engenharia industrial.").
    END.
END.

IF NOT AVAIL item-ean THEN
    RUN piGeraErro(INPUT 17006,
                   INPUT "Item n∆o permite geraá∆o de n£mero de sÇrie~~Solicitar parametrizaá∆o Ö Engenharia Industrial.").

IF CAN-FIND(FIRST tt-erro) THEN
    RETURN "NOK":U.

ASSIGN i-motivo-reimp = p-motivo-reimp
       l-reimp        = IF p-motivo-reimp <> 0 AND p-motivo-reimp <> ? THEN YES ELSE NO.

IF modelo-etiq.tipo = 7 OR modelo-etiq.tipo = 8 THEN DO:
    IF NOT CAN-FIND(FIRST tt-lista-ns) THEN
        RUN piGeraEtiq(INPUT p-qtd-etiquetas,
                       INPUT p-qtd-embalagem).
    ELSE
        RUN piBuscaEtiq(OUTPUT p-qtd-embalagem).
END.

ASSIGN l-registra-dup = NO.

FIND FIRST ponto-programa
     where ponto-programa.nome-programa = 'log-ns-dup'
       AND ponto-programa.ponto = 1
           NO-LOCK NO-ERROR.

IF AVAIL ponto-programa 
THEN ASSIGN l-registra-dup = YES.

//OUTPUT TO VALUE("C:\Temp\teste\teste-etq3.txt").
OUTPUT TO VALUE(v_nom_disposit_so) PAGE-SIZE 0 CONVERT TARGET "IBM850" SOURCE "ISO8859-1".

EMPTY TEMP-TABLE tt-ns-dup.

{esapi/esapi016a.i}

OUTPUT CLOSE.

IF l-registra-dup = YES AND
   CAN-FIND (FIRST tt-ns-dup WHERE
                   tt-ns-dup.duplicado = YES ) 
THEN DO:
    IF OPSYS <> "UNIX" 
    THEN DO:
    
        OUTPUT TO VALUE("\\erpapp\spool\vi057803\impress-dup-ns-" + string(DAY(TODAY)) + string(MONTH(TODAY)) + "-" + STRING(TIME) + ".txt" ).
    
            PUT UNFORMATTED "NS Temp; NS Banco;Modelo;Item;Duplicado;Estab;Usuario" SKIP.

            FOR EACH tt-ns-dup WHERE
                     tt-ns-dup.duplicado = YES
                     NO-LOCK.

                PUT UNFORMATTED
                    tt-ns-dup.n-serie-tmp ";"
                    tt-ns-dup.n-serie-bd  ";"
                    tt-ns-dup.modelo      ";"
                    tt-ns-dup.it-codigo   ";"
                    tt-ns-dup.duplicado   ";"
                    v_cod_estab_usuar     ";"
                    c-seg-usuario         ";"
                    SKIP.
                
            END.

        OUTPUT CLOSE.
    
    END.
END.

RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piRandomChar) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piRandomChar Procedure 
PROCEDURE piRandomChar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE OUTPUT PARAMETER p-char AS CHAR NO-UNDO.

DEFINE VARIABLE c-array-char AS CHAR NO-UNDO.
DEFINE VARIABLE i-char AS INTEGER     NO-UNDO.

ASSIGN c-array-char = "A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,0,1,2,3,4,5,6,7,8,9".

ASSIGN i-char = RANDOM(1, NUM-ENTRIES(c-array-char)).

ASSIGN p-char = ENTRY(i-char,c-array-char).

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piRetornaErros) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piRetornaErros Procedure 
PROCEDURE piRetornaErros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE OUTPUT PARAMETER TABLE FOR tt-erro.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piValidate) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piValidate Procedure 
PROCEDURE piValidate :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER p-it-codigo          AS CHAR     NO-UNDO.
DEFINE INPUT PARAMETER p-cod-modelo         AS INT      NO-UNDO.
DEFINE INPUT PARAMETER p-sigla              AS CHAR     NO-UNDO.
DEFINE INPUT PARAMETER p-qtd-etiquetas      AS INTEGER  NO-UNDO.
DEFINE INPUT PARAMETER p-motivo-reimp       AS INTEGER  NO-UNDO.
DEFINE INPUT PARAMETER p-num-pedido         AS INTEGER  NO-UNDO.
DEFINE INPUT PARAMETER p-impressora         AS CHAR     NO-UNDO.
DEFINE INPUT PARAMETER p-tipo-processo      AS INTEGER  NO-UNDO.  /* 1 - Geraá∆o e Impress∆o,  2 - Somente Impress∆o,  3 - Somente Geraá∆o, 4 - N∆o valida (pois j† foi validado no Tipo 1) */

DEFINE VARIABLE d-aux    AS DATE        NO-UNDO.
DEFINE VARIABLE cPrinter AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cLayout  AS CHARACTER   NO-UNDO.

IF NOT can-find(FIRST ITEM WHERE ITEM.it-codigo = p-it-codigo) THEN DO:
    RUN piGeraErro (INPUT 56,
                    INPUT "Item").
END.

FOR FIRST modelo-etiq NO-LOCK
    WHERE modelo-etiq.cod-modelo = p-cod-modelo:
END.

/* Geraá∆o e Impress∆o ou Somente Impress∆o */
IF p-tipo-processo = 1 OR p-tipo-processo = 2 OR p-tipo-processo = 4 THEN DO:

    IF NOT AVAIL modelo-etiq THEN DO:
        RUN piGeraErro (INPUT 56,
                        INPUT "Modelo Etiqueta").
    END.

    IF NOT CAN-FIND(FIRST item-mod-etiq
                    WHERE item-mod-etiq.it-codigo = p-it-codigo
                    AND   item-mod-etiq.cod-modelo = p-cod-modelo) THEN DO:

        RUN piGeraErro (INPUT 56,
                        INPUT "Item x Modelo Etiqueta").
    END.

    IF p-impressora = "" THEN DO:
        RUN piGeraErro (INPUT 4306,
                        INPUT c-seg-usuario).
    END.
    ELSE DO:
        IF NUM-ENTRIES(p-impressora, ":":U) = 2 THEN DO:
            ASSIGN cPrinter = SUBSTRING(p-impressora, 1, INDEX(p-impressora, ":":U) - 1)
                   cLayout  = SUBSTRING(p-impressora, INDEX(p-impressora, ":":U) + 1, LENGTH(p-impressora) - INDEX(p-impressora, ":":U)).
    
            FIND FIRST imprsor_usuar USE-INDEX imprsrsr_id
                WHERE imprsor_usuar.nom_impressora = cPrinter
                  AND imprsor_usuar.cod_usuario    = c-seg-usuario NO-LOCK NO-ERROR.
    
            IF NOT AVAILABLE imprsor_usuar THEN DO:
                RUN piGeraErro (INPUT 4306,
                                INPUT c-seg-usuario).
            END.
    
            FIND FIRST layout_impres
                WHERE layout_impres.nom_impressora    = cPrinter
                  AND layout_impres.cod_layout_impres = cLayout NO-LOCK NO-ERROR.
    
            IF NOT AVAILABLE layout_impres THEN DO:
                RUN piGeraErro (INPUT 4306,
                                INPUT c-seg-usuario).
            END.
        END.
        ELSE DO:
            IF NUM-ENTRIES(p-impressora, ":":U) < 2 THEN DO:
                RUN piGeraErro (INPUT 4306,
                                INPUT c-seg-usuario).
            END.
    
            ASSIGN cPrinter = ENTRY(1, p-impressora, ":":U)
                   cLayout  = ENTRY(2, p-impressora, ":":U).
    
            FIND FIRST imprsor_usuar USE-INDEX imprsrsr_id
                WHERE imprsor_usuar.nom_impressora = cPrinter
                  AND imprsor_usuar.cod_usuario    = c-seg-usuario NO-LOCK NO-ERROR.
    
            IF NOT AVAILABLE imprsor_usuar THEN DO:
                RUN piGeraErro (INPUT 4306,
                                INPUT c-seg-usuario).
            END.
    
            FIND FIRST layout_impres
                WHERE layout_impres.nom_impressora = cPrinter
                  AND layout_impres.cod_layout_impres = cLayout NO-LOCK NO-ERROR.
    
            IF NOT AVAILABLE layout_impres THEN DO:
                RUN piGeraErro (INPUT 4306,
                                INPUT c-seg-usuario).
            END.
        END.

        ASSIGN v_nom_disposit_so = "".
    
        IF AVAIL imprsor_usuar THEN
            ASSIGN v_nom_disposit_so = imprsor_usuar.nom_disposit_so.
    

        IF v_nom_disposit_so = "" THEN DO:
            RUN piGeraErro (INPUT 17006,
                            INPUT "Impressora inv†lida.").
        END.
    END.
END.

/* Somente Impress∆o */
IF p-tipo-processo = 2 THEN DO:
    IF AVAIL modelo-etiq THEN DO:
        IF modelo-etiq.tipo <> 1 AND modelo-etiq.tipo <> 7 AND modelo-etiq.tipo <> 8 THEN DO:
            RUN piGeraErro (INPUT 17006,
                            INPUT "Modelo deve ser do Tipo 1 - N£mero de SÇrie.").
        END.
    END.

    /* REIMPRESSAO */
    IF p-motivo-reimp = 0 OR p-motivo-reimp = ? THEN DO:
        RUN piGeraErro (INPUT 17006,
                        INPUT "Motivo de Reimpress∆o deve ser informado.").
    END.
END.

FOR FIRST item-ean NO-LOCK
    WHERE item-ean.it-codigo = p-it-codigo:
END.

IF p-tipo-processo = 3 THEN DO:
    IF NOT AVAIL item-ean THEN DO:
        CREATE item-ean.
        ASSIGN item-ean.it-codigo = p-it-codigo.
    END.
END.

IF modelo-etiq.val-ean THEN DO:
    IF NOT AVAIL item-ean THEN DO:
        RUN piGeraErro (INPUT 56,
                        INPUT "Cadastro Etiqueta do Produto (ESCPP020)").
    END.
END.

/* Geraá∆o e Impress∆o */
IF p-tipo-processo = 1 THEN DO:
    IF AVAIL modelo-etiq THEN DO:
        IF modelo-etiq.tipo <> 1 THEN DO:
            RUN piGeraErro (INPUT 17006,
                            INPUT "Tipo do Modelo de Etiqueta deve ser 1 - N£mero de SÇrie. ~~~~ Para geraá∆o de N£mero de SÇrie o Tipo do Modelo de Etiqueta deve ser 1 - N£mero de SÇrie.").
        END.
    END.

    /* Validade Homologaá∆o Anatel */
    IF modelo-etiq.val-anatel THEN DO:
        IF CAN-FIND (FIRST int-item
                     WHERE int-item.it-codigo = p-it-codigo
                     AND   int-item.dt-venc-homologacao <> ?
                     AND   int-item.dt-venc-homologacao  < TODAY) then do:

            RUN piGeraErro (INPUT 17006,
                            INPUT "Item com homologaá∆o Anatel vencida.~~~~Etiqueta n∆o pode ser impressa, item com homologaá∆o Anatel vencida.").
        END. 
    END.
END.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

PROCEDURE piGeraMac:

    DEFINE INPUT PARAMETER p-it-codigo          AS CHAR     NO-UNDO.
    DEFINE INPUT PARAMETER p-num-pedido         AS INTEGER  NO-UNDO.
    DEFINE INPUT PARAMETER p-n-serie            AS CHAR     NO-UNDO.
    DEFINE INPUT PARAMETER p-ID                 AS CHAR     NO-UNDO.
    DEFINE INPUT PARAMETER p-Ch-Acesso          AS CHAR     NO-UNDO.

    DEFINE VARIABLE h-api023   AS HANDLE    NO-UNDO.
    DEFINE VARIABLE i-emitente AS INTEGER   NO-UNDO.
    DEFINE VARIABLE c-nome     AS CHARACTER NO-UNDO.
    DEFINE VARIABLE c-email    AS CHARACTER NO-UNDO.
    DEFINE VARIABLE i-macgera  AS INTEGER   NO-UNDO.

    //Limpa tabelas temporarias
    FOR EACH tt-mac-address. DELETE tt-mac-address. END.
    FOR EACH ttitem.         DELETE ttitem.         END.

    RUN esapi/esapi023.p PERSISTENT SET h-api023.

    IF CAN-FIND(FIRST tt-erro) THEN DO:
        IF VALID-HANDLE(h-api023) THEN
            DELETE PROCEDURE h-api023.
        RETURN "NOK".
    END.

    CREATE ttItem.
    ASSIGN ttItem.num-pedido = p-num-pedido
           ttItem.it-codigo  = p-it-codigo
           ttitem.marcado    = YES
           ttitem.gerado-mac = 0
           ttItem.qt-pedido  = 1 .

    RUN piPreMac IN h-api023 (INPUT  TABLE ttItem,
                              OUTPUT TABLE tt-mac-address,
                              OUTPUT TABLE tt-erro).

    IF RETURN-VALUE <> "OK" THEN DO:
        IF VALID-HANDLE(h-api023) THEN
            DELETE PROCEDURE h-api023.
        RETURN "NOK".
    END.

    RUN piGeraMac IN h-api023 (INPUT p-num-pedido,
                               INPUT-OUTPUT TABLE tt-mac-address,
                               INPUT-OUTPUT TABLE tt-erro).

    IF VALID-HANDLE(h-api023) THEN
        DELETE PROCEDURE h-api023.

    IF CAN-FIND(FIRST tt-erro) THEN
        RETURN "NOK".

    IF NOT CAN-FIND(FIRST tt-mac-address) THEN DO:
        CREATE tt-erro.
        ASSIGN tt-erro.cd-erro = 17006
               tt-erro.mensagem = "Mac address n∆o foi gerado.".
        RETURN "NOK".
    END.

    FOR EACH tt-mac-address:
        FIND FIRST mac-address WHERE
                   mac-address.mac = tt-mac-address.mac
                   EXCLUSIVE-LOCK.

        IF AVAIL mac-address 
        THEN ASSIGN mac-address.n-serie   = p-n-serie
                    mac-address.ID        = p-ID
                    mac-address.ch-acesso = p-Ch-Acesso.
    END.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE piGera-ChAcesso:

DEFINE OUTPUT PARAMETER p-char AS CHAR NO-UNDO.

DEFINE VAR i-con  AS INTE NO-UNDO.
DEFINE VAR c-ran  AS CHAR NO-UNDO.

DO i-con = 1 TO 8:
    RUN piRandomCharCH(INPUT i-con,
                       OUTPUT c-ran).

    ASSIGN p-char = p-char + c-ran.
END.

END PROCEDURE.

PROCEDURE piRandomCharCH :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER p-pos  AS INTE NO-UNDO.
DEFINE OUTPUT PARAMETER p-char AS CHAR NO-UNDO.

DEFINE VARIABLE c-array-char       AS CHAR NO-UNDO.
DEFINE VARIABLE c-array-char-letra AS CHAR NO-UNDO.
DEFINE VARIABLE c-array-char-num   AS CHAR NO-UNDO.
DEFINE VARIABLE i-char             AS INTEGER     NO-UNDO.

ASSIGN c-array-char       = "A,B,C,D,E,F,G,H,I,J,K,L,M,N,P,Q,R,S,T,U,V,W,X,Y,Z,1,2,3,4,5,6,7,8,9".
ASSIGN c-array-char-letra = "A,B,C,D,E,F,G,H,I,J,K,L,M,N,P,Q,R,S,T,U,V,W,X,Y,Z".
ASSIGN c-array-char-num   = "1,2,3,4,5,6,7,8,9".

IF p-pos = 1
THEN DO:
    ASSIGN i-char = RANDOM(1, NUM-ENTRIES(c-array-char-letra)).

    ASSIGN p-char = ENTRY(i-char,c-array-char-letra).
END.
ELSE DO:
    IF (p-pos = 7 OR p-pos = 8) THEN
    DO:
       ASSIGN i-char = RANDOM(1, NUM-ENTRIES(c-array-char-num)).
       
       ASSIGN p-char = ENTRY(i-char,c-array-char-num).
    END.
    ELSE DO:
       ASSIGN i-char = RANDOM(1, NUM-ENTRIES(c-array-char)).
       
       ASSIGN p-char = ENTRY(i-char,c-array-char).
    END.
END.

RETURN "OK".

END PROCEDURE.

PROCEDURE piAlteraEscpp105 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-escpp105  AS LOGICAL NO-UNDO.

    ASSIGN l-escpp105-imp-data = p-escpp105.

    RETURN "OK".

END PROCEDURE.


