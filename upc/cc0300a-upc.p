/* Parameter Definitions ****************************************************/
define input parameter p-ind-event  as character.
define input parameter p-ind-object as character.
define input parameter p-wgh-object as handle.
define input parameter p-wgh-frame  as widget-handle.
define input parameter p-cod-table  as character.
define input parameter p-row-table  as rowid.

/* DEFINE NEW GLOBAL SHARED VARIABLE wh-log-skip-lote-automatico  AS WIDGET-HANDLE NO-UNDO.  */
DEFINE NEW GLOBAL SHARED VARIABLE wh-cb-tipo-pedido  AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-tx-tipo-pedido  AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-pedido          AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-data-pedido     AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-cod-emitente    AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE l-add              AS LOGICAL       NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-impr-pedido     AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-txt-ckd-cc0300a         AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-cod-ckd-cc0300a         AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-txt-qtckd-cc0300a       AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-qtd-ckd-cc0300a         AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR h-upc-cc0300a              AS WIDGET-HANDLE NO-UNDO.

DEFINE VARIABLE wgh-obj-aux AS WIDGET-HANDLE      NO-UNDO.
DEFINE VARIABLE phObj-aux   AS WIDGET-HANDLE      NO-UNDO.
DEFINE VARIABLE h-aux       AS WIDGET-HANDLE      NO-UNDO.
DEFINE VARIABLE h-col       AS HANDLE             NO-UNDO.
DEFINE VARIABLE i-aux       AS INTEGER            NO-UNDO.
DEFINE VARIABLE lg-aux      AS LOGICAL            NO-UNDO.
DEFINE VARIABLE i-col       AS INTEGER     NO-UNDO.
DEFINE VARIABLE de-seq      AS DECIMAL     NO-UNDO.
DEFINE VARIABLE cObservacao AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-tp-pedido AS CHARACTER   NO-UNDO.

DEF BUFFER b-pedido-compr FOR pedido-compr.

/* message "P-ind-event  = " p-ind-event    skip                                                               */
/*         "P-ind-object = " p-ind-object skip                                                                 */
/*         "P-wgh-object = " p-wgh-object skip                                                                 */
/*         "P-wgh-frame  = " p-wgh-frame  skip                                                                 */
/*         "P-cod-table  = " p-cod-table  skip                                                                 */
/*         "p-row-table  = " string(p-row-table) skip                                                          */
/*         "c-objeto     = " entry(num-entries(p-wgh-object:file-name,'~/'),p-wgh-object:file-name,'~/') skip  */
/*         view-as alert-box.                                                                                  */

IF  p-ind-object = "CONTAINER"  AND
   (p-ind-event  = "AFTER-ADD"  OR 
    p-ind-event  = "AFTER-COPY" ) THEN DO:

    ASSIGN l-add = YES.

END.

IF p-ind-object = "CONTAINER"   AND
   p-ind-event = "AFTER-DESTROY-INTERFACE" THEN DO:

    ASSIGN l-add             = NO
           wh-cb-tipo-pedido = ?
           wh-tx-tipo-pedido = ?
           wh-pedido         = ?
           wh-data-pedido    = ?
           wh-impr-pedido    = ?
           wh-cod-emitente   = ?.
END.

