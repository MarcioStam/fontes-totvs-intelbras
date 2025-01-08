DEFINE INPUT PARAM p-ind-event                         AS CHARACTER        NO-UNDO.
DEFINE INPUT PARAM p-ind-object                        AS CHARACTER        NO-UNDO.
DEFINE INPUT PARAM p-wgh-object                        AS HANDLE           NO-UNDO.
DEFINE INPUT PARAM p-wgh-frame                         AS WIDGET-HANDLE    NO-UNDO.
DEFINE INPUT PARAM p-cod-table                         AS CHARACTER        NO-UNDO.
DEFINE INPUT PARAM p-row-table                         AS ROWID            NO-UNDO.

DEFINE VARIABLE c-objeto                            AS CHARACTER     NO-UNDO.
DEF NEW GLOBAL SHARED VAR h-categoria-cd0701        AS HANDLE        NO-UNDO.
DEF NEW GLOBAL SHARED VAR h-atividade-cd0701        AS HANDLE        NO-UNDO.
DEF NEW GLOBAL SHARED VAR tx-class-canal-cd0701     AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR h-class-canal-cd0701      AS HANDLE        NO-UNDO.
DEF NEW GLOBAL SHARED VAR h-des-class-canal-cd0701  AS HANDLE        NO-UNDO.
DEF NEW GLOBAL SHARED VAR h-cod-gr-cli-cd0701       AS HANDLE        NO-UNDO.
DEF NEW GLOBAL SHARED VAR h-upc-cd0701              AS HANDLE        NO-UNDO.
DEF NEW GLOBAL SHARED VAR h-window-cd0701           AS HANDLE        NO-UNDO.

/* Grupo Canais */
DEF NEW GLOBAL SHARED VAR tx-grCanais-cd0701     AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR h-grCanais-cd0701      AS HANDLE        NO-UNDO.

ASSIGN c-objeto = ENTRY(NUM-ENTRIES(p-wgh-object:FILE-NAME,"~/"), p-wgh-object:FILE-NAME,"~/").

IF  p-ind-event  = "BEFORE-INITIALIZE"
AND p-ind-object = "VIEWER " 
AND c-objeto     = "v01ad129.w" THEN DO:
    RUN busca-handle(INPUT  p-wgh-frame,
                     INPUT  "cod-gr-cli",
                     OUTPUT h-cod-gr-cli-cd0701).
END.

IF  p-ind-event  = "ADD"
AND p-ind-object = "VIEWER " 
AND c-objeto     = "v02ad129.w" THEN DO:
    CREATE TEXT tx-class-canal-cd0701
    ASSIGN FRAME        = h-atividade-cd0701:FRAME
           FORMAT       = "x(14)"   
           WIDTH        = 9
           SCREEN-VALUE = "Classificaá∆o:"
           ROW          = h-atividade-cd0701:ROW + 1.15
           COL          = h-atividade-cd0701:COL - 9.7
           VISIBLE      = YES.
END.

