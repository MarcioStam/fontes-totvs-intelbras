/*****************************************************************************
** Programa: upc/ft4004b-upc.p
** Vers∆o..: 1.00
** Data....: 09/02/2012
** Autor...: Estevan KrÅger - Exponencial TI
** Obs.....: Programa UPC para a tela de Inclus∆o de Item (FT4004B)
*****************************************************************************/


/*--- Definiá∆o dos ParÉmetros ---*/
DEFINE INPUT PARAMETER p-ind-event    AS CHARACTER          NO-UNDO.
DEFINE INPUT PARAMETER p-ind-object   AS CHARACTER          NO-UNDO.
DEFINE INPUT PARAMETER p-wgh-object   AS HANDLE             NO-UNDO.
DEFINE INPUT PARAMETER p-wgh-frame    AS WIDGET-HANDLE      NO-UNDO.
DEFINE INPUT PARAMETER p-cod-table    AS CHARACTER          NO-UNDO.
DEFINE INPUT PARAMETER p-row-table    AS ROWID              NO-UNDO.



/*--- Definiá∆o das Vari†veis Globais ---*/
DEFINE NEW GLOBAL SHARED VARIABLE h-ft4004b-upc            AS HANDLE         NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-seq-wt-docto-ft4003   AS WIDGET-HANDLE  NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-it-codigo-ft4004b     AS WIDGET-HANDLE  NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-new-it-codigo-ft4004b AS WIDGET-HANDLE  NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-vl-preori-ped-ft4004b AS WIDGET-HANDLE  NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-quantidade-1-ft4004b  AS WIDGET-HANDLE  NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-btOk-ft4004b          AS WIDGET-HANDLE  NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-new-btOk-ft4004b      AS WIDGET-HANDLE  NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-nat-operacao-ft4004b  AS WIDGET-HANDLE  NO-UNDO.


/*--- Definiá∆o das Vari†velis Locais ---*/
DEFINE VARIABLE c-objeto AS CHARACTER   NO-UNDO.



/*--- Definiá∆o das Funá‰es ---*/
FUNCTION getObject RETURNS HANDLE (pFrame AS HANDLE, pObj AS CHAR).
    DEFINE VARIABLE hHdl AS HANDLE NO-UNDO.

    ASSIGN hHdl = pFrame:FIRST-CHILD
           hHdl = hHdl:FIRST-CHILD.

    DO WHILE VALID-HANDLE(hHdl):
        IF hHdl:NAME = pObj THEN LEAVE.

        hHdl = hHdl:NEXT-SIBLING.
    END.

    RETURN IF  VALID-HANDLE(hHdl) THEN hHdl ELSE ?.
END FUNCTION.



/*--- Bloco Principal ---*/
ASSIGN c-objeto = ENTRY(NUM-ENTRIES(p-wgh-object:FILE-NAME, "~/"), p-wgh-object:FILE-NAME, "~/").


