/*******************************************************************************
** Copyright GATI LTDA (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da GATI SA, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

{include/i-prgvrs.i nome_upc 2.00.00.000}  /*** 010000 ***/
{include/i-epc200.i1}
{cdp/cdcfgmat.i}

/***************** Defini¯Êo de Parametros ************************************/
DEF INPUT PARAM p-ind-event      AS CHAR          NO-UNDO.
DEF INPUT PARAM p-ind-object     AS CHAR          NO-UNDO.
DEF INPUT PARAM p-wgh-object     AS HANDLE        NO-UNDO.
DEF INPUT PARAM p-wgh-frame      AS WIDGET-HANDLE NO-UNDO.
DEF INPUT PARAM p-cod-table      AS CHAR          NO-UNDO.
DEF INPUT PARAM p-row-table      AS ROWID         NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE wgh-obj             AS HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wgh-nro-docto       AS HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wgh-nat-operacao    AS HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wgh-fi-nat-operacao AS HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wgh-cod-emitente    AS HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wgh-serie-docto     AS HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wgh-dt-trans        AS HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wgh-cb-tipo-nota    AS HANDLE NO-UNDO.


IF p-ind-event = "AFTER-INITIALIZE" THEN DO:

    ASSIGN wgh-obj = p-wgh-frame:FIRST-CHILD.
    DO WHILE VALID-HANDLE(wgh-obj):              
        
        IF wgh-obj:NAME = "nro-docto" THEN DO:
            ASSIGN wgh-nro-docto = wgh-obj.            
        END.

        IF wgh-obj:NAME = "nat-operacao" THEN DO:
           ASSIGN wgh-nat-operacao = wgh-obj.           
        END.

        IF wgh-obj:NAME = "fi-nat-operacao" THEN DO:
           ASSIGN wgh-fi-nat-operacao = wgh-obj.           
        END.
        
        IF wgh-obj:NAME = "cod-emitente" THEN DO:
           ASSIGN wgh-cod-emitente = wgh-obj.           
        END.
        
        IF wgh-obj:NAME = "serie-docto" THEN DO:
           ASSIGN wgh-serie-docto = wgh-obj.           
        END.

        
        IF wgh-obj:NAME = "dt-trans" THEN DO:
           ASSIGN wgh-dt-trans = wgh-obj.           
        END.
        
        IF wgh-obj:NAME = "cb-tipo-nota" THEN DO:
           ASSIGN wgh-cb-tipo-nota = wgh-obj.           
        END.

        
        IF wgh-obj:TYPE = "field-group" THEN
            ASSIGN wgh-obj = wgh-obj:FIRST-CHILD.
        ELSE 
            ASSIGN wgh-obj = wgh-obj:NEXT-SIBLING.
    END.

    ON 'LEAVE':U OF wgh-nro-docto PERSISTENT RUN gtupc/re2001z-upc.p (INPUT "on-leave-nro-docto" ,
                                                                      INPUT p-ind-object         ,
                                                                      INPUT p-wgh-object         ,
                                                                      INPUT p-wgh-frame          ,
                                                                      INPUT p-cod-table          ,
                                                                      INPUT p-row-table          ).    
END.

