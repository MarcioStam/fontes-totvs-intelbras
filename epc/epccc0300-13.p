/* Osnir - log13178 */
/* EPC para cc0300*/
/* epccc0300-13 = epc cc0300 empresa */
/* Matria de rateio */

def input param p-ind-event      as char          no-undo.
def input param p-ind-object     as char          no-undo.
def input param p-wgh-object     as handle        no-undo.
def input param p-wgh-frame      as widget-handle no-undo.
def input param p-cod-table      as char          no-undo.
def input param p-row-table      as rowid         no-undo.

{utp/ut-glob.i}
{upc/utils.i}

DEF NEW GLOBAL SHARED VAR wh-button-upc-cc0300        AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-txt-estabel-cc0300       AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-cod-estabel-cc0300       AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-txt-ckd-cc0300           AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-cod-ckd-cc0300           AS WIDGET-HANDLE NO-UNDO.


DEF NEW GLOBAL SHARED VAR wh-txt-qtckd-cc0300         AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-qtd-ckd-cc0300           AS WIDGET-HANDLE NO-UNDO.

DEF NEW GLOBAL SHARED VAR wh-pedido-emerg             AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-tx-tipo-pedido-cc0300    AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-temp-cc0300              AS WIDGET-HANDLE NO-UNDO.

DEF NEW GLOBAL SHARED VAR c-table-upc-cc0300          AS CHAR NO-UNDO.
DEF NEW GLOBAL SHARED VAR r-son-upc-cc0300            AS ROWID NO-UNDO.

DEF NEW GLOBAL SHARED VAR h-fill-pedido              AS HANDLE NO-UNDO.
define new global shared variable iPedido-cc0300-upc as inte   no-undo.
DEFINE VARIABLE hBtPedOri                            AS HANDLE NO-UNDO.

DEFINE VARIABLE de-seq AS DECIMAL     NO-UNDO.