IF p-ind-object = "CONTAINER"   AND
   p-ind-event = "BEFORE-INITIALIZE" THEN DO:
    RUN upc/cc0300a-upc.p PERSISTENT SET h-upc-cc0300a(INPUT "",            
                                                       INPUT "",            
                                                       INPUT p-wgh-object,  
                                                       INPUT p-wgh-frame,   
                                                       INPUT "",            
                                                       INPUT p-row-table).

    CREATE TEXT wh-txt-ckd-cc0300a
    ASSIGN FRAME        = p-wgh-frame
           FORMAT       = "x(09)"
           WIDTH        = 09
           SCREEN-VALUE = "Prod CKD:"
           ROW          = 4.31
           COL          = 67.5
           VISIBLE      = YES.

    CREATE FILL-IN wh-cod-ckd-cc0300a
    ASSIGN FRAME             = p-wgh-frame
           DATA-TYPE         = "CHARACTER"
           FORMAT            = "X(08)" 
           WIDTH             = 8
           HEIGHT            = .88
           ROW               = 4.17
           COL               = 75
           VISIBLE           = YES
           SENSITIVE         = NO.

    CREATE TEXT wh-txt-qtckd-cc0300a
    ASSIGN FRAME        = p-wgh-frame
           FORMAT       = "x(09)"
           WIDTH        = 09
           SCREEN-VALUE = "Qtd CKD:"
           ROW          = 5.31
           COL          = 66
           VISIBLE      = YES.

    CREATE FILL-IN wh-qtd-ckd-cc0300a
    ASSIGN FRAME             = p-wgh-frame
           DATA-TYPE         = "CHARACTER"
           FORMAT            = "x(12)" 
           WIDTH             = 10
           HEIGHT            = .88
           ROW               = 5.17
           COL               = 73
           VISIBLE           = YES
           SENSITIVE         = NO.


/*     CREATE TOGGLE-BOX wh-log-skip-lote-automatico                                                */
/*     ASSIGN FRAME            = p-wgh-frame                                                        */
/*            NAME             = "wh-log-skip-lote-automatico"                                      */
/*            HEIGHT           = 0.83                                                               */
/*            WIDTH            = 25                                                                 */
/*            ROW              = 5.17                                                               */
/*            COL              = 42.00                                                              */
/*            LABEL            = "Bloqueio Previsto Pendente?"                                      */
/*            VISIBLE          = YES                                                                */
/*            SENSITIVE        = YES                                                                */
/*            CHECKED          = NO                                                                 */
/*             TRIGGERS:                                                                            */
/*                 ON "VALUE-CHANGED":U PERSISTENT RUN pi-value-changed-skip-lote IN h-upc-cc0300a. */
/*             END TRIGGERS.                                                                        */
END.

IF p-ind-object = "CONTAINER"  AND
   p-ind-event  = "AFTER-COPY" AND
   VALID-HANDLE(wh-cb-tipo-pedido)
THEN DO:
    RELEASE int-pedido-compr.

    FOR FIRST b-pedido-compr 
        WHERE ROWID(b-pedido-compr) = p-row-table
              NO-LOCK: END.

    IF AVAIL b-pedido-compr
    THEN FOR FIRST int-pedido-compr 
             WHERE int-pedido-compr.num-pedido = b-pedido-compr.num-pedido
                   NO-LOCK: END.

    IF AVAIL int-pedido-compr
    THEN FOR FIRST ponto-programa USE-INDEX ponto NO-LOCK
             WHERE ponto-programa.nome-programa = "cc0300a"
               AND ponto-programa.ponto         = 1
               AND ponto-programa.tipo          = 3,
              EACH conteudo-programa NO-LOCK
             WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa
               AND conteudo-programa.sequencia    = int-pedido-compr.tp-pedido:
             ASSIGN de-seq = deci(ENTRY(1,conteudo-programa.conteudo,";")) NO-ERROR.
        
             IF ERROR-STATUS:ERROR
             OR NUM-ENTRIES(conteudo-programa.conteudo,";") < 4
             OR conteudo-programa.sequencia                <> de-seq
             OR conteudo-programa.sequencia                 = 0
             THEN LEAVE.
        
             IF ENTRY(4,conteudo-programa.conteudo,";") = "INATIVO"
             THEN LEAVE.
        
             ASSIGN wh-cb-tipo-pedido:SCREEN-VALUE = STRING(conteudo-programa.sequencia) NO-ERROR.
             LEAVE.
         END.
END.

IF p-ind-object = "CONTAINER"   AND
   p-ind-event  = "BEFORE-DISPLAY"
