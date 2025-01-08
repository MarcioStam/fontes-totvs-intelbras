/***********************************************************************
**  Programa..: upc\re1001b1-upci.p
**  Autor.....: Anderson Silvano  - Gestech
**  Data......: JUNHO/2005 - Desenvolvimento
**  Descricao.: Leave da parcela
**  VersÆo....: 001 - 00/00/2002
**                  Desenvolvimento Programa
************************************************************************/

DEF NEW GLOBAL SHARED VAR wh-numero-ordem   AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-qt-do-forn     AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-preco-unit     AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-parcela        AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-ord-produ      AS WIDGET-HANDLE NO-UNDO.

DEF NEW GLOBAL SHARED VAR gr-docum-est    AS ROWID         NO-UNDO.

FIND FIRST docum-est NO-LOCK
    WHERE ROWID(docum-est) = gr-docum-est NO-ERROR.

FOR FIRST ordem-compra NO-LOCK
    WHERE ordem-compra.numero-ordem = INT(wh-numero-ordem:SCREEN-VALUE),
    FIRST prazo-compra NO-LOCK
    WHERE prazo-compra.numero-ordem = ordem-compra.numero-ordem
    AND   prazo-compra.parcela      = INT(wh-parcela:SCREEN-VALUE):
    ASSIGN wh-parcela:SCREEN-VALUE    = STRING(prazo-compra.parcela)
           wh-qt-do-forn:SCREEN-VALUE = STRING(prazo-compra.qtd-sal-forn,">>>>,>>>,>>9.9999").

    IF ordem-compra.mo-codigo <> 0 THEN DO:
        FIND FIRST cotacao NO-LOCK
            WHERE cotacao.mo-codigo   = ordem-compra.mo-codigo
            AND   cotacao.ano-periodo = STRING(YEAR(docum-est.dt-emissao),"9999") + "/" + STRING(MONTH(docum-est.dt-emissao),"99") NO-ERROR.
        IF AVAIL cotacao THEN                          
            ASSIGN wh-preco-unit:SCREEN-VALUE = STRING(ordem-compra.pre-unit-for * cotacao.cotacao[DAY(docum-est.dt-emissao)]).
        ELSE
            ASSIGN wh-preco-unit:SCREEN-VALUE = STRING(ordem-compra.pre-unit-for).
    END.
    ELSE
        ASSIGN wh-preco-unit:SCREEN-VALUE = STRING(ordem-compra.pre-unit-for).
END.


