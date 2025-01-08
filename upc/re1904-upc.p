/***********************************************************************
**  Programa..: upc\re1904-upc.P
**  Autor.....: Carlos Daniel
**  Data......: Setembro/2016 - Desenvolvimento
**  Descricao.: 
**  Vers∆o....: 001 01/09/2016
**                  Desenvolvimento Programa
************************************************************************/
DEFINE INPUT PARAMETER p-ind-event        AS CHARACTER          NO-UNDO.
DEFINE INPUT PARAMETER p-ind-object       AS CHARACTER          NO-UNDO.
DEFINE INPUT PARAMETER p-wgh-object       AS HANDLE             NO-UNDO.
DEFINE INPUT PARAMETER p-wgh-frame        AS WIDGET-HANDLE      NO-UNDO.
DEFINE INPUT PARAMETER p-cod-table        AS CHARACTER          NO-UNDO.
DEFINE INPUT PARAMETER p-row-table        AS ROWID              NO-UNDO.

DEFINE VARIABLE c-objeto     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE h-frame      AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-re1904-upc AS HANDLE      NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE gr-docum-est               AS ROWID              NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-btDel-re1904-upc        AS WIDGET-HANDLE      NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-btAdd-re1904-upc        AS WIDGET-HANDLE      NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-btImp-re1904-upc        AS WIDGET-HANDLE      NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-iCodEmitente-re1904-upc AS WIDGET-HANDLE      NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-cSerieDocto-re1904-upc  AS WIDGET-HANDLE      NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-cNroDocto-re1904-upc    AS WIDGET-HANDLE      NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-cNatOperacao-re1904-upc AS WIDGET-HANDLE      NO-UNDO.

DEFINE BUFFER b-docum-est FOR docum-est.

DEFINE TEMP-TABLE tt-import NO-UNDO
    FIELD embarque  LIKE embarque-imp.embarque.

DEFINE TEMP-TABLE tt-docto NO-UNDO
    FIELD cod-emitente  LIKE docum-est.cod-emitente
    FIELD nro-docto     LIKE docum-est.nro-docto
    FIELD serie         LIKE docum-est.serie
    FIELD nat-operacao  LIKE docum-est.nat-operacao
    FIELD erro AS LOGICAL.

IF VALID-HANDLE(p-wgh-object) THEN
    ASSIGN c-objeto = ENTRY(NUM-ENTRIES(p-wgh-object:FILE-NAME,"~/"), 
                            p-wgh-object:FILE-NAME,"~/").

/*
MESSAGE 'p-ind-event  ' p-ind-event  SKIP
        'p-ind-object ' p-ind-object SKIP
        'p-cod-table  ' p-cod-table  SKIP
        'p-row-table  ' string(p-row-table) SKIP
        'c-objeto     ' c-objeto
    VIEW-AS ALERT-BOX INFO BUTTONS OK. 
*/

IF  p-ind-event  = "AFTER-INITIALIZE" AND p-ind-object = "CONTAINER"   THEN DO:

    RUN busca-handle(INPUT p-wgh-frame,
                     INPUT "btDel",
                     OUTPUT wh-btDel-re1904-upc).

    RUN busca-handle(INPUT p-wgh-frame,
                     INPUT "btAdd",
                     OUTPUT wh-btAdd-re1904-upc).

    RUN busca-handle(INPUT p-wgh-frame,
                     INPUT "i-cod-emitente",
                     OUTPUT wh-iCodEmitente-re1904-upc).

    RUN busca-handle(INPUT p-wgh-frame,
                     INPUT "c-serie-docto",
                     OUTPUT wh-cSerieDocto-re1904-upc).

    RUN busca-handle(INPUT p-wgh-frame,
                     INPUT "c-nro-docto",
                     OUTPUT wh-cNroDocto-re1904-upc).

    RUN busca-handle(INPUT p-wgh-frame,
                     INPUT "c-nat-operacao",
                     OUTPUT wh-cNatOperacao-re1904-upc).

    RUN upc/re1904-upc.p PERSISTENT SET h-re1904-upc(INPUT "",
                                                     INPUT "",
                                                     INPUT p-wgh-object,
                                                     INPUT p-wgh-frame,
                                                     INPUT "",
                                                     INPUT p-row-table).

    IF VALID-HANDLE(wh-btDel-re1904-upc) THEN DO:
        CREATE BUTTON wh-btImp-re1904-upc
            ASSIGN FRAME        = p-wgh-frame
                   WIDTH        = wh-btDel-re1904-upc:WIDTH
                   HEIGHT       = wh-btDel-re1904-upc:HEIGHT + 0.25
                   ROW          = wh-btDel-re1904-upc:ROW + 1.2
                   LABEL        = "OK"
                   COLUMN       = wh-btDel-re1904-upc:COLUMN
                   SENSITIVE    = YES
                   VISIBLE      = YES
                   TOOLTIP      = 'Importar'
                TRIGGERS:
                   ON CHOOSE PERSISTENT RUN pi-importa IN h-re1904-upc.
                END TRIGGERS.
        wh-btImp-re1904-upc:LOAD-IMAGE('image/im-imp.bmp').
    END.
END.