IF  p-ind-event = "AFTER-INITIALIZE":U THEN DO:
    IF  NOT VALID-HANDLE(h-ft4004b-upc) THEN
        RUN upc/ft4004b-upc.p PERSISTENT SET h-ft4004b-upc (INPUT "",
                                                            INPUT "",
                                                            INPUT p-wgh-object,
                                                            INPUT p-wgh-frame,
                                                            INPUT "",
                                                            INPUT p-row-table).

    ASSIGN wh-it-codigo-ft4004b     = getObject(p-wgh-frame, "it-codigo")
           wh-vl-preori-ped-ft4004b = getObject(p-wgh-frame, "vl-preori-ped")
           wh-quantidade-1-ft4004b  = getObject(p-wgh-frame, "quantidade-1").
           wh-btOk-ft4004b          = getObject(p-wgh-frame, "btOk").
           wh-nat-operacao-ft4004b  = getObject(p-wgh-frame, "nat-operacao").
           
    CREATE BUTTON wh-new-btOk-ft4004b
    ASSIGN FRAME       = wh-btOk-ft4004b:FRAME
           WIDTH       = wh-btOk-ft4004b:WIDTH
           HEIGHT      = wh-btOk-ft4004b:HEIGHT
           LABEL       = wh-btOk-ft4004b:LABEL
           ROW         = wh-btOk-ft4004b:ROW
           COL         = wh-btOk-ft4004b:COL 
           TOOLTIP     = wh-btOk-ft4004b:TOOLTIP
           FLAT-BUTTON = wh-btOk-ft4004b:FLAT-BUTTON
           VISIBLE     = wh-btOk-ft4004b:VISIBLE
           SENSITIVE   = wh-btOk-ft4004b:SENSITIVE.
    ON "CHOOSE" OF wh-new-btOk-ft4004b PERSISTENT RUN pi-bt-ok IN h-ft4004b-upc.

    ASSIGN wh-btOk-ft4004b:SENSITIVE = NO.
    wh-new-btOk-ft4004b:MOVE-TO-TOP().

    IF  VALID-HANDLE(wh-it-codigo-ft4004b) THEN DO:
        CREATE FILL-IN wh-new-it-codigo-ft4004b
        ASSIGN FRAME             = p-wgh-frame
               NAME              = "wh-new-it-codigo-ft4004b":U
               DATA-TYPE         = wh-it-codigo-ft4004b:DATA-TYPE
               FORMAT            = wh-it-codigo-ft4004b:FORMAT
               WIDTH             = wh-it-codigo-ft4004b:WIDTH
               HEIGHT            = wh-it-codigo-ft4004b:HEIGHT
               ROW               = wh-it-codigo-ft4004b:ROW
               COL               = wh-it-codigo-ft4004b:COL
               VISIBLE           = wh-it-codigo-ft4004b:VISIBLE
               SENSITIVE         = wh-it-codigo-ft4004b:SENSITIVE.
        
        ON "LEAVE"                 OF wh-new-it-codigo-ft4004b PERSISTENT RUN pi-calcular-preco IN h-ft4004b-upc.
        IF VALID-HANDLE(wh-quantidade-1-ft4004b) THEN
            ON "LEAVE"                 OF wh-quantidade-1-ft4004b  PERSISTENT RUN pi-calcular-preco IN h-ft4004b-upc.
        ON "F5"                    OF wh-new-it-codigo-ft4004b PERSISTENT RUN pi-trata-eventos  IN h-ft4004b-upc (INPUT "F5").
        ON "F7"                    OF wh-new-it-codigo-ft4004b PERSISTENT RUN pi-trata-eventos  IN h-ft4004b-upc (INPUT "F7").
        ON "MOUSE-SELECT-DBLCLICK" OF wh-new-it-codigo-ft4004b PERSISTENT RUN pi-trata-eventos  IN h-ft4004b-upc (INPUT "MOUSE-SELECT-DBLCLICK").

        wh-new-it-codigo-ft4004b:LOAD-MOUSE-POINTER("image/lupa.cur":U).
        wh-new-it-codigo-ft4004b:MOVE-AFTER-TAB-ITEM(wh-it-codigo-ft4004b).
        ASSIGN wh-it-codigo-ft4004b:SENSITIVE = NO.

        wh-vl-preori-ped-ft4004b:FORMAT = ">>>,>>>,>>9.9999".

    END.
END.


IF  p-ind-event = "AFTER-DESTROY-INTERFACE" THEN DO:
    IF  VALID-HANDLE(h-ft4004b-upc) THEN DO:
        DELETE PROCEDURE h-ft4004b-upc.
        ASSIGN h-ft4004b-upc = ?.
    END.

    IF  VALID-HANDLE(wh-it-codigo-ft4004b) THEN
        ASSIGN wh-it-codigo-ft4004b = ?.

    IF  VALID-HANDLE(wh-vl-preori-ped-ft4004b) THEN
        ASSIGN wh-vl-preori-ped-ft4004b = ?.
END.

PROCEDURE pi-bt-ok:
    FIND FIRST natur-oper NO-LOCK
         WHERE natur-oper.nat-operacao = wh-nat-operacao-ft4004b:SCREEN-VALUE NO-ERROR.

    FIND FIRST ITEM NO-LOCK
         WHERE ITEM.it-codigo = wh-new-it-codigo-ft4004b:SCREEN-VALUE NO-ERROR.

    IF  AVAIL natur-oper 
    AND natur-oper.baixa-estoq = NO 
    AND AVAIL ITEM 
    AND ITEM.baixa-estoq = YES THEN DO:
         RUN utp/ut-msgs.p (INPUT "SHOW", 
                            INPUT 27100, 
                            INPUT "Item possui controle de estoque e a natureza informada n∆o baixa estoque. Confirma a inclus∆o desse item na nota?").

         IF RETURN-VALUE <> "YES" THEN
             RETURN "NOK".
    END.

    APPLY "CHOOSE" TO wh-btOk-ft4004b.
    
END PROCEDURE.

/*--- Procedures Internas ---*/
PROCEDURE pi-trata-eventos:
    DEFINE INPUT  PARAMETER pEvento AS CHARACTER   NO-UNDO.

    IF  VALID-HANDLE(wh-it-codigo-ft4004b)     AND
        VALID-HANDLE(wh-new-it-codigo-ft4004b) THEN DO:
        ASSIGN wh-it-codigo-ft4004b:SCREEN-VALUE = wh-new-it-codigo-ft4004b:SCREEN-VALUE.

        APPLY pEvento TO wh-it-codigo-ft4004b.

        ASSIGN wh-new-it-codigo-ft4004b:SCREEN-VALUE = wh-it-codigo-ft4004b:SCREEN-VALUE.
    END.

    RETURN "OK":U.
END PROCEDURE.