CASE p-ind-event:
    WHEN "BEFORE-INITIALIZE" 
    THEN DO:
        ASSIGN wh-temp-cc0300 = ?.
        RUN tela-upc (INPUT p-wgh-frame,
                      INPUT p-ind-Event,
                      INPUT "FILL-IN",          /*** Type ***/
                      INPUT "num-pedido",      /*** Name ***/
                      INPUT NO,                 /*** Apresenta Mensagem dos Objetos ***/
                      INPUT 1,                  /*** Quando existir mais de um objeto com o mesmo nome ***/
                      OUTPUT wh-temp-cc0300).
        IF VALID-HANDLE(wh-temp-cc0300) 
        THEN
            ASSIGN wh-temp-cc0300:COL = 12.5
                   wh-temp-cc0300:SIDE-LABEL-HANDLE:COL = 5.8.

        ASSIGN wh-temp-cc0300 = ?.
        RUN tela-upc (INPUT p-wgh-frame,
                      INPUT p-ind-Event,
                      INPUT "FILL-IN",          /*** Type ***/
                      INPUT "cod-emitente",      /*** Name ***/
                      INPUT NO,                 /*** Apresenta Mensagem dos Objetos ***/
                      INPUT 1,                  /*** Quando existir mais de um objeto com o mesmo nome ***/
                      OUTPUT wh-temp-cc0300).
        IF VALID-HANDLE(wh-temp-cc0300) 
        THEN
            ASSIGN wh-temp-cc0300:COL = 12.5
                   wh-temp-cc0300:SIDE-LABEL-HANDLE:COL = 3.

        ASSIGN wh-temp-cc0300 = ?.
        RUN tela-upc (INPUT p-wgh-frame,
                      INPUT p-ind-Event,
                      INPUT "FILL-IN",          /*** Type ***/
                      INPUT "c-nome-abrev",      /*** Name ***/
                      INPUT NO,                 /*** Apresenta Mensagem dos Objetos ***/
                      INPUT 1,                  /*** Quando existir mais de um objeto com o mesmo nome ***/
                      OUTPUT wh-temp-cc0300).
        IF VALID-HANDLE(wh-temp-cc0300) 
        THEN
            ASSIGN wh-temp-cc0300:COL   = 23
                   wh-temp-cc0300:WIDTH = wh-temp-cc0300:WIDTH + 2.

        ASSIGN wh-temp-cc0300 = ?.
        RUN tela-upc (INPUT p-wgh-frame,
                          INPUT p-ind-Event,
                          INPUT "combo-box",       /*** Type ***/
                          INPUT "cb-natureza",      /*** Name ***/
                          INPUT NO,            /*** Apresenta Mensagem dos Objetos ***/
                          INPUT 1,             /*** Quando existir mais de um objeto com o mesmo nome ***/
                          OUTPUT wh-temp-cc0300).
        IF VALID-HANDLE(wh-temp-cc0300) 
        THEN
            ASSIGN wh-temp-cc0300:WIDTH = 11
                   wh-temp-cc0300:COL   = 49
                   wh-temp-cc0300:ROW   = 2.75 
                   wh-temp-cc0300:SIDE-LABEL-HANDLE:COL = 41.9
                   wh-temp-cc0300:SIDE-LABEL-HANDLE:ROW = 2.7.


        ASSIGN wh-temp-cc0300 = ?.
        RUN tela-upc (INPUT p-wgh-frame,
                      INPUT p-ind-Event,
                      INPUT "FILL-IN",          /*** Type ***/
                      INPUT "data-pedido",      /*** Name ***/
                      INPUT NO,                 /*** Apresenta Mensagem dos Objetos ***/
                      INPUT 1,                  /*** Quando existir mais de um objeto com o mesmo nome ***/
                      OUTPUT wh-temp-cc0300).
        IF VALID-HANDLE(wh-temp-cc0300) 
        THEN
            ASSIGN wh-temp-cc0300:COL                   = wh-temp-cc0300:COL + 6
                   wh-temp-cc0300:SIDE-LABEL-HANDLE:COL = wh-temp-cc0300:SIDE-LABEL-HANDLE:COL + 6.

        ASSIGN wh-temp-cc0300 = ?.
        RUN tela-upc (INPUT p-wgh-frame,
                      INPUT p-ind-Event,
                      INPUT "FILL-IN",          /*** Type ***/
                      INPUT "c-cgc",      /*** Name ***/
                      INPUT NO,                 /*** Apresenta Mensagem dos Objetos ***/
                      INPUT 1,                  /*** Quando existir mais de um objeto com o mesmo nome ***/
                      OUTPUT wh-temp-cc0300).
        IF VALID-HANDLE(wh-temp-cc0300) 
        THEN
            ASSIGN wh-temp-cc0300:COL = wh-temp-cc0300:COL + 6.

        ASSIGN wh-temp-cc0300 = ?.
        RUN tela-upc (INPUT p-wgh-frame,
                      INPUT p-ind-Event,
                      INPUT "combo-box",        /*** Type ***/
                      INPUT "cb-situacao",      /*** Name ***/
                      INPUT NO,                 /*** Apresenta Mensagem dos Objetos ***/
                      INPUT 1,                  /*** Quando existir mais de um objeto com o mesmo nome ***/
                      OUTPUT wh-temp-cc0300).
        IF VALID-HANDLE(wh-temp-cc0300) 
        THEN
            ASSIGN wh-temp-cc0300:COL                   = wh-temp-cc0300:COL + 6
                   wh-temp-cc0300:SIDE-LABEL-HANDLE:COL = wh-temp-cc0300:SIDE-LABEL-HANDLE:COL + 6.

        CREATE TEXT wh-txt-estabel-cc0300
        ASSIGN FRAME        = p-wgh-frame
               FORMAT       = "x(06)"
               WIDTH        = 06
               SCREEN-VALUE = "Estab:"
               ROW          = 4.96
               COL          = 7.5
               VISIBLE      = YES.
    
        CREATE FILL-IN wh-cod-estabel-cc0300
        ASSIGN FRAME             = p-wgh-frame
               DATA-TYPE         = "CHARACTER"
               FORMAT            = "X(05)" 
               WIDTH             = 5
               HEIGHT            = .88
               ROW               = 4.83
               COL               = 12.5
               VISIBLE           = YES
               SENSITIVE         = NO.

        CREATE TEXT wh-txt-ckd-cc0300
        ASSIGN FRAME        = p-wgh-frame
               FORMAT       = "x(09)"
               WIDTH        = 09
               SCREEN-VALUE = "Prod CKD:"
               ROW          = 4.96
               COL          = 23
               VISIBLE      = YES.
    
        CREATE FILL-IN wh-cod-ckd-cc0300
        ASSIGN FRAME             = p-wgh-frame
               DATA-TYPE         = "CHARACTER"
               FORMAT            = "X(08)" 
               WIDTH             = 8
               HEIGHT            = .88
               ROW               = 4.83
               COL               = 30.5
               VISIBLE           = YES
               SENSITIVE         = NO.

        CREATE TEXT wh-txt-qtckd-cc0300
        ASSIGN FRAME        = p-wgh-frame
               FORMAT       = "x(09)"
               WIDTH        = 09
               SCREEN-VALUE = "Qtd CKD:"
               ROW          = 4.96
               COL          = 43.3
               VISIBLE      = YES.
    
        CREATE FILL-IN wh-qtd-ckd-cc0300
        ASSIGN FRAME             = p-wgh-frame
               DATA-TYPE         = "CHARACTER"
               FORMAT            = "x(12)" 
               WIDTH             = 10
               HEIGHT            = .88
               ROW               = 4.83
               COL               = 50
               VISIBLE           = YES
               SENSITIVE         = NO.

        CREATE TEXT wh-tx-tipo-pedido-cc0300
        ASSIGN FRAME        = p-wgh-frame
               FORMAT       = "x(21)"   
               WIDTH        = 15
               ROW          = 2.93
               COL          = 23
               VISIBLE      = YES.

         /*fPage1*/
        RUN tela-upc (INPUT p-wgh-frame,
                      INPUT p-ind-Event,
                      INPUT "TOGGLE-BOX",          /*** Type ***/
                      INPUT "emergencial",      /*** Name ***/
                      INPUT NO,                 /*** Apresenta Mensagem dos Objetos ***/
                      INPUT 1,                  /*** Quando existir mais de um objeto com o mesmo nome ***/
                      OUTPUT wh-pedido-emerg).
        ASSIGN wh-pedido-emerg:VISIBLE = NO.

        CREATE BUTTON hBtPedOri
        ASSIGN FRAME     = p-wgh-frame:HANDLE
               NAME      = "btPedOri"
               WIDTH     = 4
               HEIGHT    = 1.2
               COL       = 26
               ROW       = 1.15
               VISIBLE   = yes
               SENSITIVE = true
               FONT      = 1
               TOOLTIP   = "Pedido Origem/Destino".
        
        hBtPedOri:load-image-up("image/im-estru.bmp").
    
        ON 'CHOOSE':U OF hBtPedOri PERSISTENT   
            RUN epc/epccc0300-13.p (INPUT "piAbrePedOri",
                                    INPUT p-ind-object,
                                    INPUT p-wgh-object,
                                    INPUT p-wgh-frame,
                                    INPUT p-cod-table,
                                    INPUT p-row-table).

    END.
    WHEN "AFTER-INITIALIZE" THEN DO:

        FIND FIRST pedido-compr NO-LOCK
            WHERE ROWID(pedido-compr) = p-row-table NO-ERROR.

        IF AVAIL pedido-compr THEN DO:            

            /* Altera Texto do Tipo de Pedido */
            FOR FIRST int-pedido-compr WHERE
                    int-pedido-compr.num-pedido = pedido-compr.num-pedido NO-LOCK:

                 ASSIGN wh-cod-ckd-cc0300:SCREEN-VALUE = int-pedido-compr.cod-produto-ckd
                        wh-qtd-ckd-cc0300:SCREEN-VALUE = STRING(INT(int-pedido-compr.qtd-pedido-ckd),">,>>>,>>9").

                 FOR FIRST ponto-programa USE-INDEX ponto NO-LOCK
                     WHERE ponto-programa.nome-programa = "cc0300a"
                       AND ponto-programa.ponto         = 1
                       AND ponto-programa.tipo          = 3,
                      EACH conteudo-programa NO-LOCK
                     WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa
                       AND conteudo-programa.sequencia    = int-pedido-compr.tp-pedido:

                     ASSIGN de-seq = deci(ENTRY(1,conteudo-programa.conteudo,";")) NO-ERROR.                                   

                     IF de-seq <= 8 THEN               
                         ASSIGN wh-tx-tipo-pedido-cc0300:SCREEN-VALUE = CAPS("Pedido " + ENTRY(2,conteudo-programa.conteudo,";")) NO-ERROR.
                     ELSE
                         ASSIGN wh-tx-tipo-pedido-cc0300:SCREEN-VALUE = CAPS(ENTRY(2,conteudo-programa.conteudo,";")) NO-ERROR.

                     LEAVE.
                 END.
                 /*CASE int-pedido-compr.tp-pedido:
                    WHEN 1 THEN DO:
                        ASSIGN wh-tx-tipo-pedido-cc0300:SCREEN-VALUE = "PEDIDO AMOSTRA".
                    END.
                    WHEN 2 THEN DO:
                        ASSIGN wh-tx-tipo-pedido-cc0300:SCREEN-VALUE = "PEDIDO AUTOMµTICO".
                    END.
                    WHEN 3 THEN DO:
                        ASSIGN wh-tx-tipo-pedido-cc0300:SCREEN-VALUE = "PEDIDO COMUM".
                    END.
                    WHEN 4 THEN DO:
                        ASSIGN wh-tx-tipo-pedido-cc0300:SCREEN-VALUE = "PEDIDO HOMOLOGA€ÇO".
                    END.
                    WHEN 5 THEN DO:
                        ASSIGN wh-tx-tipo-pedido-cc0300:SCREEN-VALUE = "PEDIDO INDEPENDENTE".
                    END.
                    WHEN 6 THEN DO:
                        ASSIGN wh-tx-tipo-pedido-cc0300:SCREEN-VALUE = "PEDIDO RESSARCIMENTO".
                    END.
                    WHEN 7 THEN DO:
                        ASSIGN wh-tx-tipo-pedido-cc0300:SCREEN-VALUE = "PEDIDO SPOT".
                    END.
                    WHEN 8 THEN DO:
                        ASSIGN wh-tx-tipo-pedido-cc0300:SCREEN-VALUE = "PEDIDO TROCA DE MODAL".
                    END.
                    WHEN 9 THEN DO:
                        ASSIGN wh-tx-tipo-pedido-cc0300:SCREEN-VALUE = "PARA MANAUS".
                    END.
                    WHEN 10 THEN DO:
                        ASSIGN wh-tx-tipo-pedido-cc0300:SCREEN-VALUE = "CKD COMUM".
                    END.
                    WHEN 11 THEN DO:
                        ASSIGN wh-tx-tipo-pedido-cc0300:SCREEN-VALUE = "CKD AMOSTRA".
                    END.
					WHEN 12 THEN DO:
                        ASSIGN wh-tx-tipo-pedido-cc0300:SCREEN-VALUE = "PARA ENGESUL".
                    END.
                    WHEN 13 THEN DO:
                        ASSIGN wh-tx-tipo-pedido-cc0300:SCREEN-VALUE = "PARA AUTOMATIZA".
                    END.
                    WHEN 14 THEN DO:
                        ASSIGN wh-tx-tipo-pedido-cc0300:SCREEN-VALUE = "BACK TO BACK".
                    END.
                    OTHERWISE ASSIGN wh-tx-tipo-pedido-cc0300:SCREEN-VALUE = "PEDIDO COMUM".
               END CASE.*/
            END.
        END.
    END.
    WHEN "AFTER-VALUE-CHANGED" THEN DO:

        ASSIGN c-table-upc-cc0300 = p-cod-table
               r-son-upc-cc0300   = p-row-table.

        IF VALID-HANDLE(wh-button-upc-cc0300) THEN DO:
            FIND FIRST ordem-compra
                WHERE ROWID(ordem-compra) = r-son-upc-cc0300 NO-LOCK NO-ERROR.
            IF AVAIL ordem-compra THEN
                ASSIGN wh-button-upc-cc0300:SENSITIVE = YES.

            ON "MOUSE-SELECT-CLICK":U OF wh-button-upc-cc0300
                PERSISTENT RUN ccp/cc0300logmr.w (INPUT r-son-upc-cc0300,
                                                  INPUT p-row-table,
                                                  INPUT "UPDATE":U,
                                                  INPUT p-wgh-object,
                                                  INPUT "1").
        END.
    END.
    WHEN "AFTER-DISPLAY" THEN DO:

        /* Esconde tela de Pedido Emergencial */
        IF VALID-HANDLE(wh-pedido-emerg) THEN
            ASSIGN wh-pedido-emerg:VISIBLE = NO.

        FIND FIRST pedido-compr NO-LOCK
             WHERE ROWID(pedido-compr) = p-row-table NO-ERROR.

        IF AVAIL pedido-compr THEN DO:
            IF VALID-HANDLE(wh-cod-estabel-cc0300) THEN
                ASSIGN wh-cod-estabel-cc0300:SCREEN-VALUE = pedido-compr.end-entrega.

            IF VALID-HANDLE(wh-tx-tipo-pedido-cc0300) THEN DO:

                /* Altera Texto do Tipo de Pedido */
                FOR FIRST int-pedido-compr WHERE
                        int-pedido-compr.num-pedido = pedido-compr.num-pedido NO-LOCK:

                     ASSIGN wh-cod-ckd-cc0300:SCREEN-VALUE = int-pedido-compr.cod-produto-ckd
                            wh-qtd-ckd-cc0300:SCREEN-VALUE = STRING(INT(int-pedido-compr.qtd-pedido-ckd),">,>>>,>>9").
    
                     FOR FIRST ponto-programa USE-INDEX ponto NO-LOCK
                        WHERE ponto-programa.nome-programa = "cc0300a"
                          AND ponto-programa.ponto         = 1
                          AND ponto-programa.tipo          = 3,
                         EACH conteudo-programa NO-LOCK
                        WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa
                          AND conteudo-programa.sequencia    = int-pedido-compr.tp-pedido:
                    
                        ASSIGN de-seq = deci(ENTRY(1,conteudo-programa.conteudo,";")) NO-ERROR.                                   
                    
                        IF de-seq <= 8 THEN               
                            ASSIGN wh-tx-tipo-pedido-cc0300:SCREEN-VALUE = CAPS("Pedido " + ENTRY(2,conteudo-programa.conteudo,";")) NO-ERROR.
                        ELSE
                            ASSIGN wh-tx-tipo-pedido-cc0300:SCREEN-VALUE = CAPS(ENTRY(2,conteudo-programa.conteudo,";")) NO-ERROR.
                        LEAVE.
                    END.
                END.
            END.
        END.

        FIND FIRST ordem-compra
            WHERE ROWID(ordem-compra) = r-son-upc-cc0300 NO-LOCK NO-ERROR.
        IF NOT AVAIL ordem-compra THEN DO:
            IF VALID-HANDLE(wh-button-upc-cc0300) THEN
                ASSIGN wh-button-upc-cc0300:SENSITIVE = NO.

            RETURN "OK":U.
        END.

        /*IF NOT VALID-HANDLE(wh-button-upc-cc0300) THEN DO:
            CREATE BUTTON wh-button-upc-cc0300
                ASSIGN FRAME     = p-wgh-frame
                       WIDTH     = 10
                       HEIGHT    = 1
                       LABEL     = "Matriz"
                       ROW       = 13.14
                       COL       = 44.87
                       FONT      = 1
                       VISIBLE   = YES
                       SENSITIVE = NO
                       TRIGGERS:                        
                           ON CHOOSE PERSISTENT RUN ccp/cc0300logmr.w (INPUT r-son-upc-cc0300,
                                                                       INPUT p-row-table,
                                                                       INPUT "UPDATE":U,
                                                                       INPUT p-wgh-object,
                                                                       INPUT "1").
                       END TRIGGERS.
        END.
        ASSIGN wh-button-upc-cc0300:SENSITIVE = YES.*/
    END.

    WHEN "AFTER-DESTROY-INTERFACE"
    THEN
        ASSIGN wh-temp-cc0300           = ?
               wh-button-upc-cc0300     = ?
               wh-txt-estabel-cc0300    = ?
               wh-cod-estabel-cc0300    = ?
               wh-txt-ckd-cc0300        = ?
               wh-cod-ckd-cc0300        = ?
               wh-pedido-emerg          = ?
               wh-tx-tipo-pedido-cc0300 = ?
               wh-txt-qtckd-cc0300      = ?
               wh-qtd-ckd-cc0300        = ?
               c-table-upc-cc0300       = ""
               r-son-upc-cc0300         = ?.