IF  p-ind-event  = "BEFORE-INITIALIZE"
AND p-ind-object = "VIEWER " 
AND c-objeto     = "v02ad129.w" THEN DO:

    IF VALID-HANDLE(p-wgh-frame) THEN DO:
        ASSIGN p-wgh-frame:HEIGHT = p-wgh-frame:HEIGHT + 1.5.
    END.

    RUN busca-handle(INPUT  p-wgh-frame,
                     INPUT  "categoria",
                     OUTPUT h-categoria-cd0701).

    RUN busca-handle(INPUT  p-wgh-frame,
                     INPUT  "atividade",
                     OUTPUT h-atividade-cd0701).

    RUN upc/cd0701-upc.p PERSISTENT SET h-upc-cd0701(INPUT "",            
                                                     INPUT "",            
                                                     INPUT p-wgh-object,  
                                                     INPUT p-wgh-frame,   
                                                     INPUT "",            
                                                     INPUT p-row-table).

    CREATE TEXT tx-class-canal-cd0701
    ASSIGN FRAME        = h-atividade-cd0701:FRAME
           FORMAT       = "x(14)"   
           WIDTH        = 9
           SCREEN-VALUE = "Classificaá∆o:"
           ROW          = h-atividade-cd0701:ROW + 1.15
           COL          = h-atividade-cd0701:COL - 9.7
           VISIBLE      = YES.

    CREATE FILL-IN h-class-canal-cd0701
    ASSIGN FRAME             = h-atividade-cd0701:FRAME
           DATA-TYPE         = "character"
           FORMAT            = "x(36)"
           WIDTH             = 10
           HEIGHT            = h-atividade-cd0701:HEIGHT-CHARS
           ROW               = h-atividade-cd0701:ROW + 1
           COL               = h-atividade-cd0701:COL
           VISIBLE           = YES
           SENSITIVE         = NO
           SIDE-LABEL-HANDL  = tx-class-canal-cd0701
    TRIGGERS:
       ON "LEAVE":U PERSISTENT RUN pi-class-canal IN h-upc-cd0701.
       ON "F5":U PERSISTENT RUN upc/cd0701-upczoom.p.
       ON "MOUSE-SELECT-DBLCLICK":U PERSISTENT RUN upc/cd0701-upczoom.p.
    END TRIGGERS.

    h-class-canal-cd0701:LOAD-MOUSE-POINTER('image/lupa.cur').

    CREATE FILL-IN h-des-class-canal-cd0701
    ASSIGN FRAME             = h-class-canal-cd0701:FRAME
           DATA-TYPE         = "character"
           FORMAT            = "x(36)"
           WIDTH             = 30
           HEIGHT            = h-class-canal-cd0701:HEIGHT-CHARS
           ROW               = h-class-canal-cd0701:ROW
           COL               = h-class-canal-cd0701:COL + 10.5
           VISIBLE           = YES
           SENSITIVE         = NO.
    
    /*******/
    CREATE TEXT tx-grCanais-cd0701
    ASSIGN FRAME        = h-categoria-cd0701:FRAME
           FORMAT       = "x(14)"   
           WIDTH        = 9
           SCREEN-VALUE = "Gp Canais:"
           ROW          = h-categoria-cd0701:ROW + 0.15
           COL          = h-categoria-cd0701:COL + 7
           VISIBLE      = YES.

    CREATE FILL-IN h-grCanais-cd0701
    ASSIGN FRAME             = h-categoria-cd0701:FRAME
           DATA-TYPE         = "character"
           FORMAT            = "x(3)"
           WIDTH             = 4
           HEIGHT            = h-categoria-cd0701:HEIGHT-CHARS
           ROW               = h-categoria-cd0701:ROW
           COL               = tx-grCanais-cd0701:COL + 8
           VISIBLE           = YES
           SENSITIVE         = NO
           SIDE-LABEL-HANDL  = tx-grCanais-cd0701
    TRIGGERS:
       ON "F5":U PERSISTENT RUN upc/cd0701-upczoom2.p.
       ON "MOUSE-SELECT-DBLCLICK":U PERSISTENT RUN upc/cd0701-upczoom2.p.
    END TRIGGERS.

    h-grCanais-cd0701:LOAD-MOUSE-POINTER('image/lupa.cur').
    /*******/

END.

IF  p-ind-event  = "ENABLE"
AND p-ind-object = "VIEWER " 
AND c-objeto     = "v02ad129.w" THEN DO:
    ASSIGN h-class-canal-cd0701:SENSITIVE = YES
           h-grCanais-cd0701   :SENSITIVE = YES.
END.

