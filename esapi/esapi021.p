
&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*------------------------------------------------------------------------
    File        : esapi/ESAPI021.p
    Purpose     : Coletores
    Author(s)   : Maicon Roberto Correa (Sensus)
    Created     : 31/07/2014
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

DEFINE VARIABLE fi-etiq-volume      AS CHARACTER    NO-UNDO.
DEFINE VARIABLE fi-ean13            AS CHAR         NO-UNDO.
DEFINE VARIABLE l-nota-exportacao   AS LOGICAL      NO-UNDO.
DEFINE VARIABLE fi-cod-estabel      AS CHAR         NO-UNDO.
DEFINE VARIABLE fi-serie            AS CHAR         NO-UNDO.
DEFINE VARIABLE fi-nr-nota-fis      AS CHAR         NO-UNDO.
DEFINE VARIABLE fi-nr-volume        AS INT          NO-UNDO.
DEFINE VARIABLE lvarios             AS LOGICAL      NO-UNDO.
DEFINE VARIABLE lcompleto           AS LOGICAL      NO-UNDO.
DEFINE VARIABLE fi-it-codigo        AS CHAR         NO-UNDO.
DEFINE VARIABLE fi-desc-item        AS CHAR         NO-UNDO.
DEFINE VARIABLE fi-qtd              AS INT          NO-UNDO.
DEFINE VARIABLE fi-qtd-col          AS INT          NO-UNDO.
DEFINE VARIABLE pit-codigo-aux      AS CHAR         NO-UNDO.
DEFINE VARIABLE c-tipo-aux          AS CHARACTER    NO-UNDO.
DEFINE VARIABLE fi-tipo-etiq        AS CHARACTER    NO-UNDO.
DEFINE VARIABLE h-esapi003          AS HANDLE       NO-UNDO.

def new global shared var v_cod_usuar_corren
    as character
    format "x(12)":U
    label "Usuˇrio Corrente"
    column-label "Usuˇrio Corrente"
    no-undo.

/*DEFINE NEW GLOBAL SHARED VAR c-seg-usuario AS CHAR NO-UNDO.*/

{esapi/esapi021.i}

DEFINE BUFFER bvolume-nf FOR volume-nf.
DEFINE BUFFER bitem-ean          FOR item-ean.
DEFINE BUFFER bcaixa-ns-volume   FOR ns-volume.
DEFINE BUFFER bpallet-ns-volume  FOR ns-volume.
DEFINE BUFFER bpallet-ns-volume2 FOR ns-volume.
DEFINE BUFFER bitem-dun          FOR item-dun.



FUNCTION f-item-rastr RETURNS LOGICAL
  ( INPUT p-it-codigo AS CHAR )  FORWARD.

FUNCTION fnDescItem RETURNS CHARACTER
  ( c-it-codigo AS CHAR )  FORWARD.


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
         HEIGHT             = 8.38
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

&IF DEFINED(EXCLUDE-pi-carga-volume) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carga-volume Procedure 
PROCEDURE pi-carga-volume :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER  p-fi-etiq-volume       AS CHAR NO-UNDO.
    DEFINE OUTPUT PARAMETER p-l-nota-exportacao   AS LOGICAL NO-UNDO.
    DEFINE OUTPUT PARAMETER p-fi-cod-estabel      AS CHAR NO-UNDO.
    DEFINE OUTPUT PARAMETER p-fi-serie            AS CHAR NO-UNDO.
    DEFINE OUTPUT PARAMETER p-fi-nr-nota-fis      AS CHAR NO-UNDO.
    DEFINE OUTPUT PARAMETER p-fi-nr-volume        AS INT NO-UNDO.
    DEFINE OUTPUT PARAMETER p-lvarios             AS LOG NO-UNDO.
    DEFINE OUTPUT PARAMETER p-lcompleto           AS LOG NO-UNDO.
    DEFINE OUTPUT PARAMETER p-fi-it-codigo        AS CHAR NO-UNDO.
    DEFINE OUTPUT PARAMETER p-fi-desc-item        AS CHAR NO-UNDO.
    DEFINE OUTPUT PARAMETER p-fi-qtd              AS INT NO-UNDO.
    DEFINE OUTPUT PARAMETER p-fi-qtd-col          AS INT NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR tt-erro.

    


    EMPTY TEMP-TABLE tt-erro.

    ASSIGN fi-etiq-volume = p-fi-etiq-volume
           l-nota-exportacao = FALSE
           p-l-nota-exportacao = FALSE.

    if fi-etiq-volume = "" then 
        return "NOK":u.

    IF  LENGTH(fi-etiq-volume) <> 21 THEN DO:

        CREATE tt-erro.
        ASSIGN tt-erro.erro = "C¢digo de Barras inv†lido." + CHR(10) + "C¢digo de Barras coletado n∆o Ç correspondente ao volume. Verifique."
               tt-erro.pergunta = NO.

        RETURN "NOK":U.

    END. /* IF  LENGTH(fi-etiq-volume) */
    
    FIND FIRST bvolume-nf NO-LOCK
        WHERE  bvolume-nf.cod-estabel = SUBSTRING(fi-etiq-volume,1,3) 
        AND    bvolume-nf.serie       = STRING(INT(SUBSTRING(fi-etiq-volume,4,3))) 
        AND    bvolume-nf.nr-nota-fis = SUBSTRING(fi-etiq-volume,7,7) 
        AND    bvolume-nf.nr-volume   = INT(SUBSTRING(fi-etiq-volume,14,4)) NO-ERROR.

    IF  NOT AVAIL bvolume-nf THEN DO:

        CREATE tt-erro.
        ASSIGN tt-erro.erro = "Etiqueta inv†lida." + CHR(10) + "Volume n∆o encontrado no sistema."
               tt-erro.pergunta = NO.

        RETURN "NOK":U.

    END. /* IF  NOT AVAIL bvolume-nf */
    ELSE DO:

        IF  bvolume-nf.qtde = bvolume-nf.qtde-col THEN DO:

            /* Pode existir outro item com o mesmo N£mero de Volume */
            IF  CAN-FIND(FIRST bvolume-nf
                         WHERE bvolume-nf.cod-estabel = SUBSTRING(fi-etiq-volume,1,3) 
                         AND   bvolume-nf.serie       = STRING(INT(SUBSTRING(fi-etiq-volume,4,3))) 
                         AND   bvolume-nf.nr-nota-fis = SUBSTRING(fi-etiq-volume,7,7) 
                         AND   bvolume-nf.nr-volume   = INT(SUBSTRING(fi-etiq-volume,14,4)) 
                         AND   bvolume-nf.qtde       <> bvolume-nf.qtde-col) THEN 
                FIND NEXT bvolume-nf NO-LOCK
                    WHERE bvolume-nf.cod-estabel = SUBSTRING(fi-etiq-volume,1,3) 
                    AND   bvolume-nf.serie       = STRING(INT(SUBSTRING(fi-etiq-volume,4,3))) 
                    AND   bvolume-nf.nr-nota-fis = SUBSTRING(fi-etiq-volume,7,7) 
                    AND   bvolume-nf.nr-volume   = INT(SUBSTRING(fi-etiq-volume,14,4)) 
                    AND   bvolume-nf.qtde       <> bvolume-nf.qtde-col NO-ERROR.
        END.

        ASSIGN fi-cod-estabel = bvolume-nf.cod-estabel
               fi-serie       = bvolume-nf.serie
               fi-nr-nota-fis = bvolume-nf.nr-nota-fis
               fi-nr-volume   = bvolume-nf.nr-volume
               lvarios        = bvolume-nf.varios-itens
               lcompleto      = YES.

    END. /* ELSE DO: */

    FIND FIRST nota-fiscal NO-LOCK
        WHERE  nota-fiscal.cod-estabel = fi-cod-estabel
        AND    nota-fiscal.serie       = fi-serie
        AND    nota-fiscal.nr-nota-fis = fi-nr-nota-fis NO-ERROR.
    IF  AVAIL  nota-fiscal AND 
        nota-fiscal.nat-operacao BEGINS "7":U THEN 
        ASSIGN l-nota-exportacao = TRUE.
        
    /* Primeiro item a mostrar na tela */    
    IF  AVAIL bvolume-nf THEN
        ASSIGN fi-it-codigo = bvolume-nf.it-codigo
               fi-desc-item = fnDescItem(bvolume-nf.it-codigo)
               fi-qtd       = bvolume-nf.qtde
               fi-qtd-col   = bvolume-nf.qtde-col.
    
    FOR EACH  bvolume-nf NO-LOCK 
        WHERE bvolume-nf.cod-estab   = fi-cod-estabel 
        AND   bvolume-nf.serie       = fi-serie 
        AND   bvolume-nf.nr-nota-fis = fi-nr-nota-fis 
        AND   bvolume-nf.nr-volume   = fi-nr-volume:

        IF  bvolume-nf.qtde <> bvolume-nf.qtde-col 
        OR  bvolume-nf.qtde = 0 THEN DO:
            ASSIGN lcompleto = NO.
            LEAVE.
        END. /* IF  bbvolume-nf.qtde */
    END. /* FOR EACH  bbvolume-nf */

    ASSIGN p-l-nota-exportacao = l-nota-exportacao 
           p-fi-cod-estabel    = fi-cod-estabel    
           p-fi-serie          = fi-serie          
           p-fi-nr-nota-fis    = fi-nr-nota-fis    
           p-fi-nr-volume      = fi-nr-volume      
           p-lvarios           = lvarios           
           p-lcompleto         = lcompleto         
           p-fi-it-codigo      = fi-it-codigo      
           p-fi-desc-item      = fi-desc-item      
           p-fi-qtd            = fi-qtd            
           p-fi-qtd-col        = fi-qtd-col.

    RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