THEN DO:
    RELEASE int-pedido-compr.

    FOR FIRST b-pedido-compr 
        WHERE ROWID(b-pedido-compr) = p-row-table
              NO-LOCK: END.

    IF AVAIL b-pedido-compr
    THEN FOR FIRST int-pedido-compr 
             WHERE int-pedido-compr.num-pedido = b-pedido-compr.num-pedido
                   NO-LOCK: END.

    FOR FIRST ponto-programa USE-INDEX ponto NO-LOCK
        WHERE ponto-programa.nome-programa = "cc0300a"
          AND ponto-programa.ponto         = 1
          AND ponto-programa.tipo          = 3,
         EACH conteudo-programa NO-LOCK
        WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa:
        ASSIGN de-seq = deci(ENTRY(1,conteudo-programa.conteudo,";")) NO-ERROR.

        IF ERROR-STATUS:ERROR
        OR NUM-ENTRIES(conteudo-programa.conteudo,";") < 4
        OR conteudo-programa.sequencia                <> de-seq
        OR conteudo-programa.sequencia                 = 0
        THEN DO:
             ASSIGN c-tp-pedido = ""
                    lg-aux      = YES.
             run utp/ut-msgs.p (input "show", input 17567, input "ATENÄ«O! ERRO ao carregamento do Tipo Pedido. Revise o ES0018 (" + STRING(conteudo-programa.sequencia) + ")").
             LEAVE.
        END.

        IF  ENTRY(4,conteudo-programa.conteudo,";") = "INATIVO"
        AND (NOT AVAIL int-pedido-compr
         OR  int-pedido-compr.tp-pedido <> conteudo-programa.sequencia)
        THEN NEXT.

        ASSIGN c-tp-pedido = c-tp-pedido 
                           + TRIM(ENTRY(2,conteudo-programa.conteudo,";"))
                           + ","
                           + STRING(conteudo-programa.sequencia)
                           + ",".

        IF conteudo-programa.sequencia = 3
        THEN ASSIGN lg-aux = YES.
    END.

    ASSIGN c-tp-pedido = TRIM(c-tp-pedido,",").

    IF NOT lg-aux
    THEN run utp/ut-msgs.p (input "show", input 17567, input "ATENÄ«O! ERRO ao carregamento do Tipo Pedido. Valor inicial estabelecido (3-Comum) n∆o se encontra mais ativo (ver ES0018). Favor revisar!").

    CREATE TEXT wh-tx-tipo-pedido
    ASSIGN FRAME        = p-wgh-frame
           FORMAT       = "x(12)"   
           WIDTH        = 9
           SCREEN-VALUE = "Tipo Pedido:"
           ROW          = 4.31
           COL          = 42
           VISIBLE      = YES.

    CREATE COMBO-BOX wh-cb-tipo-pedido
    ASSIGN FRAME            = p-wgh-frame
           DATA-TYPE        = "character"
           WIDTH            = 16
           COL              = 50.9
           ROW              = 4.17
           VISIBLE          = YES
           INNER-LINES      = 5
           HELP             = "Tipo Pedido:"
           FONT             = 1
           LIST-ITEM-PAIRS  = c-tp-pedido
           SCREEN-VALUE     = "3"
           TRIGGERS:
               ON "VALUE-CHANGED":U PERSISTENT RUN pi-value-changed-ckd IN h-upc-cc0300a.
           END TRIGGERS.
END.

