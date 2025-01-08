/***********************************************************************
**  Programa..: upc\im0545-upc.p
************************************************************************/

{utp/ut-glob.i}

DEFINE INPUT PARAMETER p-ind-event  as char          no-undo.
DEFINE INPUT PARAMETER p-ind-object as char          no-undo.
DEFINE INPUT PARAMETER p-wgh-object as handle        no-undo.
DEFINE INPUT PARAMETER p-wgh-frame  as widget-handle no-undo.
DEFINE INPUT PARAMETER p-cod-table  as char          no-undo.
DEFINE INPUT PARAMETER p-row-table  as rowid         no-undo.

DEFINE VARIABLE h-object AS HANDLE NO-UNDO.
DEFINE VARIABLE h-campo  AS HANDLE NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE h-programa                AS HANDLE        NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wgh-window                AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-fpage1-im0545          AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE tx-fill-ctnr-im0545       AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-fill-ctnr-im0545       AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE tx-qt-ctnr-im0545         AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-qt-ctnr-im0545         AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-qt2-ctnr-im0545        AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE tx-volume-ctnr-im0545     AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE h-im0545-upc              AS WIDGET-HANDLE NO-UNDO.

DEFINE VARIABLE c-char AS   CHAR.

DEFINE BUFFER bf-embarque-imp FOR embarque-imp.

assign c-char = entry(num-entries(p-wgh-object:file-name,"~/"), p-wgh-object:file-name,"~/").

/*
MESSAGE "Evento " p-ind-event  SKIP
        "Objeto " p-ind-object SKIP
        "Nome   " c-char SKIP
        "Tabela " p-cod-table  SKIP
        "Rowid  " STRING(p-row-table) skip
        "c-char " c-char 
    VIEW-AS ALERT-BOX INFO BUTTONS OK. 
*/

IF p-ind-object = "CONTAINER"   AND
   p-ind-event = "BEFORE-INITIALIZE" THEN DO:

    /*fPage1*/
    RUN tela-upc (INPUT p-wgh-frame,
                  INPUT p-ind-Event,
                  INPUT "frame",       /*** Type ***/
                  INPUT "fPage1",      /*** Name ***/
                  INPUT NO,            /*** Apresenta Mensagem dos Objetos ***/
                  INPUT 1,             /*** Quando existir mais de um objeto com o mesmo nome ***/
                  OUTPUT wh-fpage1-im0545).

    IF NOT VALID-HANDLE(h-im0545-upc) THEN
       RUN upc/im0545-upc.p PERSISTENT SET h-im0545-upc(INPUT "",
                                                        INPUT "",
                                                        INPUT p-wgh-object,
                                                        INPUT p-wgh-frame,
                                                        INPUT "",
                                                        INPUT p-row-table).
    IF  VALID-HANDLE(wh-fpage1-im0545) THEN DO:
        
        /*---[ Referente chamado 26630 ]----------------------------------------------*/
        CREATE TEXT tx-fill-ctnr-im0545
        ASSIGN FRAME        = wh-fpage1-im0545
               FORMAT       = "x(05)"
               SCREEN-VALUE = "Tipo:"
               WIDTH        = 04.00
               HEIGHT       = 00.79
               ROW          = 07.00
               COL          = 62.86
               VISIBLE      = YES.
        
        CREATE FILL-IN wh-fill-ctnr-im0545
        ASSIGN FRAME         = wh-fpage1-im0545
               FORMAT        = "x(18)":U
               WIDTH         = 18.00
               HEIGHT        = 00.79
               ROW           = 07.00
               COL           = 67.00
               FONT          = 1
               VISIBLE       = YES.

        CREATE TEXT tx-qt-ctnr-im0545
        ASSIGN FRAME        = wh-fpage1-im0545
               FORMAT       = "x(15)"
               SCREEN-VALUE = "Qtd.Cont:"
               WIDTH        = 10.00
               HEIGHT       = 00.79
               ROW          = 07.83
               COL          = 61.86
               VISIBLE      = YES.

        CREATE FILL-IN wh-qt-ctnr-im0545
        ASSIGN FRAME       = wh-fpage1-im0545
               DATA-TYPE   = "INTEGER"
               FORMAT      = ">,>>>,>>9" 
               WIDTH       = 8.00
               HEIGHT      = 00.79
               ROW         = 07.83
               COL         = 69.00
               VISIBLE     = YES
               SENSITIVE   = NO.

        CREATE FILL-IN wh-qt2-ctnr-im0545
        ASSIGN FRAME       = wh-fpage1-im0545
               DATA-TYPE   = "INTEGER"
               FORMAT      = ">,>>>,>>9"
               WIDTH       = 8.00
               HEIGHT      = 00.79
               ROW         = 07.83
               COL         = 77.00
               VISIBLE     = NO
               SENSITIVE   = NO.

        CREATE TEXT tx-volume-ctnr-im0545
        ASSIGN FRAME        = wh-fpage1-im0545
               FORMAT       = "x(8)"
               WIDTH        = 8.00
               SCREEN-VALUE = "VOLUMES"
               HEIGHT       = 00.79
               ROW          = 07.83
               COL          = 77.10
               VISIBLE      = NO.


     /*----------------------------------------------[ Referente chamado 26630 ]---*/
    END.