&IF DEFINED(EXCLUDE-pi-coleta) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-coleta Procedure 
PROCEDURE pi-coleta:
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT        PARAMETER p-fi-ean13            AS CHAR     NO-UNDO.
    DEFINE INPUT        PARAMETER p-fi-cod-estabel      AS CHAR     NO-UNDO.
    DEFINE INPUT        PARAMETER p-fi-serie            AS CHAR     NO-UNDO.
    DEFINE INPUT        PARAMETER p-fi-nr-nota-fis      AS CHAR     NO-UNDO.
    DEFINE INPUT        PARAMETER p-fi-nr-volume      AS INT      NO-UNDO.
    DEFINE OUTPUT       PARAMETER p-lcompleto         AS LOGICAL  NO-UNDO.
    DEFINE INPUT-OUTPUT PARAMETER p-fi-it-codigo      AS CHAR     NO-UNDO.
    DEFINE INPUT-OUTPUT PARAMETER p-fi-desc-item      AS CHAR     NO-UNDO.
    DEFINE INPUT-OUTPUT PARAMETER p-fi-qtd            AS INT      NO-UNDO.
    DEFINE INPUT-OUTPUT PARAMETER p-fi-qtd-col        AS INT      NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR tt-erro.

    ASSIGN fi-ean13 = p-fi-ean13
           fi-cod-estabel = p-fi-cod-estabel
           fi-serie = p-fi-serie
           fi-nr-nota-fis = p-fi-nr-nota-fis
           fi-nr-volume = p-fi-nr-volume
           fi-it-codigo   = p-fi-it-codigo   
           fi-desc-item   = p-fi-desc-item   
           fi-qtd         = p-fi-qtd         
           fi-qtd-col     = p-fi-qtd-col.

    EMPTY TEMP-TABLE tt-erro.

    BLOCO:
    DO  TRANSACTION ON ERROR UNDO BLOCO, LEAVE BLOCO:

        ASSIGN pit-codigo-aux = "":U
               c-tipo-aux = "":U.
        
        IF fi-ean13 = "":U THEN RETURN "NOK".

        RUN esapi/esapi003.p PERSISTENT SET h-esapi003.
        ASSIGN fi-tipo-etiq = DYNAMIC-FUNCTION("fnRetornaTpEtiq" IN h-esapi003,fi-ean13).
        IF (fi-ean13 BEGINS "ECO":U OR fi-tipo-etiq = "CAIXA":U) THEN DO: /* CAIXA */
            RUN pi-valida (INPUT "ECO":U).
            /*IF RETURN-VALUE = "NOK":U THEN UNDO BLOCO, LEAVE BLOCO.*/
            IF RETURN-VALUE = "NOK"  THEN DO:
                IF VALID-HANDLE(h-esapi003) THEN
                    DELETE PROCEDURE h-esapi003.
                RETURN "NOK".
            END.

            RUN pi_iniciaECO.
            IF VALID-HANDLE(h-esapi003) THEN
                DELETE PROCEDURE h-esapi003.
            /*IF RETURN-VALUE = "NOK":U THEN UNDO BLOCO, LEAVE BLOCO.*/
            IF RETURN-VALUE = "NOK"  THEN
                RETURN "NOK".
        END. /* IF  fi-ean13 BEGINS "ECO":U THEN */
        ELSE 
        IF (fi-ean13 BEGINS "EPA":U OR fi-tipo-etiq = "PALLET":U) THEN DO: /* PALLET */
            RUN pi-valida (INPUT "EPA":U).
            /*IF RETURN-VALUE = "NOK":U THEN UNDO BLOCO, LEAVE BLOCO.*/
            IF RETURN-VALUE = "NOK"  THEN DO:
                IF VALID-HANDLE(h-esapi003) THEN
                    DELETE PROCEDURE h-esapi003.
                RETURN "NOK".
            END.

            RUN pi_iniciaEPA.
            IF VALID-HANDLE(h-esapi003) THEN
                DELETE PROCEDURE h-esapi003.
            /*IF RETURN-VALUE = "NOK":U THEN UNDO BLOCO, LEAVE BLOCO.*/
            IF RETURN-VALUE = "NOK"  THEN
                RETURN "NOK".
        END. /* IF  fi-ean13 BEGINS "EPA":U THEN */
        ELSE DO:
            RUN pi-valida (INPUT "Demais":U).
            /*IF RETURN-VALUE = "NOK":U THEN UNDO BLOCO, LEAVE BLOCO.*/
            IF RETURN-VALUE = "NOK"  THEN DO:
                IF VALID-HANDLE(h-esapi003) THEN
                    DELETE PROCEDURE h-esapi003.
                RETURN "NOK".
            END.

            RUN pi_iniciaDemais.
            IF VALID-HANDLE(h-esapi003) THEN
                DELETE PROCEDURE h-esapi003.
            /*IF RETURN-VALUE = "NOK":U THEN UNDO BLOCO, LEAVE BLOCO.*/
            IF RETURN-VALUE = "NOK"  THEN
                RETURN "NOK".
        END. /* ELSE DO: */
    
    END. /* DO  TRANSACTION ON ERROR UNDO BLOCO, LEAVE BLOCO: */

    /* -------------------------------------------------------------- */

    ASSIGN lcompleto = YES.

    FOR EACH  bvolume-nf NO-LOCK
        WHERE bvolume-nf.cod-estab   = fi-cod-estabel
        AND   bvolume-nf.serie       = fi-serie
        AND   bvolume-nf.nr-nota-fis = fi-nr-nota-fis
        AND   bvolume-nf.nr-volume   = fi-nr-volume:

        IF  bvolume-nf.qtde <> bvolume-nf.qtde-col 
        OR  bvolume-nf.qtde = 0 THEN DO:
            ASSIGN lcompleto = NO.
            LEAVE.
        END. /* IF  bbvolume-nf.qtde */
    END. /* FOR EACH  bbvolume-nf */

    ASSIGN p-lcompleto     = lcompleto    
           p-fi-it-codigo  = fi-it-codigo 
           p-fi-desc-item  = fi-desc-item 
           p-fi-qtd        = fi-qtd       
           p-fi-qtd-col    = fi-qtd-col.

    RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