PROCEDURE pi-importa:
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE c-arquivo-entrada AS CHARACTER NO-UNDO.

    RUN upc/re1904-upcw.w (OUTPUT c-arquivo-entrada).

    IF c-arquivo-entrada <> "" THEN DO:
        RUN piImportaArquivo(INPUT c-arquivo-entrada).
        
        IF  CAN-FIND(FIRST tt-docto WHERE tt-docto.erro = TRUE) OR NOT CAN-FIND(FIRST tt-import) THEN
            RUN utp/ut-msgs.p (INPUT "show":U,
                               INPUT 15825,
                               INPUT "As inconsistàncias geraram um arquivo." + '~~' +
                                     "Pode encontra-lo no caminho: " + STRING(SESSION:TEMP-DIRECTORY + "Importacao-ERROS.csv":U)).
    END.

END PROCEDURE.

PROCEDURE piImportaArquivo :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-arquivo-entrada AS CHARACTER NO-UNDO.
    
    DEFINE VARIABLE i-cont  AS INTEGER   NO-UNDO.
    DEFINE VARIABLE c-linha AS CHARACTER NO-UNDO.
    
    INPUT FROM VALUE(p-arquivo-entrada).
    OUTPUT TO VALUE(SESSION:TEMP-DIRECTORY + "Importacao-ERROS.csv":U) NO-CONVERT.
    
    EMPTY TEMP-TABLE tt-import NO-ERROR.
    
    REPEAT:
        IMPORT UNFORMATTED c-linha.
    
        ASSIGN i-cont = i-cont + 1.
    
        IF i-cont = 1 THEN
            NEXT.

        CREATE tt-import.
        ASSIGN tt-import.embarque  = ENTRY(1,c-linha,";").

        FIND FIRST docum-est NO-LOCK
             WHERE ROWID(docum-est) = gr-docum-est NO-ERROR.

        FIND FIRST embarque-imp NO-LOCK
             WHERE embarque-imp.embarque    = tt-import.embarque 
               AND embarque-imp.cod-estabel = docum-est.cod-estabel NO-ERROR.

        IF NOT AVAIL embarque-imp THEN DO:
            PUT UNFORMATTED tt-import.embarque ";" "ERRO: N∆o encontrado(a) Embarque para chave informada." SKIP.
            CREATE tt-docto.
            ASSIGN tt-docto.erro = TRUE.
        END.
        ELSE DO:
            IF embarque-imp.situacao <> 2  THEN DO:
                PUT UNFORMATTED tt-import.embarque ";" "ERRO: Embarque com situaá∆o N∆o Encerrado." SKIP.
                CREATE tt-docto.
                ASSIGN tt-docto.erro = TRUE.
            END.
            ELSE DO:
                FOR EACH b-docum-est NO-LOCK
                   WHERE b-docum-est.cod-estabel = embarque-imp.cod-estabel
                     AND b-docum-est.embarque    = embarque-imp.embarque
                     AND b-docum-est.nat-operacao BEGINS "3":

                    CREATE tt-docto.
                    ASSIGN tt-docto.cod-emitente = b-docum-est.cod-emitente
                           tt-docto.serie        = b-docum-est.serie       
                           tt-docto.nro-docto    = b-docum-est.nro-docto   
                           tt-docto.nat-operacao = b-docum-est.nat-operacao.
                END.
            END.
        END.
    END. /* REPEAT: */
    INPUT CLOSE.
    OUTPUT CLOSE.

    IF NOT CAN-FIND(FIRST tt-docto WHERE tt-docto.erro) THEN DO:

        IF VALID-HANDLE(wh-iCodEmitente-re1904-upc) AND
           VALID-HANDLE(wh-cSerieDocto-re1904-upc)  AND
           VALID-HANDLE(wh-cNroDocto-re1904-upc)    AND
           VALID-HANDLE(wh-cNatOperacao-re1904-upc) AND
           VALID-HANDLE(wh-btAdd-re1904-upc) THEN DO:

            FOR EACH tt-docto:
                ASSIGN wh-iCodEmitente-re1904-upc:SCREEN-VALUE = STRING(tt-docto.cod-emitente)
                       wh-cSerieDocto-re1904-upc :SCREEN-VALUE = tt-docto.serie
                       wh-cNroDocto-re1904-upc   :SCREEN-VALUE = tt-docto.nro-docto
                       wh-cNatOperacao-re1904-upc:SCREEN-VALUE = tt-docto.nat-operacao.

                APPLY "CHOOSE" TO wh-btAdd-re1904-upc.
            END.
        END.
    END.

END PROCEDURE.

PROCEDURE busca-handle:
    DEFINE INPUT  PARAMETER p-wgh-frame  AS WIDGET-HANDLE    NO-UNDO.  /* Handle da Frame Principal do programa */
    DEFINE INPUT  PARAMETER p-nome-obj   AS CHARACTER        NO-UNDO.  /* Nome do objeto que se dejesa achar o handle */
    DEFINE OUTPUT PARAMETER p-handl-obj  AS WIDGET-HANDLE    NO-UNDO.  /* Handle do Componente */

    DEFINE VARIABLE h-aux   AS WIDGET-HANDLE    NO-UNDO.

    /* Frame Principal */
    ASSIGN h-aux = p-wgh-frame.

    /* field-group */
    ASSIGN h-aux = h-aux:FIRST-CHILD.

    /* Primeiro componente da Frame */
    ASSIGN h-aux = h-aux:FIRST-CHILD.

    REPEAT:
        IF h-aux:NAME <> p-nome-obj THEN DO:
            ASSIGN h-aux = h-aux:NEXT-SIBLING.

            IF NOT VALID-HANDLE(h-aux) THEN DO:
                ASSIGN p-handl-obj = ?.
                LEAVE.
            END.
        END.
        ELSE DO:
            ASSIGN p-handl-obj = h-aux.
            LEAVE.
        END.
    END.
END.