IF p-ind-object = "CONTAINER"   AND
   p-ind-event = "AFTER-INITIALIZE" THEN DO:

    /*---  Alterado a pedido da Gizelle , 08/08/2014 --------------------
    ASSIGN wh-cb-tipo-pedido:SENSITIVE = l-add.  */

    DEFINE VARIABLE h-handle AS HANDLE      NO-UNDO.
    DEFINE VARIABLE hfPage1             AS HANDLE           NO-UNDO.

    ASSIGN h-handle = p-wgh-frame:FIRST-CHILD.  /* pegando o 1o. Campo */
    bloco:
    DO WHILE h-handle <> ? :
        IF h-handle:TYPE <> "field-group"
        THEN DO:
            //MESSAGE h-handle:NAME VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
            IF h-handle:NAME = "emergencial"
            THEN DO:
                ASSIGN  h-handle:COL = 2.
            END.
            IF h-handle:NAME = "impr-pedido"
            THEN DO:
                ASSIGN  h-handle:COL = 22.
            END.
            ASSIGN h-handle = h-handle:NEXT-SIBLING.
        END. 
        ELSE DO:
            ASSIGN h-handle = h-handle:FIRST-CHILD.
        END.
    END.

    ASSIGN wh-cb-tipo-pedido:SENSITIVE = TRUE.
    ASSIGN wh-qtd-ckd-cc0300a:SENSITIVE = TRUE.
    ASSIGN wh-cod-ckd-cc0300a:SENSITIVE = TRUE.

    /*fPage1*/
    RUN tela-upc (INPUT p-wgh-frame,
                  INPUT p-ind-Event,
                  INPUT "TOGGLE-BOX",       /*** Type ***/
                  INPUT "impr-pedido",   /*** Name ***/
                  INPUT NO,            /*** Apresenta Mensagem dos Objetos ***/
                  INPUT 1,             /*** Quando existir mais de um objeto com o mesmo nome ***/
                  OUTPUT wh-impr-pedido).
    IF VALID-HANDLE(wh-impr-pedido) THEN
        wh-cb-tipo-pedido:MOVE-AFTER-TAB-ITEM(wh-impr-pedido).

    /*fPage1*/
    RUN tela-upc (INPUT p-wgh-frame,
                  INPUT p-ind-Event,
                  INPUT "FILL-IN",       /*** Type ***/
                  INPUT "num-pedido",   /*** Name ***/
                  INPUT NO,            /*** Apresenta Mensagem dos Objetos ***/
                  INPUT 1,             /*** Quando existir mais de um objeto com o mesmo nome ***/
                  OUTPUT wh-pedido).
    IF  VALID-HANDLE(wh-pedido)
    THEN
        ASSIGN wh-pedido:READ-ONLY = YES.

    RUN tela-upc (INPUT p-wgh-frame,
                  INPUT p-ind-Event,
                  INPUT "FILL-IN",     /*** Type ***/
                  INPUT "data-pedido", /*** Name ***/
                  INPUT NO,            /*** Apresenta Mensagem dos Objetos ***/
                  INPUT 1,             /*** Quando existir mais de um objeto com o mesmo nome ***/
                  OUTPUT wh-data-pedido).
    IF  VALID-HANDLE(wh-data-pedido)
    THEN
        ASSIGN wh-data-pedido:SENSITIVE = NO.

/*     RUN tela-upc (INPUT p-wgh-frame,                                                               */
/*                   INPUT p-ind-Event,                                                               */
/*                   INPUT "FILL-IN",     /*** Type ***/                                              */
/*                   INPUT "cod-emitente", /*** Name ***/                                             */
/*                   INPUT NO,            /*** Apresenta Mensagem dos Objetos ***/                    */
/*                   INPUT 1,             /*** Quando existir mais de um objeto com o mesmo nome ***/ */
/*                   OUTPUT wh-cod-emitente).                                                         */
/*     IF  VALID-HANDLE(wh-cod-emitente)                                                              */
/*     THEN DO:                                                                                       */
/*         APPLY "entry" TO wh-cod-emitente.                                                          */
/*         RETURN NO-APPLY.                                                                           */
/*     END.                                                                                           */
/*                                                                                                    */

    APPLY "VALUE-CHANGED" TO wh-cb-tipo-pedido.
END.