END CASE.


PROCEDURE tela-upc:
    DEFINE INPUT  PARAMETER  pWghFrame    AS WIDGET-HANDLE NO-UNDO.
    DEFINE INPUT  PARAMETER  pIndEvent    AS CHARACTER     NO-UNDO.
    DEFINE INPUT  PARAMETER  pObjType     AS CHARACTER     NO-UNDO.
    DEFINE INPUT  PARAMETER  pObjName     AS CHARACTER     NO-UNDO.
    DEFINE INPUT  PARAMETER  pApresMsg    AS LOGICAL       NO-UNDO.
    DEFINE INPUT  PARAMETER  pAux         AS INTEGER       NO-UNDO.
    DEFINE OUTPUT PARAMETER  phObj        AS HANDLE        NO-UNDO.

    DEFINE VARIABLE wgh-obj AS WIDGET-HANDLE NO-UNDO.
    DEFINE VARIABLE i-aux   AS INTEGER       NO-UNDO.

    ASSIGN wgh-obj = pWghFrame:FIRST-CHILD
           i-aux   = 0.

    DO WHILE VALID-HANDLE(wgh-obj):                                

        IF pApresMsg = YES THEN                                    
            MESSAGE "Nome do Objeto" wgh-obj:NAME SKIP             
                    "Type do Objeto" wgh-obj:TYPE SKIP             
                    "P-Ind-Event"    pIndEvent VIEW-AS ALERT-BOX.  

        IF wgh-obj:TYPE = pObjType AND
           wgh-obj:NAME = pObjName THEN DO:
            ASSIGN phObj = wgh-obj:HANDLE
                   i-aux = i-aux + 1.

            IF i-aux = pAux THEN
                LEAVE.
        END.
        IF wgh-obj:TYPE = "field-group" THEN
            ASSIGN wgh-obj = wgh-obj:FIRST-CHILD.
        ELSE
            ASSIGN wgh-obj = wgh-obj:NEXT-SIBLING.
    END.
END PROCEDURE.

IF p-ind-event = "piAbrePedOri" THEN DO:

    ASSIGN h-fill-pedido = fc-get-object-handle (p-wgh-frame,
                                                 FALSE,
                                                 FALSE,
                                                 "num-pedido", // nome objeto
                                                 "FILL-IN",  // tipo objeto
                                                 "").
    IF VALID-HANDLE (h-fill-pedido) 
    THEN do:
         assign iPedido-cc0300-upc = inte(h-fill-pedido:screen-value).

         RUN esp/ccp/esccp053.w.

         assign iPedido-cc0300-upc = 0.
    end.        

END.

