/********************************************************************************
 ** UPC........: wdi157.p - UPC TRIGGER WRITE PED-REPRE
 ** Data.......: Dezembro / 2004
 ** Objetivo...: Altera o valor da comiss∆o do representante conforme tabela
                 espec°fica do Magnus
 ** Autor......: Robson Jeorge Moser Gestech
 ** Vers∆o.....: 001                 
 ********************************************************************************/

DEF PARAM BUFFER b-ped-repre      FOR ped-repre.
DEF PARAM BUFFER b-old-ped-repre  FOR ped-repre.

DEF NEW GLOBAL SHARED VAR vProgOrigemPD4000 AS LOGICAL       NO-UNDO.

DEF VAR d-perc-comis    AS DECIMAL NO-UNDO.
DEF VAR v-log-inclusao  AS LOGICAL NO-UNDO INITIAL NO.
DEF VAR v-log-alteracao AS LOGICAL NO-UNDO INITIAL NO.

DEF NEW GLOBAL SHARED VAR whFinome-abrev   AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR whFidt-implant   AS WIDGET-HANDLE NO-UNDO.


DEF NEW GLOBAL SHARED VAR whbtAddRepresentative     AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR whbtAddRepresentative-new AS WIDGET-HANDLE NO-UNDO.
DEF VAR h-boes396                                   AS HANDLE.
DEFINE VARIABLE de-perc-comissao                    AS DECIMAL     NO-UNDO.
 
IF vProgOrigemPD4000 THEN DO:
    

    IF b-ped-repre.nome-ab-rep <> ""    AND 
       b-old-ped-repre.nome-ab-rep = "" THEN DO:
        ASSIGN v-log-inclusao = YES.
    END.

    IF b-ped-repre.nome-ab-rep <> ""     AND 
       b-old-ped-repre.nome-ab-rep <> "" THEN DO:
        ASSIGN v-log-alteracao = YES.
    END.

    RUN esbo/boes396.p PERSISTENT SET h-boes396.
    IF v-log-inclusao THEN DO:
        FOR FIRST repres NO-LOCK
            WHERE repres.nome-abrev = b-ped-repre.nome-ab-rep:
            FIND FIRST emitente NO-LOCK
                WHERE emitente.nome-abrev = whFinome-abrev:SCREEN-VALUE NO-ERROR.
            IF AVAIL emitente THEN DO:
               FIND FIRST gr-cli NO-LOCK
                   WHERE gr-cli.cod-gr-cli = emitente.cod-gr-cli NO-ERROR. 
               IF AVAIL gr-cli THEN DO:
                   FIND ped-venda 
                        WHERE ped-venda.nr-pedido = b-ped-repre.nr-pedido NO-LOCK NO-ERROR.
                    
                   /*N∆o calcula comissao para exportaá∆o*/
                   IF ped-venda.mo-codigo = 0 THEN DO:
                       RUN getComissao IN h-boes396    (INPUT ped-venda.cod-estabel,
                                                        INPUT repres.cod-rep,
                                                        INPUT emitente.cod-emitente,
                                                        INPUT "",
                                                        INPUT ped-venda.dt-implant,
                                                        OUTPUT de-perc-comissao) NO-ERROR.
    
                      IF de-perc-comissao > 0 THEN DO:
                          ASSIGN b-ped-repre.perc-comis = de-perc-comissao.
                          
                      END.
                      ELSE DO:
                          RUN getComissao IN h-boes396    (INPUT ped-venda.cod-estabel,
                                                           INPUT repres.cod-rep,
                                                           INPUT ?,
                                                           INPUT "",
                                                           INPUT ped-venda.dt-implant,
                                                           OUTPUT de-perc-comissao) NO-ERROR.
                          ASSIGN b-ped-repre.perc-comis = de-perc-comissao.
                      END.
                   END.
               END.
            END.
        END.
    END.
    DELETE PROCEDURE h-boes396.
    IF v-log-alteracao AND AVAIL b-ped-repre THEN
       ASSIGN b-ped-repre.perc-comis = b-ped-repre.perc-comis.

    RETURN "OK".
END.