IF p-ind-event = "on-leave-nro-docto" THEN DO:

    FIND FIRST gt-it-docum-est NO-LOCK
         WHERE gt-it-docum-est.nro-docto = wgh-nro-docto:SCREEN-VALUE NO-ERROR.

    IF AVAIL gt-it-docum-est THEN
        ASSIGN wgh-nat-operacao:SCREEN-VALUE = gt-it-docum-est.nat-operacao.
    ELSE 
        ASSIGN wgh-nat-operacao:SCREEN-VALUE = "".
    /*
    FIND FIRST doc-fisico NO-LOCK
         WHERE doc-fisico.serie-docto  = wgh-serie-docto :SCREEN-VALUE
           AND doc-fisico.nro-docto    = wgh-nro-docto   :SCREEN-VALUE
           AND doc-fisico.cod-emitente = INT(wgh-cod-emitente:SCREEN-VALUE) NO-ERROR.

    IF AVAIL doc-fisico THEN DO:
        ASSIGN wgh-dt-trans:SCREEN-VALUE = STRING(doc-fisico.dt-trans).
    END.
    APPLY "LEAVE" TO wgh-nro-docto IN FRAME fpage.  */


    DEF VAR i-tipo-nota AS INT    NO-UNDO.
    DEF VAR dt-trans    AS DATE   NO-UNDO.
    DEF VAR h-boin090   AS HANDLE NO-UNDO.
    DEF VAR h-boin847   AS HANDLE NO-UNDO.
    DEF VAR de-nota     AS DEC    NO-UNDO.
    DEF VAR c-nat-oper  AS CHAR   NO-UNDO.
    

    RUN inbo/boin090.p PERSISTENT SET h-boin090.

    run getTipoNotaDtTrans in h-boin090 ( input INT(wgh-cod-emitente:SCREEN-VALUE),
                                          input wgh-serie-docto  :SCREEN-VALUE,
                                          input left-trim(string(dec(wgh-nro-docto   :SCREEN-VALUE),"9999999")),
                                          output i-tipo-nota,
                                          output dt-trans   ).

    ASSIGN h-boin090 = ?.
    assign wgh-dt-trans:SCREEN-VALUE = string(dt-trans).

    if  i-tipo-nota <> 0 then 
        assign wgh-cb-tipo-nota:SCREEN-VALUE = {ininc/i01in089.i 04 i-tipo-nota}.

    if LENGTH(wgh-nro-docto:SCREEN-VALUE) > LENGTH("9999999") then do:
          /*{include/i-vldprg.i} */
          run utp/ut-msgs.p (input "show":U, 
                             input 36151, 
                             input length("9999999")).
          APPLY "entry":U to wgh-nro-docto.
          return "NOK":U.
    end. 

    assign wgh-nro-docto:screen-value = LEFT-TRIM(string(dec(wgh-nro-docto:SCREEN-VALUE),"9999999")).

    ASSIGN de-nota = DEC(wgh-nro-docto:SCREEN-VALUE) NO-ERROR.
    if (ERROR-STATUS:ERROR 
        OR (ERROR-STATUS:GET-NUMBER(1) = 76
        AND ERROR-STATUS:NUM-MESSAGES  <> 0))then do:
        RUN utp/ut-msgs.p (input "show":U, 
                           input 972,
                           input "").
        APPLY "entry":U TO wgh-nro-docto.
       return 'NOK':U.
    end.

    IF  int(wgh-cod-emitente:SCREEN-VALUE) <> 0 
    AND wgh-serie-docto:SCREEN-VALUE <> "" 
    AND wgh-nro-docto:SCREEN-VALUE <> "" THEN DO:

        RUN inbo/boin847.p PERSISTENT SET h-boin847.
        /* Verifica se o documento em quest’o existe no Conversor de NF-e, caso exista, sugere a natureza de opera»’o deste documento*/
        RUN retornaNatOperConversor IN h-boin847(INPUT wgh-cod-emitente:SCREEN-VALUE,
                                                 INPUT wgh-serie-docto:SCREEN-VALUE,
                                                 INPUT wgh-nro-docto:SCREEN-VALUE ,
                                                 OUTPUT c-nat-oper). 
        ASSIGN h-boin847 = ?.
        IF RETURN-VALUE = "OK":U THEN DO:
            ASSIGN wgh-nat-operacao:SCREEN-VALUE = c-nat-oper.
            APPLY "LEAVE":U TO wgh-nat-operacao.
        END.
        ELSE 
            ASSIGN wgh-nat-operacao:SCREEN-VALUE    = "":U
                   wgh-fi-nat-operacao:screen-value = "":U.

    END.

END.