IF p-ind-object = "CONTAINER"   AND
   p-ind-event  = "AFTER-DISPLAY" THEN DO:
    /*Desloca campos do cabeáalho Ö esquerda*/
    ASSIGN wgh-obj-aux = p-wgh-frame:FIRST-CHILD.
    DO WHILE VALID-HANDLE(wgh-obj-aux):
    
        /*Quantas colunas vai deslocar*/
        ASSIGN i-col = 0.

        IF wgh-obj-aux:TYPE = "fill-in"
        OR wgh-obj-aux:TYPE = "combo-box"
        OR wgh-obj-aux:TYPE = "toggle-box" THEN DO:
           ASSIGN h-aux = wgh-obj-aux:HANDLE.

           IF wgh-obj-aux:NAME = "data-pedido" THEN DO:
                ASSIGN i-col = i-col + 20.
           END.

           IF wgh-obj-aux:NAME = "cb-situacao" THEN DO:
                ASSIGN wgh-obj-aux:ROW = 1.17
                       wgh-obj-aux:SIDE-LABEL-HANDLE:ROW = 1.20.
           END.

           ASSIGN h-aux:COL = h-aux:COL - i-col.

           ASSIGN h-col = ?.
           IF wgh-obj-aux:TYPE = "fill-in" 
           OR wgh-obj-aux:TYPE = "combo-box"  THEN
               ASSIGN h-col = h-aux:SIDE-LABEL-HANDLE.

               IF VALID-HANDLE(h-col) THEN
                   ASSIGN h-col:COL = h-col:COL - i-col.
        END.

        IF wgh-obj-aux:TYPE = "field-group" THEN
            ASSIGN wgh-obj-aux = wgh-obj-aux:FIRST-CHILD.
        ELSE
            ASSIGN wgh-obj-aux = wgh-obj-aux:NEXT-SIBLING.
    END.
    /**/

    /*fPage1*/
    RUN tela-upc (INPUT p-wgh-frame,
                  INPUT p-ind-Event,
                  INPUT "FILL-IN",       /*** Type ***/
                  INPUT "num-pedido",   /*** Name ***/
                  INPUT NO,            /*** Apresenta Mensagem dos Objetos ***/
                  INPUT 1,             /*** Quando existir mais de um objeto com o mesmo nome ***/
                  OUTPUT wh-pedido).
    
    FOR FIRST int-pedido-compr NO-LOCK
        WHERE int-pedido-compr.num-pedido = INT(wh-pedido:SCREEN-VALUE):

        IF int-pedido-compr.tp-pedido <> 0 THEN
            ASSIGN wh-cb-tipo-pedido:SCREEN-VALUE = STRING(int-pedido-compr.tp-pedido).

        ASSIGN wh-qtd-ckd-cc0300a:SCREEN-VALUE = STRING(INT(int-pedido-compr.qtd-pedido-ckd),">,>>>,>>9")
               wh-cod-ckd-cc0300a:SCREEN-VALUE = int-pedido-compr.cod-produto-ckd .
    END.

    //Tratativa SkipLote
    DEFINE BUFFER bf-pedido-compr FOR pedido-compr.
    FIND bf-pedido-compr WHERE ROWID(bf-pedido-compr) = p-row-table NO-LOCK NO-ERROR.

    IF  AVAIL bf-pedido-compr
/*     AND VALID-HANDLE(wh-log-skip-lote-automatico) */
    THEN DO:
        ASSIGN /*wh-log-skip-lote-automatico:CHECKED = bf-pedido-compr.log-1*/
               cObservacao = bf-pedido-compr.char-2.
    END.

END.