IF  p-ind-event  = "VALIDATE"
AND p-ind-object = "VIEWER " 
AND c-objeto     = "v02ad129.w" THEN DO:

    IF h-class-canal-cd0701:SCREEN-VALUE <> "" THEN DO:
        FIND FIRST int-class-canal NO-LOCK
             WHERE int-class-canal.codigo-classificacao = h-class-canal-cd0701:SCREEN-VALUE NO-ERROR.
    
        IF NOT AVAIL int-class-canal THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW",
                               INPUT 17006,
                               INPUT "Classificaá∆o n∆o cadastrada, informe uma classificaá∆o v†lida ou deixe o campo em branco").
            RETURN "NOK".
        END.

        IF CAN-FIND (FIRST gr-cli-class-canal
                     WHERE gr-cli-class-canal.codigo-classificacao = h-class-canal-cd0701:SCREEN-VALUE
                       AND gr-cli-class-canal.cod-gr-cli <> int(h-cod-gr-cli-cd0701:SCREEN-VALUE)) THEN DO:
    
            RUN utp/ut-msgs.p (INPUT "SHOW",
                               INPUT 17006,
                               INPUT "Classificaá∆o j† cadastrada para outro grupo de clientes").
            RETURN "NOK".
        END.
    END.

    /* Grupo Canais*/
    IF h-grCanais-cd0701:SCREEN-VALUE <> "" THEN DO:
        FIND FIRST grupo-canais NO-LOCK
             WHERE grupo-canais.cod-gr-canais = int(h-grCanais-cd0701:SCREEN-VALUE) NO-ERROR.
    
        IF NOT AVAIL grupo-canais THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW",
                               INPUT 17006,
                               INPUT "Codigo Grupo Canais n∆o cadastrado.~~Informe um Codigo Grupo Canais ou deixe o campo em branco").
            RETURN "NOK".
        END.

    END.

END.

IF  p-ind-event  = "ASSIGN"
AND p-ind-object = "VIEWER " 
AND c-objeto     = "v02ad129.w" THEN DO:

    FIND FIRST gr-cli-class-canal EXCLUSIVE-LOCK
         WHERE gr-cli-class-canal.cod-gr-cli = int(h-cod-gr-cli-cd0701:SCREEN-VALUE) NO-ERROR.

    IF AVAIL gr-cli-class-canal THEN DO:
        ASSIGN gr-cli-class-canal.codigo-classificacao = h-class-canal-cd0701:SCREEN-VALUE.
    END.
    ELSE DO:
        CREATE gr-cli-class-canal.
        ASSIGN gr-cli-class-canal.cod-gr-cli           = int(h-cod-gr-cli-cd0701:SCREEN-VALUE)
               gr-cli-class-canal.codigo-classificacao = h-class-canal-cd0701:SCREEN-VALUE.
    END.

    /* Grupo Canais Vendas*/
    FIND FIRST grupo-canais-clientes EXCLUSIVE-LOCK
         WHERE grupo-canais-clientes.cod-gr-cli = int(h-cod-gr-cli-cd0701:SCREEN-VALUE) NO-ERROR.
    IF NOT AVAIL grupo-canais-clientes 
    THEN DO:
        CREATE grupo-canais-clientes.
        ASSIGN grupo-canais-clientes.cod-gr-cli = int(h-cod-gr-cli-cd0701:SCREEN-VALUE) .
    END.
    ASSIGN grupo-canais-clientes.cod-gr-canais  = int(h-grCanais-cd0701:SCREEN-VALUE).
    FIND CURRENT grupo-canais-clientes NO-LOCK NO-ERROR.
END.

IF  p-ind-event  = "DISABLE"
AND p-ind-object = "VIEWER " 
AND c-objeto     = "v02ad129.w" THEN DO:
    ASSIGN h-class-canal-cd0701:SENSITIVE = NO
           h-grCanais-cd0701   :SENSITIVE = NO.
END.

IF  p-ind-event  = "DISPLAY" AND 
    p-ind-object = "VIEWER " AND 
    c-objeto     = "v02ad129.w" 