PROCEDURE pi-calcular-preco:
    DEFINE VARIABLE de-preco AS DECIMAL     NO-UNDO.
    
    IF  VALID-HANDLE(wh-seq-wt-docto-ft4003)   AND
        VALID-HANDLE(wh-it-codigo-ft4004b)     AND
        VALID-HANDLE(wh-new-it-codigo-ft4004b) THEN DO:

        ASSIGN wh-it-codigo-ft4004b:SCREEN-VALUE = wh-new-it-codigo-ft4004b:SCREEN-VALUE.
        APPLY "LEAVE" TO wh-it-codigo-ft4004b.

        FIND FIRST wt-docto NO-LOCK
            WHERE  wt-docto.seq-wt-docto = INT(wh-seq-wt-docto-ft4003:SCREEN-VALUE) NO-ERROR.
        IF  AVAIL  wt-docto THEN DO:

            FIND FIRST natur-oper NO-LOCK
                WHERE  natur-oper.nat-operacao = wt-docto.nat-operacao NO-ERROR.
            IF  NOT AVAIL natur-oper THEN
                LEAVE.

            FIND FIRST item-estab NO-LOCK
                WHERE  item-estab.it-codigo   = wh-new-it-codigo-ft4004b:SCREEN-VALUE
                AND    item-estab.cod-estabel = wt-docto.cod-estabel NO-ERROR.
            IF  AVAIL  item-estab THEN DO:
                ASSIGN de-preco = item-estab.val-unit-mat-m[1] + item-estab.val-unit-ggf-m[1] + item-estab.val-unit-mob-m[1].

                FIND FIRST emitente NO-LOCK
                    WHERE  emitente.nome-abrev = wt-docto.nome-abrev NO-ERROR.
                IF  NOT AVAIL emitente THEN
                    LEAVE.

                IF  natur-oper.transf THEN DO:
                    IF (wt-docto.cod-estabel  = "101" AND emitente.cod-emitente = 141000) OR
                       (wt-docto.cod-estabel  = "104" AND emitente.cod-emitente = 103748) THEN .
                    ELSE DO:
                        IF (wt-docto.cod-estabel  = "101" AND emitente.cod-emitente = 159767) THEN
                            ASSIGN de-preco = de-preco / 0.88.
                        IF (wt-docto.cod-estabel  = "101" AND emitente.cod-emitente = 143524) THEN
                            ASSIGN de-preco = de-preco / 0.93.
                        IF (wt-docto.cod-estabel  = "104" AND emitente.cod-emitente = 159767) THEN
                            ASSIGN de-preco = de-preco / 0.88.
                        IF (wt-docto.cod-estabel  = "104" AND emitente.cod-emitente = 143524) THEN
                            ASSIGN de-preco = de-preco / 0.93.
                        IF (wt-docto.cod-estabel  = "103" AND emitente.cod-emitente = 143524) THEN
                            ASSIGN de-preco = de-preco / 0.93.
                        IF (wt-docto.cod-estabel  = "103" AND emitente.cod-emitente = 141000) OR
                           (wt-docto.cod-estabel  = "103" AND emitente.cod-emitente = 103748) THEN
                            ASSIGN de-preco = de-preco / 0.88.
                        IF (wt-docto.cod-estabel  = "105" AND emitente.cod-emitente = 141000) OR
                           (wt-docto.cod-estabel  = "105" AND emitente.cod-emitente = 103748) OR
                           (wt-docto.cod-estabel  = "105" AND emitente.cod-emitente = 159767) THEN
                            ASSIGN de-preco = de-preco / 0.88.

        

                    END.
                END.
            END.

            IF  NOT natur-oper.transf THEN DO:
                FIND FIRST item NO-LOCK
                    WHERE  item.it-codigo = wh-new-it-codigo-ft4004b:SCREEN-VALUE NO-ERROR.
                IF  NOT AVAIL item THEN
                    LEAVE.

                IF  item.tipo-contr = 2 AND
                    item.it-codigo BEGINS "4" THEN DO:
                    FOR EACH  preco-item NO-LOCK
                        WHERE preco-item.it-codigo = item.it-codigo
                          AND preco-item.nr-tabpre = "Minimo"
                          AND preco-item.situacao  = 1
                          AND preco-item.dt-inival < TODAY,
                        FIRST tb-preco NO-LOCK
                        WHERE tb-preco.nr-tabpre  = preco-item.nr-tabpre
                          AND tb-preco.situacao   = 1
                          AND tb-preco.dt-inival <= TODAY
                          AND tb-preco.dt-fimval >= TODAY
                        BREAK BY preco-item.preco-venda:
                        ASSIGN de-preco = preco-item.preco-venda.
                        LEAVE.
                    END.
                END.
            END.

        END.

        IF  VALID-HANDLE(wh-vl-preori-ped-ft4004b) THEN 
            IF DEC(wh-vl-preori-ped-ft4004b:SCREEN-VALUE) = 0 THEN
               ASSIGN wh-vl-preori-ped-ft4004b:SCREEN-VALUE = STRING(de-preco).
        
    END.

    RETURN "OK":U.
END PROCEDURE.