&IF DEFINED(EXCLUDE-pi_iniciaDemais) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi_iniciaDemais Procedure 
PROCEDURE pi_iniciaDemais:
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE l-ok AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE c-caixa AS CHARACTER   NO-UNDO.


    /*-[ EAN13 ]-*/
    FIND FIRST item-mat NO-LOCK WHERE item-mat.cod-ean = fi-ean13 NO-ERROR.
    IF  NOT AVAIL item-mat THEN DO:
        /*-[ DUN14 ]-*/
        FIND FIRST item-dun NO-LOCK WHERE item-dun.cod-dun = fi-ean13 NO-ERROR.
        IF  NOT AVAIL item-dun THEN DO:
            /*-[ N£mero de SÇrie ]-*/
            FIND FIRST num-serie NO-LOCK WHERE num-serie.n-serie = fi-ean13 NO-ERROR.
                IF  AVAIL num-serie THEN 
                ASSIGN pit-codigo-aux = num-serie.it-codigo
                       c-tipo-aux = "SERIAL":U.
        END. /* IF  NOT AVAIL item-dun THEN */
        ELSE ASSIGN pit-codigo-aux = item-dun.it-codigo
                    c-tipo-aux = "DUN14":U.
    END. /* IF  NOT AVAIL item-ean THEN */
    ELSE ASSIGN pit-codigo-aux = item-mat.it-codigo
                c-tipo-aux = "EAN13":U.
    
    FIND FIRST ns-volume
        WHERE  ns-volume.volume-filho = fi-ean13 NO-ERROR.
    IF  AVAIL  ns-volume 
    AND ns-volume.volume-pai <> "ECO-INDEFINIDA" THEN DO:

        RUN esp/clt/esclt006.w (INPUT "Produto n∆o pode ser relacionado a NF: produto relacionado a Caixa." + CHR(10) + "Deseja Desvincular?",
                                INPUT YES).
        ASSIGN l-ok = (RETURN-VALUE = "YES").
        IF  NOT l-ok THEN DO:
            RETURN "NOK":U.
        END. /* IF  NOT l-ok THEN */

        ASSIGN c-caixa = ns-volume.volume-pai.

        FOR EACH ns-volume
            WHERE ns-volume.volume-pai = c-caixa EXCLUSIVE-LOCK:

            DELETE ns-volume.
        END. /* FOR EACH ns-volume */
  
        FOR EACH ns-volume WHERE ns-volume.volume-filho = c-caixa: 
            DELETE ns-volume. 
        END. /* FOR EACH ns-volume */

    END. /* IF  AVAIL  ns-volume ... */
    
    IF  c-tipo-aux <> "SERIAL":U THEN DO:

        FIND FIRST ITEM NO-LOCK WHERE ITEM.it-codigo = pit-codigo-aux NO-ERROR.
        IF  AVAIL ITEM THEN 
            ASSIGN pit-codigo-aux = ITEM.it-codigo.
        
        FIND FIRST volume-nf EXCLUSIVE-LOCK                     
            WHERE  volume-nf.cod-estabel = fi-cod-estabel       
            AND    volume-nf.serie       = fi-serie             
            AND    volume-nf.nr-nota-fis = fi-nr-nota-fis       
            AND    volume-nf.nr-volume   = fi-nr-volume         
            AND    volume-nf.it-codigo   = pit-codigo-aux NO-ERROR. 
    
        IF  c-tipo-aux = "EAN13":U THEN DO:
            FIND FIRST item-caixa NO-LOCK
                WHERE  item-caixa.sigla-emb = volume-nf.sigla-emb
                AND    item-caixa.it-codigo = volume-nf.it-codigo NO-ERROR.
            IF  AVAIL item-caixa                
            AND item-caixa.qt-item = volume-nf.qtde 
            THEN ASSIGN volume-nf.qtde-col = volume-nf.qtde
                        volume-nf.tp-col   = 2.
            ELSE ASSIGN volume-nf.qtde-col = volume-nf.qtde-col + 1
                        volume-nf.tp-col   = 1.
        END.

        IF  c-tipo-aux = "DUN14":U THEN DO:
            FIND FIRST bitem-dun NO-LOCK
                WHERE  bitem-dun.cod-dun = fi-ean13 NO-ERROR.
            IF  AVAIL  bitem-dun THEN DO:
                IF  bitem-dun.qtd-emb = (fi-qtd - fi-qtd-col)
                THEN ASSIGN volume-nf.qtde-col = volume-nf.qtde
                            volume-nf.tp-col   = 2.
                ELSE IF  bitem-dun.qtd-emb < (fi-qtd - fi-qtd-col)
                     THEN ASSIGN volume-nf.qtde-col = bitem-dun.qtd-emb
                                 volume-nf.tp-col   = 1.
            END.
        END.
    
        ASSIGN volume-nf.usuario-col = v_cod_usuar_corren
               volume-nf.data-col    = TODAY
               volume-nf.char-1      = STRING(TIME,"hh:mm:ss").
    
        IF  volume-nf.qtde-col = volume-nf.qtde THEN DO:
            FIND NEXT bvolume-nf EXCLUSIVE-LOCK
                WHERE bvolume-nf.cod-estabel = fi-cod-estabel
                AND   bvolume-nf.serie       = fi-serie
                AND   bvolume-nf.nr-nota-fis = fi-nr-nota-fis
                AND   bvolume-nf.nr-volume   = fi-nr-volume NO-ERROR.
            IF  AVAIL bvolume-nf THEN DO:
                
                ASSIGN fi-it-codigo   = bvolume-nf.it-codigo             
                        fi-desc-item  = fnDescItem(bvolume-nf.it-codigo) 
                        fi-qtd        = bvolume-nf.qtde
                        fi-qtd-col    = bvolume-nf.qtde-col.

                RELEASE bvolume-nf.
    
                FIND NEXT bvolume-nf NO-LOCK
                    WHERE bvolume-nf.cod-estabel = fi-cod-estabel
                    AND   bvolume-nf.serie       = fi-serie
                    AND   bvolume-nf.nr-nota-fis = fi-nr-nota-fis
                    AND   bvolume-nf.nr-volume   = fi-nr-volume NO-ERROR.

            END.

        END.
        ELSE ASSIGN fi-it-codigo  = volume-nf.it-codigo            
                    fi-desc-item  = fnDescItem(volume-nf.it-codigo)
                    fi-qtd        = volume-nf.qtde         
                    fi-qtd-col    = volume-nf.qtde-col.    

        RELEASE volume-nf.

        FIND FIRST volume-nf NO-LOCK
            WHERE  volume-nf.cod-estabel = fi-cod-estabel       
            AND    volume-nf.serie       = fi-serie             
            AND    volume-nf.nr-nota-fis = fi-nr-nota-fis       
            AND    volume-nf.nr-volume   = fi-nr-volume         
            AND    volume-nf.it-codigo   = pit-codigo-aux NO-ERROR. 


    END. /* IF  c-tipo-aux <> "SERIAL":U THEN */
    
    IF  c-tipo-aux = "SERIAL":U THEN DO:
        /*---[ Leitura do N£m. de SÇrie ]---------------------*/
        RUN pi_leitura_num_serie (INPUT fi-ean13).

        IF  RETURN-VALUE = "NOK":U THEN
            RETURN "NOK":U.

    END. /* IF  c-tipo-aux = "SERIAL":U THEN */
    
    RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF





&IF DEFINED(EXCLUDE-pi_iniciaECO) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi_iniciaECO Procedure 
PROCEDURE pi_iniciaECO:
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE c-selec AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-pallet AS CHARACTER   NO-UNDO.


    FIND FIRST bcaixa-ns-volume NO-LOCK
         WHERE bcaixa-ns-volume.volume-filho = fi-ean13 NO-ERROR.

    IF  AVAIL  bcaixa-ns-volume THEN DO:

        /*---[ Tela com as opá‰es de desvinculaá∆o ]---------------------------*/
        RUN esp/clt/esclt003a.w (OUTPUT c-selec).

        IF  c-selec = "" THEN
            RETURN "NOK":U.

        IF  c-selec = "uma" THEN DO:
            FOR EACH bcaixa-ns-volume WHERE bcaixa-ns-volume.volume-filho = fi-ean13: 
                DELETE bcaixa-ns-volume. 
            END.
        END. /* IF  c-selec = "uma" THEN */

        IF  c-selec = "todas" THEN DO:
            ASSIGN c-pallet = "".
            FOR EACH   bcaixa-ns-volume 
                WHERE  bcaixa-ns-volume.volume-filho = fi-ean13:
                ASSIGN c-pallet = bcaixa-ns-volume.volume-pai.
            END. /* FOR EACH  bcaixa-ns-volume */

            IF  c-pallet <> "" THEN DO:
                FOR EACH bcaixa-ns-volume WHERE bcaixa-ns-volume.volume-pai = c-pallet: 
                    DELETE bcaixa-ns-volume. 
                END.
            END. /* IF  c-pallet <> "" THEN */
        END. /* IF  c-selec = "todas" THEN */
    END. /* IF  AVAIL bcaixa-ns-volume THEN */

    FOR EACH  bcaixa-ns-volume NO-LOCK
        WHERE bcaixa-ns-volume.volume-pai = fi-ean13:

        RUN pi_leitura_num_serie (INPUT bcaixa-ns-volume.volume-filho).

        IF  RETURN-VALUE = "NOK":U THEN
            RETURN "NOK":U.

    END. /* FOR EACH  bcaixa-ns-volume */




    RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF



&IF DEFINED(EXCLUDE-pi_iniciaEPA) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi_iniciaEPA Procedure 
PROCEDURE pi_iniciaEPA:
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE c-tp-etiq-f AS CHARACTER   NO-UNDO.

