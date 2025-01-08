/*******************************************************************************
** Copyright GATI LTDA (2015)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da GATI SA, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
**
** Objetivo: Vinculo automatico da nota fiscal de saida para devolu‡Æo
*******************************************************************************/

{include/i-prgvrs.i re1001e-upc 2.00.00.000}  /*** 010000 ***/
{include/i-epc200.i1}
{cdp/cdcfgmat.i}
{gtp/gati0000.i}

/***************** Defini¯Êo de Parametros ************************************/
DEF INPUT PARAM p-ind-event      AS CHAR          NO-UNDO.
DEF INPUT PARAM p-ind-object     AS CHAR          NO-UNDO.
DEF INPUT PARAM p-wgh-object     AS HANDLE        NO-UNDO.
DEF INPUT PARAM p-wgh-frame      AS WIDGET-HANDLE NO-UNDO.
DEF INPUT PARAM p-cod-table      AS CHAR          NO-UNDO.
DEF INPUT PARAM p-row-table      AS ROWID         NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE wgh-object      AS HANDLE        NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wgh-serie       AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wgh-nr-nota-fis AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE g-chave-acesso  AS CHARACTER     NO-UNDO.
&IF '{&pre-empresa}' = "parati" &THEN
DEF NEW GLOBAL SHARED VAR g-n-itens-dev  AS INTEGER                NO-UNDO.
DEF VARIABLE              i-cont-itens   AS INTEGER                NO-UNDO.
&ENDIF

/* Evento ap¢s componentes criados em tela */
IF p-ind-event = "AFTER-INITIALIZE" THEN DO:
    
    /* pega primeiro objeto da tela */
    ASSIGN wgh-object = p-wgh-frame:FIRST-CHILD.

    /* a partir deste objeto, varre todos os outros */
    DO WHILE VALID-HANDLE(wgh-object):

        /*  caso o objeto da tela seja o Browse que queremos manipular, 
        seta em uma var separada para manipula‡Æo */
       
        IF wgh-object:NAME = "serie" THEN DO:
            ASSIGN wgh-serie = wgh-object.
        END.

        IF wgh-object:NAME = "nr-nota-fis" THEN DO:
            ASSIGN wgh-nr-nota-fis = wgh-object.
        END.

        /* se o objeto for um container, varre todos os itens do container tamb‚m 
        caso contrario, passa para o proximo objeto da tela */
        IF wgh-object:TYPE = "field-group" THEN
            ASSIGN wgh-object = wgh-object:FIRST-CHILD.
        ELSE 
            ASSIGN wgh-object = wgh-object:NEXT-SIBLING.
    END.

    FOR FIRST gt-refer-docto NO-LOCK
        WHERE gt-refer-docto.chave-entrada = g-chave-acesso /* atribuida antes da chamada RE1001E no GATI0102*/:

        FIND FIRST nota-fiscal NO-LOCK
             WHERE nota-fiscal.cod-estabel = gt-refer-docto.cod-estabel
               AND nota-fiscal.serie       = SUBSTR(gt-refer-docto.chave-saida,23,3)
               AND nota-fiscal.nr-nota-fis = STRING(INT(SUBSTR(gt-refer-docto.chave-saida,26,9)),"9999999") NO-ERROR.

        IF NOT AVAIL nota-fiscal THEN
            FIND FIRST nota-fiscal NO-LOCK
                 WHERE nota-fiscal.cod-estabel = gt-refer-docto.cod-estabel
                   AND nota-fiscal.serie       = STRING(INT(SUBSTR(gt-refer-docto.chave-saida,23,3)))
                   AND nota-fiscal.nr-nota-fis = STRING(INT(SUBSTR(gt-refer-docto.chave-saida,26,9)),"9999999") NO-ERROR.
    
        IF AVAIL nota-fiscal THEN DO:
            ASSIGN wgh-serie      :SCREEN-VALUE = nota-fiscal.serie
                   wgh-nr-nota-fis:SCREEN-VALUE = nota-fiscal.nr-nota-fis.  

            
            
        END.        
    END.
END.

&IF "{&pre-empresa}" = "parati" &THEN
IF p-ind-event = "BEFORE-DESTROY-INTERFACE" THEN DO:

    FOR FIRST gt-refer-docto NO-LOCK
        WHERE gt-refer-docto.chave-entrada = g-chave-acesso /* atribuida antes da chamada RE1001E no GATI0102*/:

        FIND FIRST nota-fiscal NO-LOCK
             WHERE nota-fiscal.cod-estabel = gt-refer-docto.cod-estabel
               AND nota-fiscal.serie       = wgh-serie      :SCREEN-VALUE
               AND nota-fiscal.nr-nota-fis = wgh-nr-nota-fis:SCREEN-VALUE NO-ERROR.

        IF AVAIL nota-fiscal THEN DO:
            FOR EACH it-nota-fisc OF nota-fiscal NO-LOCK:
                ASSIGN i-cont-itens = i-cont-itens + 1.
            END.
            
            IF g-n-itens-dev <> i-cont-itens THEN
                MESSAGE "O numero de itens da nota fiscal recebida ‚ divergˆnte do numero de itens da nota fiscal de saida vinculada!"
                    VIEW-AS ALERT-BOX WARNING BUTTONS OK.
    
        END.
    END.
END.
&ENDIF