/* IF  p-ind-object = "CONTAINER"                                                */
/* AND p-ind-event = "BEFORE-SAVE-FIELDS" THEN DO:                               */
/*     IF wh-cod-ckd-cc0300a:SCREEN-VALUE <> "" THEN DO:                         */
/*         FIND FIRST ITEM NO-LOCK                                               */
/*              WHERE ITEM.it-codigo = wh-cod-ckd-cc0300a:SCREEN-VALUE NO-ERROR. */
/*                                                                               */
/*         IF NOT AVAIL ITEM THEN DO:                                            */
/*             RUN utp/ut-msgs.p (INPUT "show",                                  */
/*                                INPUT 17006,                                   */
/*                                INPUT "N∆o encontrado item CKD informado.").   */
/*             RETURN "NO-APPLY".                                                */
/*         END.                                                                  */
/*     END.                                                                      */
/* END.                                                                          */

IF p-ind-object = "CONTAINER"   AND
   p-ind-event = "AFTER-ASSIGN" THEN DO:
    FOR FIRST int-pedido-compr WHERE
            int-pedido-compr.num-pedido = INT(wh-pedido:SCREEN-VALUE) EXCLUSIVE-LOCK:

        ASSIGN int-pedido-compr.tp-pedido       = INT(wh-cb-tipo-pedido:screen-value)
               int-pedido-compr.qtd-pedido-ckd  = INT(wh-qtd-ckd-cc0300a:screen-value)
               int-pedido-compr.cod-produto-ckd = wh-cod-ckd-cc0300a:SCREEN-VALUE.
    END.

    //Tratativa SkipLote
    //DEFINE BUFFER bf-pedido-compr FOR pedido-compr.
    FIND bf-pedido-compr WHERE ROWID(bf-pedido-compr) = p-row-table NO-ERROR.

    IF AVAIL bf-pedido-compr
/*     AND VALID-HANDLE(wh-log-skip-lote-automatico) */
    THEN DO:
        ASSIGN  /*bf-pedido-compr.log-1   = wh-log-skip-lote-automatico:CHECKED*/
                bf-pedido-compr.char-2  = cObservacao.
    END.

END.

PROCEDURE tela-upc:
    DEFINE INPUT  PARAMETER  pWghFrame    AS WIDGET-HANDLE NO-UNDO.
    DEFINE INPUT  PARAMETER  pIndEvent    AS CHARACTER     NO-UNDO.
    DEFINE INPUT  PARAMETER  pObjType     AS CHARACTER     NO-UNDO.
    DEFINE INPUT  PARAMETER  pObjName     AS CHARACTER     NO-UNDO.
    DEFINE INPUT  PARAMETER  pApresMsg    AS LOGICAL       NO-UNDO.
    DEFINE INPUT  PARAMETER  pAux         AS INTEGER       NO-UNDO.
    DEFINE OUTPUT PARAMETER  phObj        AS HANDLE        NO-UNDO.

    DEFINE VARIABLE wgh-obj AS WIDGET-HANDLE NO-UNDO.
    

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

PROCEDURE pi-value-changed-ckd:
    IF wh-cb-tipo-pedido:SCREEN-VALUE = "10"
    OR wh-cb-tipo-pedido:SCREEN-VALUE = "11" THEN DO:
        ASSIGN wh-qtd-ckd-cc0300a:SENSITIVE = YES
               wh-cod-ckd-cc0300a:SENSITIVE = YES.
    END.
    ELSE DO:
        ASSIGN wh-qtd-ckd-cc0300a:SENSITIVE = NO
               wh-cod-ckd-cc0300a:SENSITIVE = NO
               wh-qtd-ckd-cc0300a:SCREEN-VALUE = ""
               wh-cod-ckd-cc0300a:SCREEN-VALUE = "".
    END.
END PROCEDURE.

/* PROCEDURE pi-value-changed-skip-lote:                      */
/*                                                            */
/*     IF wh-log-skip-lote-automatico:CHECKED                 */
/*     THEN DO:                                               */
/*         RUN upc/cc0300a1-upc.w (INPUT YES,                 */
/*                                 INPUT-OUTPUT cObservacao). */
/*     END.                                                   */
/*                                                            */
/* END PROCEDURE.                                             */