END.

IF p-ind-object = "CONTAINER"   AND
   p-ind-event = "AFTER-DISPLAY" THEN DO:
    
    FIND FIRST embarque-imp 
         WHERE ROWID(embarque-imp) = p-row-table NO-LOCK NO-ERROR.
    IF  AVAIL embarque-imp THEN DO:
        /*---[ Referente chamado 26630 ]----------------------------------------------*/
        FIND FIRST ext-embarque-imp NO-LOCK
            WHERE  ext-embarque-imp.cod-estabel = embarque-imp.cod-estabel
            AND    ext-embarque-imp.embarque    = embarque-imp.embarque NO-ERROR.
        IF  AVAIL  ext-embarque-imp THEN DO:
            IF  VALID-HANDLE(wh-fill-ctnr-im0545) THEN DO:
                CASE ext-embarque-imp.conteiner:
                    WHEN 1 THEN ASSIGN wh-fill-ctnr-im0545:SCREEN-VALUE = "Contˆiner de 20":U.
                    WHEN 2 THEN ASSIGN wh-fill-ctnr-im0545:SCREEN-VALUE = "Contˆiner de 40":U.
                    WHEN 3 THEN ASSIGN wh-fill-ctnr-im0545:SCREEN-VALUE = "Contˆiner de 20/40":U.
                    WHEN 4 THEN ASSIGN wh-fill-ctnr-im0545:SCREEN-VALUE = "NOR 20":U.
                    WHEN 5 THEN ASSIGN wh-fill-ctnr-im0545:SCREEN-VALUE = "NOR 40":U.
                    WHEN 6 THEN ASSIGN wh-fill-ctnr-im0545:SCREEN-VALUE = "Carga Solta":U.
                    OTHERWISE ASSIGN wh-fill-ctnr-im0545:SCREEN-VALUE = "":U.
                END CASE.                                                                        .
            END.
            IF  VALID-HANDLE(wh-qt-ctnr-im0545) THEN DO:
                ASSIGN wh-qt-ctnr-im0545:SCREEN-VALUE = STRING(ext-embarque-imp.qtd-conteiner).
            END.

            IF  ext-embarque-imp.conteiner = 3 /* Contˆiner de 20/40 */ THEN DO:
                IF  VALID-HANDLE(wh-qt2-ctnr-im0545) THEN DO:
                    ASSIGN wh-qt2-ctnr-im0545:VISIBLE      = TRUE.
                           wh-qt2-ctnr-im0545:SCREEN-VALUE = STRING(ext-embarque-imp.qtd2-conteiner).
                END.
            END.
            ELSE DO:
                IF  VALID-HANDLE(wh-qt2-ctnr-im0545) THEN DO:
                    ASSIGN wh-qt2-ctnr-im0545:HIDDEN = TRUE.
                END.
            END.

            IF  ext-embarque-imp.conteiner = 6 /* Carga Solta */ THEN DO:
                IF  VALID-HANDLE(wh-qt2-ctnr-im0545) THEN DO:
                    ASSIGN wh-qt2-ctnr-im0545:HIDDEN = TRUE.
                END.
                IF  VALID-HANDLE(tx-volume-ctnr-im0545) THEN DO:
                    ASSIGN tx-volume-ctnr-im0545:VISIBLE = TRUE.
                END.
            END.
            ELSE DO:
                IF  VALID-HANDLE(tx-volume-ctnr-im0545) THEN DO:
                    ASSIGN tx-volume-ctnr-im0545:VISIBLE = FALSE.
                END.
            END.
        END.
        ELSE DO:
            IF  VALID-HANDLE(wh-fill-ctnr-im0545) THEN ASSIGN wh-fill-ctnr-im0545:SCREEN-VALUE = "".
            IF  VALID-HANDLE(wh-qt-ctnr-im0545)   THEN ASSIGN wh-qt-ctnr-im0545:SCREEN-VALUE   = "0".

            IF  VALID-HANDLE(tx-volume-ctnr-im0545) THEN DO:
                ASSIGN tx-volume-ctnr-im0545:VISIBLE = FALSE.
            END.

            IF  VALID-HANDLE(wh-qt2-ctnr-im0545) THEN DO:
                ASSIGN wh-qt2-ctnr-im0545:HIDDEN = TRUE.
            END.
        END.
        /*----------------------------------------------[ Referente chamado 26630 ]---*/
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
END PROCEDURE. /* tela-upc */