FOR EACH bpallet-ns-volume
   WHERE bpallet-ns-volume.volume-pai = fi-ean13 NO-LOCK:

    ASSIGN c-tp-etiq-f = DYNAMIC-FUNCTION("fnRetornaTpEtiq" IN h-esapi003,bpallet-ns-volume.volume-filho).

    IF c-tp-etiq-f = "CAIXA":U THEN DO:
        FOR EACH  bcaixa-ns-volume
            WHERE bcaixa-ns-volume.volume-pai = bpallet-ns-volume.volume-filho NO-LOCK:

       RUN pi_leitura_num_serie (INPUT bcaixa-ns-volume.volume-filho).

       IF  RETURN-VALUE = "NOK":U THEN 
           RETURN "NOK":U.
        END.
    END.
    ELSE IF c-tp-etiq-f = "NS":U THEN DO:
        RUN pi_leitura_num_serie (INPUT bcaixa-ns-volume.volume-filho).

        IF  RETURN-VALUE = "NOK":U THEN
            RETURN "NOK":U.
    END.
    END. /* FOR EACH bpallet-ns-volume */

    RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


&IF DEFINED(EXCLUDE-pi_leitura_num_serie) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi_leitura_num_serie Procedure 
PROCEDURE pi_leitura_num_serie:
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER p-etiqueta-nro-serie AS CHARACTER NO-UNDO.


    FIND FIRST num-serie NO-LOCK WHERE num-serie.n-serie = p-etiqueta-nro-serie NO-ERROR.
    IF  AVAIL num-serie THEN DO:

        FIND FIRST volume-nf EXCLUSIVE-LOCK 
            WHERE  volume-nf.cod-estabel = fi-cod-estabel
            AND    volume-nf.serie       = fi-serie
            AND    volume-nf.nr-nota-fis = fi-nr-nota-fis
            AND    volume-nf.nr-volume   = fi-nr-volume
            AND    volume-nf.it-codigo   = num-serie.it-codigo NO-ERROR.
        IF  AVAIL  volume-nf THEN DO:

            ASSIGN volume-nf.qtde-col    = volume-nf.qtde-col + 1
                   volume-nf.tp-col      = 1
                   volume-nf.usuario-col = v_cod_usuar_corren
                   volume-nf.data-col    = TODAY
                   volume-nf.char-1      = STRING(TIME,"hh:mm:ss").

            IF  volume-nf.qtde-col = volume-nf.qtde THEN DO:

                FIND FIRST bvolume-nf EXCLUSIVE-LOCK
                    WHERE  bvolume-nf.cod-estabel = fi-cod-estabel
                    AND    bvolume-nf.serie       = fi-serie
                    AND    bvolume-nf.nr-nota-fis = fi-nr-nota-fis
                    AND    bvolume-nf.nr-volume   = fi-nr-volume
                    AND    bvolume-nf.qtde-col   <> bvolume-nf.qtde NO-ERROR.

                IF  AVAIL bvolume-nf THEN DO:

                    ASSIGN fi-it-codigo = bvolume-nf.it-codigo             
                           fi-desc-item = fnDescItem(bvolume-nf.it-codigo) 
                           fi-qtd       = bvolume-nf.qtde
                           fi-qtd-col   = bvolume-nf.qtde-col.     

                    RELEASE bvolume-nf.

                    FIND FIRST bvolume-nf NO-LOCK
                        WHERE  bvolume-nf.cod-estabel = fi-cod-estabel
                        AND    bvolume-nf.serie       = fi-serie
                        AND    bvolume-nf.nr-nota-fis = fi-nr-nota-fis
                        AND    bvolume-nf.nr-volume   = fi-nr-volume
                        AND    bvolume-nf.qtde-col   <> bvolume-nf.qtde NO-ERROR.
                                             
                END.
            END. /* IF  volume-nf.qtde-col = volume-nf.qtde */
            ELSE ASSIGN fi-it-codigo = volume-nf.it-codigo            
                        fi-desc-item = fnDescItem(volume-nf.it-codigo)
                        fi-qtd       = volume-nf.qtde 
                        fi-qtd-col   = volume-nf.qtde-col.
            
            IF  NOT CAN-FIND(FIRST num-serie-rast
                             WHERE num-serie-rast.cod-estabel = fi-cod-estabel
                             AND   num-serie-rast.serie       = fi-serie                
                             and   num-serie-rast.nr-nota-fis = fi-nr-nota-fis    
                             and   num-serie-rast.n-serie     = p-etiqueta-nro-serie) THEN DO:

                CREATE num-serie-rast.
                ASSIGN num-serie-rast.cod-estabel = fi-cod-estabel    
                       num-serie-rast.serie       = fi-serie                
                       num-serie-rast.nr-nota-fis = fi-nr-nota-fis    
                       num-serie-rast.nr-volume   = fi-nr-volume        
                       num-serie-rast.n-serie     = p-etiqueta-nro-serie
                       num-serie-rast.it-codigo   = num-serie.it-codigo
                       num-serie-rast.data        = NOW
                       num-serie-rast.usuario     = v_cod_usuar_corren /*c-seg-usuario*/ .

                RELEASE num-serie-rast.

            END. /* IF  NOT CAN-FIND(FIRST num-serie-rast */

        END. /* IF  AVAIL  volume-nf THEN DO: */

        RELEASE volume-nf.

        FIND FIRST volume-nf NO-LOCK
            WHERE  volume-nf.cod-estabel = fi-cod-estabel
            AND    volume-nf.serie       = fi-serie
            AND    volume-nf.nr-nota-fis = fi-nr-nota-fis
            AND    volume-nf.nr-volume   = fi-nr-volume
            AND    volume-nf.it-codigo   = num-serie.it-codigo NO-ERROR.

    END. /* IF  AVAIL num-serie THEN DO: */

    RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