THEN DO:

    IF  VALID-HANDLE(tx-grCanais-cd0701)
    THEN
        ASSIGN tx-grCanais-cd0701:VISIBLE = YES.

    FIND FIRST gr-cli-class-canal EXCLUSIVE-LOCK
         WHERE gr-cli-class-canal.cod-gr-cli = int(h-cod-gr-cli-cd0701:SCREEN-VALUE) NO-ERROR.

    IF AVAIL gr-cli-class-canal THEN DO:
        ASSIGN h-class-canal-cd0701:SCREEN-VALUE = gr-cli-class-canal.codigo-classificacao.
    END.
    ELSE 
        ASSIGN h-class-canal-cd0701:SCREEN-VALUE = "".

    RUN pi-class-canal IN h-upc-cd0701.

    /**********************************/
    FIND FIRST grupo-canais-clientes NO-LOCK 
         WHERE grupo-canais-clientes.cod-gr-cli = int(h-cod-gr-cli-cd0701:SCREEN-VALUE) NO-ERROR.
    IF AVAIL grupo-canais-clientes 
    THEN
        ASSIGN h-grCanais-cd0701:SCREEN-VALUE = string(grupo-canais-clientes.cod-gr-canais).
    ELSE 
        ASSIGN h-grCanais-cd0701:SCREEN-VALUE = ''.
END.

IF  p-ind-event  = "DELETE"
AND p-ind-object = "VIEWER " 
AND c-objeto     = "v02ad129.w" THEN DO:
    FIND FIRST gr-cli-class-canal EXCLUSIVE-LOCK
         WHERE gr-cli-class-canal.cod-gr-cli = int(h-cod-gr-cli-cd0701:SCREEN-VALUE) NO-ERROR.

    IF AVAIL gr-cli-class-canal THEN DO:
        IF gr-cli-class-canal.codigo-classificacao <> "" THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW",
                               INPUT 17006,
                               INPUT "Grupo de Cliente possui Classificaá∆o informada.").
            RETURN "NOK".
        END.
        ELSE DO:
            DELETE gr-cli-class-canal.
        END.
    END.
END.

PROCEDURE busca-handle:
    DEFINE INPUT  PARAMETER p-wgh-frame  AS WIDGET-HANDLE    NO-UNDO.  /* Handle da Frame Principal do programa */
    DEFINE INPUT  PARAMETER p-nome-obj   AS CHARACTER        NO-UNDO.  /* Nome do objeto que se dejesa achar o handle */
    DEFINE OUTPUT PARAMETER p-handl-obj  AS WIDGET-HANDLE    NO-UNDO.  /* Handle do Componente */

    DEFINE VARIABLE h-aux   AS WIDGET-HANDLE        NO-UNDO.
    DEFINE VARIABLE h-ant   AS WIDGET-HANDLE        NO-UNDO.

    /* Frame Principal */
    ASSIGN h-aux = p-wgh-frame
           p-handl-obj = ?.
    bl-desce:
    REPEAT:
        IF h-aux:NAME <> p-nome-obj THEN DO:
            ASSIGN h-ant = h-aux.
            ASSIGN h-aux = h-aux:FIRST-CHILD NO-ERROR.
            IF NOT VALID-HANDLE(h-aux) THEN
                ASSIGN h-aux = h-ant:NEXT-SIBLING.
            IF NOT VALID-HANDLE(h-aux) THEN DO:
                bl-sobe:
                REPEAT:
                    ASSIGN h-aux = h-ant:PARENT.
                    IF h-aux = p-wgh-frame THEN
                        LEAVE bl-desce.
                    ASSIGN h-ant = h-aux
                           h-aux = h-aux:NEXT-SIBLING.
                    IF VALID-HANDLE(h-aux) THEN
                        LEAVE bl-sobe.
                END.
            END.
        END.
        ELSE DO:
            ASSIGN p-handl-obj = h-aux.
            LEAVE bl-desce.
        END.  
    END.
END PROCEDURE.

PROCEDURE pi-class-canal:
    FIND FIRST int-class-canal NO-LOCK
         WHERE int-class-canal.codigo-classificacao = h-class-canal-cd0701:SCREEN-VALUE NO-ERROR.

    IF AVAIL int-class-canal THEN DO:
        ASSIGN h-des-class-canal-cd0701:SCREEN-VALUE = int-class-canal.nome.
    END.
    ELSE 
        ASSIGN h-des-class-canal-cd0701:SCREEN-VALUE = "".
END PROCEDURE.