&IF DEFINED(EXCLUDE-pi-valida) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida Procedure 
PROCEDURE pi-valida:
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT PARAM p-quemChamou AS CHAR NO-UNDO.  /* ECO, EPA ou demais */

    DEFINE VARIABLE i_conta_registros AS INTEGER     NO-UNDO.

    CASE p-quemChamou:
        WHEN "ECO":U    THEN DO:

            FIND FIRST bcaixa-ns-volume NO-LOCK
                 WHERE bcaixa-ns-volume.volume-pai = fi-ean13 NO-ERROR.
            IF  NOT AVAIL  bcaixa-ns-volume THEN DO:

                CREATE tt-erro.
                ASSIGN tt-erro.erro = "Etiqueta de caixa n∆o relacionada a produto ou pallet."
                       tt-erro.pergunta = NO.

                RETURN "NOK":U.

            END. /* IF  NOT AVAIL  bcaixa-ns-volume */
            ELSE DO:

                FIND FIRST num-serie NO-LOCK
                    WHERE  num-serie.n-serie = bcaixa-ns-volume.volume-filho NO-ERROR.
                IF  AVAIL  num-serie 
                AND num-serie.it-codigo <> fi-it-codigo THEN DO:

                    CREATE tt-erro.
                    ASSIGN tt-erro.erro = "Item coletado diferente do solicitado.":U + CHR(10) + "O item a ser coletado Ç o ":U + trim(string(fi-it-codigo))
                           tt-erro.pergunta = NO.

                    RETURN "NOK":U.

                END. /* IF  AVAIL num-serie ... */
            END. /* ELSE DO: */

            ASSIGN i_conta_registros = 0.
            FOR EACH  bcaixa-ns-volume NO-LOCK
                WHERE bcaixa-ns-volume.volume-pai = fi-ean13:

                IF CAN-FIND (FIRST num-serie-rast
                             WHERE num-serie-rast.cod-estabel = fi-cod-estabel
                             AND   num-serie-rast.serie       = fi-serie 
                             AND   num-serie-rast.nr-nota-fis = fi-nr-nota-fis
                             AND   num-serie-rast.n-serie     = bcaixa-ns-volume.volume-filho ) THEN DO:

                    CREATE tt-erro.
                    ASSIGN tt-erro.erro = "N£mero de SÇrie j† vinculado a esta Nota Fiscal.":U
                           tt-erro.pergunta = NO.
                        
                    RETURN "NOK":U.

                END.

                /**/

                FOR EACH num-serie-rast NO-LOCK
                    WHERE num-serie-rast.n-serie      = bcaixa-ns-volume.volume-filho AND
                         (num-serie-rast.cod-estabel <> fi-cod-estabel OR
                          num-serie-rast.serie       <> fi-serie       OR
                          num-serie-rast.nr-nota-fis <> fi-nr-nota-fis),
                    FIRST nota-fiscal NO-LOCK
                    WHERE nota-fiscal.cod-estabel = num-serie-rast.cod-estabel
                    AND   nota-fiscal.serie       = num-serie-rast.serie      
                    AND   nota-fiscal.nr-nota-fis = num-serie-rast.nr-nota-fis
                    AND   nota-fiscal.dt-cancela  = ?
                    AND   nota-fiscal.dt-saida    = ?:
                    
                    CREATE tt-erro.
                    ASSIGN tt-erro.erro = "N£mero de SÇrie j† vinculado a outra Nota Fiscal: ":U + STRING(nota-fiscal.nr-nota-fis) + " Volume: " + string(num-serie-rast.nr-volume) + ".":U + CHR(10) + "Utilize outro N£mero de SÇrie.":U
                           tt-erro.pergunta = NO.
                        
                    RETURN "NOK":U.

                END. /* FOR FIRST num-serie-rast NO-LOCK */

                ASSIGN i_conta_registros = i_conta_registros + 1.
            END. /* FOR EACH  bcaixa-ns-volume NO-LOCK */

            IF  i_conta_registros > (fi-qtd - fi-qtd-col) THEN DO:

                CREATE tt-erro.
                ASSIGN tt-erro.erro = "Quantidade da caixa excede a solicitada. Fazer a coleta por produto."
                       tt-erro.pergunta = NO.
                
                RETURN "NOK":U.

            END. /* IF  i_conta_registros > ... */
        END.
        WHEN "EPA":U    THEN DO:
            IF  NOT CAN-FIND(FIRST bpallet-ns-volume
                             WHERE bpallet-ns-volume.volume-pai = fi-ean13) THEN DO:

                CREATE tt-erro.
                ASSIGN tt-erro.erro = "Etiqueta de pallet n∆o relacionada a caixa alguma."
                       tt-erro.pergunta = NO.
                
                RETURN "NOK":U.

            END. /* IF  NOT CAN-FIND(FIRST bpallet-ns-volume */

            FIND FIRST bpallet-ns-volume NO-LOCK
                 WHERE bpallet-ns-volume.volume-pai = fi-ean13 NO-ERROR.
            IF  AVAIL  bpallet-ns-volume THEN DO:
                FIND FIRST bpallet-ns-volume2 NO-LOCK
                    WHERE  bpallet-ns-volume2.volume-pai = bpallet-ns-volume.volume-filho NO-ERROR.
                IF  AVAIL  bpallet-ns-volume2 THEN DO:
                    FIND FIRST num-serie NO-LOCK
                        WHERE  num-serie.n-serie = bpallet-ns-volume2.volume-filho NO-ERROR.
                    IF  AVAIL  num-serie 
                    AND num-serie.it-codigo <> fi-it-codigo THEN DO:

                        CREATE tt-erro.
                        ASSIGN tt-erro.erro = "Item coletado diferente do solicitado.":U + CHR(10) + "O item a ser coletado Ç o ":U + trim(string(fi-it-codigo))
                               tt-erro.pergunta = NO.
                        
                        RETURN "NOK":U.

                    END. /* IF  AVAIL num-serie ... */
                END. /* IF  AVAIL  bpallet-ns-volume2 THEN DO: */
            END. /* IF  AVAIL  bpallet-ns-volume THEN DO: */

            ASSIGN i_conta_registros = 0.
            FOR EACH  bpallet-ns-volume NO-LOCK
                WHERE bpallet-ns-volume.volume-pai = fi-ean13,
                EACH  bpallet-ns-volume2 NO-LOCK
                WHERE bpallet-ns-volume2.volume-pai = bpallet-ns-volume.volume-filho:

                IF CAN-FIND (FIRST num-serie-rast
                             WHERE num-serie-rast.cod-estabel = fi-cod-estabel
                             AND   num-serie-rast.serie       = fi-serie 
                             AND   num-serie-rast.nr-nota-fis = fi-nr-nota-fis
                             AND   num-serie-rast.n-serie     = bpallet-ns-volume2.volume-filho ) THEN DO:

                    CREATE tt-erro.
                    ASSIGN tt-erro.erro = "N£mero de SÇrie j† vinculado a esta Nota Fiscal.":U
                           tt-erro.pergunta = NO.
                        
                    RETURN "NOK":U.

                END.

                /**/

                FOR EACH num-serie-rast NO-LOCK
                    WHERE num-serie-rast.n-serie      = bpallet-ns-volume2.volume-filho AND
                         (num-serie-rast.cod-estabel <> fi-cod-estabel OR
                          num-serie-rast.serie       <> fi-serie       OR
                          num-serie-rast.nr-nota-fis <> fi-nr-nota-fis),
                    FIRST nota-fiscal NO-LOCK
                    WHERE nota-fiscal.cod-estabel = num-serie-rast.cod-estabel
                    AND   nota-fiscal.serie       = num-serie-rast.serie      
                    AND   nota-fiscal.nr-nota-fis = num-serie-rast.nr-nota-fis
                    AND   nota-fiscal.dt-cancela  = ?
                    AND   nota-fiscal.dt-saida    = ?:
                    
                    CREATE tt-erro.
                    ASSIGN tt-erro.erro = "N£mero de SÇrie j† vinculado a outra Nota Fiscal: ":U + STRING(nota-fiscal.nr-nota-fis) + " Volume: " + string(num-serie-rast.nr-volume) + ".":U + CHR(10) + "Utilize outro N£mero de SÇrie.":U
                           tt-erro.pergunta = NO.
                        
                    RETURN "NOK":U.

                END. /* FOR FIRST num-serie-rast NO-LOCK */


                ASSIGN i_conta_registros = i_conta_registros + 1.

            END. /* FOR EACH  bpallet-ns-volume NO-LOCK */

            IF  i_conta_registros > (fi-qtd - fi-qtd-col) THEN DO:

                CREATE tt-erro.
                ASSIGN tt-erro.erro = "Quantidade do pallet excede a solicitada. Fazer a coleta por produto ou caixa."
                       tt-erro.pergunta = NO.

                RETURN "NOK":U.

            END. /* IF  i_conta_registros > ... */
        END.
        WHEN "Demais":U THEN DO:



            /*-[ EAN13 ]-*/
            FIND FIRST item-mat NO-LOCK WHERE item-mat.cod-ean = fi-ean13 NO-ERROR.

            IF  NOT AVAIL item-mat THEN DO:
                /*-[ DUN14 ]-*/
                FIND FIRST item-dun NO-LOCK WHERE item-dun.cod-dun = fi-ean13 NO-ERROR.

                IF  NOT AVAIL item-dun THEN DO:
                    /*-[ N£mero de SÇrie ]-*/
                    FIND FIRST num-serie NO-LOCK WHERE num-serie.n-serie = fi-ean13 NO-ERROR.

                    IF  NOT AVAIL num-serie THEN DO:

                        CREATE tt-erro.
                        ASSIGN tt-erro.erro = "Item coletado n∆o cadastrado."
                               tt-erro.pergunta = NO.

                        RETURN "NOK":U.

                    END. /* IF  NOT AVAIL num-serie THEN */
                    ELSE DO:

                        IF  fi-it-codigo <> "" AND fi-it-codigo <> num-serie.it-codigo THEN DO:

                            CREATE tt-erro.
                            ASSIGN tt-erro.erro = "Item coletado diferente do solicitado.":U + CHR(10) + "O item a ser coletado Ç o ":U + trim(string(fi-it-codigo))
                                   tt-erro.pergunta = NO.
                                
                            RETURN "NOK":U.

                        END.

                        IF  NOT l-nota-exportacao AND NOT f-item-rastr(num-serie.it-codigo) THEN DO:

                            CREATE tt-erro.
                            ASSIGN tt-erro.erro = "Item coletado n∆o Ç de rastreabilidade.":U + CHR(10) + "Ler o c¢digo EAN13 ou DUN14.":U
                                   tt-erro.pergunta = NO.
                            
                            RETURN "NOK":U.

                        END. /* IF  NOT f-item-rastr(num-serie.it-codigo) */

                        FIND FIRST volume-nf NO-LOCK 
                            WHERE  volume-nf.cod-estabel = fi-cod-estabel
                            AND    volume-nf.serie       = fi-serie
                            AND    volume-nf.nr-nota-fis = fi-nr-nota-fis
                            AND    volume-nf.nr-volume   = fi-nr-volume
                            AND    volume-nf.it-codigo   = num-serie.it-codigo NO-ERROR.
                        IF  NOT AVAIL volume-nf THEN DO:

                            CREATE tt-erro.
                            ASSIGN tt-erro.erro = "Item n∆o pode ser coletado.":U + CHR(10) + "Item n∆o pertence a este Volume.":U
                                   tt-erro.pergunta = NO.
                            
                            RETURN "NOK":U.

                        END. /* IF  NOT AVAIL volume-nf */
                        ELSE DO:

                            IF  volume-nf.qtde-col >= volume-nf.qtde THEN DO:

                                CREATE tt-erro. 
                                ASSIGN tt-erro.erro = "Item n∆o pode ser coletado":U + CHR(10) + "Quantidade do item (Nr. SÇrie: ":U + num-serie.n-serie + ") n∆o confere com a quantidade do Volume.":U
                                       tt-erro.pergunta = NO.
                                
                                RETURN "NOK":U.

                            END. /* IF  volume-nf.qtde-col >= volume-nf.qtde */

                            IF CAN-FIND (FIRST num-serie-rast
                                         WHERE num-serie-rast.cod-estabel = fi-cod-estabel 
                                         AND   num-serie-rast.serie       = fi-serie 
                                         AND   num-serie-rast.nr-nota-fis = fi-nr-nota-fis
                                         AND   num-serie-rast.n-serie     = num-serie.n-serie) THEN DO:

                                CREATE tt-erro.
                                ASSIGN tt-erro.erro = "N£mero de SÇrie j† vinculado a esta Nota Fiscal"
                                       tt-erro.pergunta = NO.
                                
                                RETURN "NOK":U.

                            END.

                            /**/

                            FOR EACH num-serie-rast NO-LOCK
                               WHERE num-serie-rast.n-serie      = num-serie.n-serie AND
                                    (num-serie-rast.cod-estabel <> fi-cod-estabel OR
                                     num-serie-rast.serie       <> fi-serie       OR
                                     num-serie-rast.nr-nota-fis <> fi-nr-nota-fis),
                               FIRST nota-fiscal NO-LOCK
                               WHERE nota-fiscal.cod-estabel = num-serie-rast.cod-estabel
                               AND   nota-fiscal.serie       = num-serie-rast.serie      
                               AND   nota-fiscal.nr-nota-fis = num-serie-rast.nr-nota-fis
                               AND   nota-fiscal.dt-cancela  = ?
                               AND   nota-fiscal.dt-saida    = ?:
            
                               CREATE tt-erro.
                               ASSIGN tt-erro.erro = "N£mero de SÇrie j† vinculado a outra Nota Fiscal: ":U + STRING(nota-fiscal.nr-nota-fis) + " Volume: " + string(num-serie-rast.nr-volume) + ".":U + CHR(10) + "Utilize outro N£mero de SÇrie.":U
                                      tt-erro.pergunta = NO.
            
                               RETURN "NOK":U.
            
                           END. /* FOR FIRST num-serie-rast NO-LOCK */

                        END.
                        ASSIGN c-tipo-aux = "SERIAL":U.
                    END. /* ELSE DO: */
                END. /* IF  NOT AVAIL item-dun THEN */
                ELSE DO:
                    IF  fi-it-codigo <> "" AND fi-it-codigo <> item-dun.it-codigo THEN DO:

                        CREATE tt-erro.
                        ASSIGN tt-erro.erro = "Item coletado diferente do solicitado.":U + CHR(10) + "O item a ser coletado Ç o ":U + trim(string(fi-it-codigo))
                               tt-erro.pergunta = NO.
                        
                        RETURN "NOK":U.

                    END.
        
                    IF  l-nota-exportacao THEN DO:

                        CREATE tt-erro.
                        ASSIGN tt-erro.erro = "Nota Fiscal de Exportaá∆o":U + CHR(10) + "Ler o n£mero de sÇrie dos itens desta nota":U
                               tt-erro.pergunta = NO.
                        
                        RETURN "NOK":U.

                    END. /* IF  l-nota-exportacao THEN */

                    ASSIGN c-tipo-aux = "DUN14":U.
                END. /* ELSE DO: */
            END. /* IF  NOT AVAIL item-ean THEN */
            ELSE DO:
                IF  fi-it-codigo <> "" AND fi-it-codigo <> item-mat.it-codigo THEN DO:

                    CREATE tt-erro.
                    ASSIGN tt-erro.erro = "Item coletado diferente do solicitado.":U + CHR(10) + "O item a ser coletado Ç o ":U + trim(string(fi-it-codigo))
                           tt-erro.pergunta = NO.
                    
                    RETURN "NOK":U.

                END.
        
                IF  l-nota-exportacao THEN DO:
                    
                    CREATE tt-erro.
                    ASSIGN tt-erro.erro = "Nota Fiscal de Exportaá∆o":U + CHR(10) + "Ler o n£mero de sÇrie dos itens desta nota":U
                           tt-erro.pergunta = NO.
                    
                    RETURN "NOK":U.
                END. /* IF  l-nota-exportacao THEN */

                ASSIGN c-tipo-aux = "EAN13":U.
            END. /* ELSE DO: */
            
            IF  c-tipo-aux <> "SERIAL":U THEN DO:
                IF  f-item-rastr(fi-it-codigo) THEN DO:

                    CREATE tt-erro.
                    ASSIGN tt-erro.erro = "Item com rastreabilidade.":U + CHR(10) + "Ler o n£mero de sÇrie para este item.":U
                           tt-erro.pergunta = NO.
                    
                    RETURN "NOK":U.
                END. /* IF  f-item-rastr(item-ean.it-codigo) */
            
                FIND FIRST ITEM NO-LOCK WHERE ITEM.it-codigo = fi-it-codigo NO-ERROR.
                IF  AVAIL ITEM THEN DO:
                    ASSIGN fi-it-codigo = ITEM.it-codigo.
                END. /* IF  AVAIL ITEM THEN DO: */
                
                FIND FIRST volume-nf NO-LOCK                     
                    WHERE  volume-nf.cod-estabel = fi-cod-estabel       
                    AND    volume-nf.serie       = fi-serie             
                    AND    volume-nf.nr-nota-fis = fi-nr-nota-fis       
                    AND    volume-nf.nr-volume   = fi-nr-volume         
                    AND    volume-nf.it-codigo   = fi-it-codigo NO-ERROR. 

                IF  NOT AVAIL volume-nf THEN DO:

                    CREATE tt-erro.
                    ASSIGN tt-erro.erro = "Item n∆o pode ser coletado.":U + CHR(10) + "Item n∆o pertence a este Volume.":U
                           tt-erro.pergunta = NO.
                    
                    RETURN "NOK":U.

                END. /* IF  NOT AVAIL volume-nf */
            
                IF  volume-nf.qtde-col >= volume-nf.qtde THEN DO:

                    CREATE tt-erro.
                    ASSIGN tt-erro.erro = "Item n∆o pode ser coletado":U + CHR(10) + "Quantidade do item j† esta completa para este Volume.":U
                           tt-erro.pergunta = NO.
                    
                    RETURN "NOK":U.

                END. /* IF  volume-nf.qtde-col >= volume-nf.qtde */
                
                IF  c-tipo-aux = "DUN14":U THEN DO:
                    FIND FIRST bitem-dun NO-LOCK
                        WHERE  bitem-dun.cod-dun = fi-ean13 NO-ERROR.
                    IF  AVAIL  bitem-dun THEN DO:
                        IF  bitem-dun.qtd-emb > (fi-qtd - fi-qtd-col) THEN DO:

                            CREATE tt-erro.
                            ASSIGN tt-erro.erro = "Item n∆o pode ser coletado":U + CHR(10) + "Quantidade do item difere para este Volume.":U
                                   tt-erro.pergunta = NO.
                            
                            RETURN "NOK":U.
                        END.
                    END.
                END. /* IF  c-tipo-aux = "DUN14":U THEN DO: */
            END. /* IF  c-tipo-aux <> "SERIAL":U THEN */
        END.
    END CASE.

    RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF





FUNCTION f-item-rastr RETURNS LOGICAL
  ( INPUT p-it-codigo AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    FOR FIRST item-rast FIELDS(it-codigo data-ini data-fim) NO-LOCK 
        WHERE item-rast.it-codigo  = p-it-codigo
        AND   item-rast.data-ini  <= TODAY
        AND   item-rast.data-fim   > TODAY:

        RETURN TRUE.

    END.


    RETURN FALSE.   /* Function return value. */

END FUNCTION.

FUNCTION fnDescItem RETURNS CHARACTER
  ( c-it-codigo AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    FIND FIRST ITEM NO-LOCK
        WHERE  ITEM.it-codigo = c-it-codigo NO-ERROR.
    IF  AVAIL ITEM 
    THEN RETURN ITEM.desc-item.
    ELSE RETURN "".

END FUNCTION.

