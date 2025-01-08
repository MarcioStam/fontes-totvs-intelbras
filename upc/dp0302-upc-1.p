/***********************************************************************
**  Programa..: UPC\DP0302-UPC-1.P
**  Autor.....: SENSUS Tecnologia
**  Data......: ABRIL/2013 - Desenvolvimento
**  Descricao.: 
**  Vers’o....: 001 03/04/2013
**                  Desenvolvimento Programa
************************************************************************/

/*---[ PAR¶METROS ]---------------------------------------------------------------------------------------------------------------*/
def input param p-ind-event        as char          no-undo.
def input param p-ind-object       as char          no-undo.
def input param p-wgh-object       as handle        no-undo.
def input param p-wgh-frame        as widget-handle no-undo.
def input param p-cod-table        as char          no-undo.
def input param p-row-table        as rowid         no-undo.                    

/*---[ VARIµVEIS ]----------------------------------------------------------------------------------------------------------------*/
{utp/ut-glob.i}
{esp/es0018.i}

DEF VAR c-objeto        AS CHAR          NO-UNDO.
DEF VAR h-frame         AS HANDLE        NO-UNDO.
DEF VAR h-frame-1       AS HANDLE        NO-UNDO.
DEF VAR h-object        AS HANDLE        NO-UNDO.
DEF VAR wh-btAprovaR    AS WIDGET-HANDLE NO-UNDO.
DEF VAR wh-btAbreR      AS WIDGET-HANDLE NO-UNDO.
DEF VAR wh-button-fake  AS WIDGET-HANDLE NO-UNDO.
DEF VAR wh-button-fake2 AS WIDGET-HANDLE NO-UNDO.
DEF VAR wh-button-fake3 AS WIDGET-HANDLE NO-UNDO.
DEF VAR wh-campo        AS WIDGET-HANDLE NO-UNDO.

DEF VAR iLinha          AS INTEGER       NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE g-dp0302-btAprovarE               AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE g-dp0302-btAprovarE-fake          AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE g-dp0302-epc                      AS HANDLE        NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE g-dp0302-br-table                 AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE g-dp0302-br-table-item-dp         AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE g-dp0302-br-table-num-proces-item AS WIDGET-HANDLE NO-UNDO.

assign c-objeto = entry(num-entries(p-wgh-object:file-name,"~/"), p-wgh-object:file-name,"~/").    

DEF TEMP-TABLE tt-dp-estrut NO-UNDO LIKE dp-estrut
    FIELD rw-dp-estrut AS ROWID.

/*---[ EVENTOS ]------------------------------------------------------------------------------------------------------------------*/
IF  p-ind-event  = "AFTER-INITIALIZE" AND
    p-ind-object = "CONTAINER"        THEN DO:

    /* DESABILITA O BOTAO APROVA ROTEIRO, PARA EVITAR PROBLEMA NA OPERACAO ENTRE ENGENHARIA E DESENVOLVIMENTO DE PRODUTO */
    RUN busca-handle(INPUT p-wgh-frame,
                     INPUT "btAprovaR",
                     OUTPUT wh-btAprovaR).
    
    IF  VALID-HANDLE(wh-btAprovaR) THEN DO:
        CREATE BUTTON wh-button-fake
        ASSIGN FRAME        = p-wgh-frame
               WIDTH        = wh-btAprovaR:WIDTH
               HEIGHT       = wh-btAprovaR:HEIGHT
               ROW          = wh-btAprovaR:ROW
               LABEL        = wh-btAprovaR:LABEL
               COLUMN       = wh-btAprovaR:COLUMN
               SENSITIVE    = NO
               VISIBLE      = YES
               TOOLTIP      = wh-btAprovaR:TOOLTIP
               HELP         = wh-btAprovaR:HELP.

    IF VALID-HANDLE(wh-btAprovaR) THEN 
        ASSIGN wh-btAprovaR:SENSITIVE = FALSE
               wh-btAprovaR:WIDTH  = 0.1
               wh-btAprovaR:HEIGHT = 0.1.

        wh-button-fake:MOVE-TO-TOP().
    END. /* IF  VALID-HANDLE(wh-btAprovaR) */

    /* DESABILITA O BOTAO APROVA ROTEIRO, PARA EVITAR PROBLEMA NA OPERACAO ENTRE ENGENHARIA E DESENVOLVIMENTO DE PRODUTO */
    RUN busca-handle(INPUT p-wgh-frame,
                     INPUT "btAbreR",
                     OUTPUT wh-btAbreR).
    
    IF  VALID-HANDLE(wh-btAbreR) THEN DO:
        CREATE BUTTON wh-button-fake2
        ASSIGN FRAME        = p-wgh-frame
               WIDTH        = wh-btAbreR:WIDTH
               HEIGHT       = wh-btAbreR:HEIGHT
               ROW          = wh-btAbreR:ROW
               LABEL        = wh-btAbreR:LABEL
               COLUMN       = wh-btAbreR:COLUMN
               SENSITIVE    = NO
               VISIBLE      = YES
               TOOLTIP      = wh-btAbreR:TOOLTIP
               HELP         = wh-btAbreR:HELP.

        IF VALID-HANDLE(wh-btAbreR) THEN 
            ASSIGN wh-btAbreR:SENSITIVE = FALSE
                   wh-btAbreR:WIDTH  = 0.1
                   wh-btAbreR:HEIGHT = 0.1.

        wh-button-fake2:MOVE-TO-TOP().

    END. /* IF  VALID-HANDLE(wh-btAbreR) */

    EMPTY TEMP-TABLE tt-prog-ponto.
    RUN esp/es0018p.p (INPUT "DP0302":U, /* Nome do programa */
                       INPUT 1,            /* Ponto do programa */
                       INPUT 0,
                       INPUT "":U,
                       OUTPUT TABLE tt-prog-ponto).

    FIND FIRST tt-prog-ponto WHERE 
               tt-prog-ponto.conteudo = c-seg-usuario
               NO-LOCK NO-ERROR.

    IF NOT AVAIL tt-prog-ponto 
    THEN DO:
       /**/
       
       RUN busca-handle(INPUT p-wgh-frame,
                        INPUT "btAbreE",
                        OUTPUT wh-campo).
       
       IF  VALID-HANDLE(wh-campo) THEN DO:
       
           CREATE BUTTON wh-button-fake3
           ASSIGN FRAME        = p-wgh-frame
                  WIDTH        = wh-campo:WIDTH
                  HEIGHT       = wh-campo:HEIGHT
                  ROW          = wh-campo:ROW
                  LABEL        = wh-campo:LABEL
                  COLUMN       = wh-campo:COLUMN
                  SENSITIVE    = NO
                  VISIBLE      = YES
                  TOOLTIP      = wh-campo:TOOLTIP
                  HELP         = wh-campo:HELP.
       
           IF VALID-HANDLE(wh-campo) THEN 
               ASSIGN wh-campo:SENSITIVE = FALSE
                      wh-campo:WIDTH  = 0.1
                      wh-campo:HEIGHT = 0.1.
       
           wh-button-fake3:MOVE-TO-TOP().
       
       END.
       
       /**/
    END.

    RUN busca-handle(INPUT p-wgh-frame,
                     INPUT "btAprovaE",
                     OUTPUT wh-campo).

    wh-campo:SENSITIVE = FALSE.

    RUN busca-handle(INPUT p-wgh-frame,
                     INPUT "btSuspende",
                     OUTPUT wh-campo).

    wh-campo:SENSITIVE = FALSE.

    /* btAprovarE fake para renumerar a sequencia dos componentes antes de aprovar */    
    RUN upc/dp0302-upc-1.p PERSISTENT SET g-dp0302-epc (INPUT "", 
                                                        INPUT "", 
                                                        INPUT p-wgh-object, 
                                                        INPUT p-wgh-frame, 
                                                        INPUT "", 
                                                        INPUT p-row-table).
    
    RUN busca-handle(INPUT p-wgh-frame,
                     INPUT "btAprovaE",
                     OUTPUT g-dp0302-btAprovarE).
    
    CREATE BUTTON g-dp0302-btAprovarE-fake
    ASSIGN FRAME   = p-wgh-frame           
           ROW     = g-dp0302-btAprovarE:ROW
           COLUMN  = g-dp0302-btAprovarE:COLUMN
           WIDTH   = g-dp0302-btAprovarE:WIDTH
           HEIGHT  = g-dp0302-btAprovarE:HEIGHT
           LABEL   = g-dp0302-btAprovarE:LABEL
           VISIBLE = YES
           SENSITIVE = YES.    
    g-dp0302-btAprovarE-fake:TOOLTIP = g-dp0302-btAprovarE:TOOLTIP.
    g-dp0302-btAprovarE-fake:MOVE-TO-TOP().
    ON 'CHOOSE' OF g-dp0302-btAprovarE-fake PERSISTENT RUN pi-choose-bt-AprovaE IN g-dp0302-epc.        

    RUN busca-handle(INPUT p-wgh-frame,
                     INPUT "br-table",
                     OUTPUT g-dp0302-br-table). 

    ASSIGN g-dp0302-br-table-item-dp         = g-dp0302-br-table:QUERY:GET-BUFFER-HANDLE("dp-proces-item":U):BUFFER-FIELD("item-dp":U)
           g-dp0302-br-table-num-proces-item = g-dp0302-br-table:QUERY:GET-BUFFER-HANDLE("dp-proces-item":U):BUFFER-FIELD("num-proces-item":U) NO-ERROR.
           
    /* Fim do btAprovarE Fake */
END. /* IF  p-ind-event  = "AFTER-INITIALIZE" */

    
PROCEDURE pi-choose-bt-AprovaE:

    DEFINE VARIABLE i-sequencia         AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i-num-var-estrutura AS INTEGER     NO-UNDO.

    IF NOT g-dp0302-btAprovarE:SENSITIVE THEN
        run utp/ut-msgs.p(input "show":U,
                          input 25548,
                          input "":U).

    EMPTY TEMP-TABLE tt-dp-estrut.

    DO iLinha = 1 TO g-dp0302-br-table:NUM-SELECTED-ROWS:

        g-dp0302-br-table:FETCH-SELECTED-ROW(iLinha).        

        assign i-num-var-estrutura = 10
               i-sequencia         = 10.
        
        for each  dp-estrut NO-LOCK
            where dp-estrut.item-dp         = g-dp0302-br-table-item-dp:BUFFER-VALUE 
              AND dp-estrut.num-proces-item = g-dp0302-br-table-num-proces-item:BUFFER-VALUE
            BY dp-estrut.es-codigo.                              
                            
            CREATE tt-dp-estrut.
            BUFFER-COPY dp-estrut EXCEPT sequencia TO tt-dp-estrut.
            assign tt-dp-estrut.sequencia    = i-sequencia
                   tt-dp-estrut.rw-dp-estrut = ROWID(dp-estrut)
                   i-sequencia = i-sequencia + i-num-var-estrutura.                               
        end.            
            
        DO TRANS:
            FOR EACH  tt-dp-estrut
                WHERE tt-dp-estrut.item-dp         = g-dp0302-br-table-item-dp:BUFFER-VALUE 
                  AND tt-dp-estrut.num-proces-item = g-dp0302-br-table-num-proces-item:BUFFER-VALUE:
                            
                FIND dp-estrut WHERE rowid(dp-estrut) = tt-dp-estrut.rw-dp-estrut EXCLUSIVE-LOCK NO-ERROR.            
                IF AVAIL dp-estrut THEN DO:                    

                    for each  dp-altern exclusive-lock 
                        where dp-altern.item-dp            = dp-estrut.item-dp 
                          AND dp-altern.num-proces-item    = dp-estrut.num-proces-item 
                          AND dp-altern.sequencia          = dp-estrut.sequencia
                          AND dp-altern.es-codigo          = dp-estrut.es-codigo:               
                    
                         assign dp-altern.sequencia        = tt-dp-estrut.sequencia.
                    end.

                    ASSIGN dp-estrut.sequencia = tt-dp-estrut.sequencia.

                    FIND FIRST dp-estrut NO-LOCK
                         WHERE rowid(dp-estrut) = tt-dp-estrut.rw-dp-estrut NO-ERROR.   

                    FIND FIRST dp-proces-item NO-LOCK
                         WHERE dp-proces-item.item-dp         = dp-estrut.es-codigo
                           AND dp-proces-item.num-proces-item = dp-estrut.num-proces-compon NO-ERROR.
                    IF AVAIL dp-proces-item THEN DO:
                        IF (dp-proces-item.ind-aprov = 1 OR /* 1- Aberto, 4- Roteiro Aprovado */
                            dp-proces-item.ind-aprov = 4) THEN DO:
                            
                            RUN pi-busca-estrutura(INPUT dp-estrut.es-codigo,
                                                   INPUT dp-estrut.num-proces-compon).
                        END.
                    END.
                END.
            END.
        END.
    END.

    APPLY 'choose' TO g-dp0302-btAprovarE.

END PROCEDURE.

PROCEDURE pi-busca-estrutura:

    DEFINE INPUT PARAM p-item   AS CHAR NO-UNDO.
    DEFINE INPUT PARAM p-versao AS INT  NO-UNDO.
        

    DEFINE VARIABLE i-sequencia         AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i-num-var-estrutura AS INTEGER     NO-UNDO.

    assign i-num-var-estrutura = 10
           i-sequencia         = 10.
    
    for each  dp-estrut NO-LOCK
        where dp-estrut.item-dp         = p-item
          AND dp-estrut.num-proces-item = p-versao
        BY dp-estrut.es-codigo.
                        
        CREATE tt-dp-estrut.
        BUFFER-COPY dp-estrut EXCEPT sequencia TO tt-dp-estrut.
        assign tt-dp-estrut.sequencia    = i-sequencia
               tt-dp-estrut.rw-dp-estrut = ROWID(dp-estrut)
               i-sequencia = i-sequencia + i-num-var-estrutura.
    END.
    
    FOR EACH  tt-dp-estrut
        WHERE tt-dp-estrut.item-dp         = p-item
          AND tt-dp-estrut.num-proces-item = p-versao:
                    
        FIND dp-estrut WHERE rowid(dp-estrut) = tt-dp-estrut.rw-dp-estrut EXCLUSIVE-LOCK NO-ERROR.            
        IF AVAIL dp-estrut THEN DO:                    

            for each  dp-altern exclusive-lock 
                where dp-altern.item-dp            = dp-estrut.item-dp 
                  AND dp-altern.num-proces-item    = dp-estrut.num-proces-item 
                  AND dp-altern.sequencia          = dp-estrut.sequencia
                  AND dp-altern.es-codigo          = dp-estrut.es-codigo:               
            
                 assign dp-altern.sequencia        = tt-dp-estrut.sequencia.
            end.

            ASSIGN dp-estrut.sequencia = tt-dp-estrut.sequencia.

            FIND FIRST dp-estrut NO-LOCK
                 WHERE rowid(dp-estrut) = tt-dp-estrut.rw-dp-estrut NO-ERROR.   

            FIND FIRST dp-proces-item NO-LOCK
                 WHERE dp-proces-item.item-dp         = dp-estrut.es-codigo
                   AND dp-proces-item.num-proces-item = dp-estrut.num-proces-compon NO-ERROR.
            IF AVAIL dp-proces-item THEN DO:
                IF (dp-proces-item.ind-aprov = 1 OR /* 1- Aberto, 4- Roteiro Aprovado */
                    dp-proces-item.ind-aprov = 4) THEN DO:
                    
                    RUN pi-busca-estrutura(INPUT dp-estrut.es-codigo,
                                           INPUT dp-estrut.num-proces-compon).
                END.
            END.
        END.
    END.


END PROCEDURE.

/*---[ PROCEDURES ]---------------------------------------------------------------------------------------------------------------*/
PROCEDURE busca-handle:

    DEF INPUT  PARAM p-wgh-frame  AS WIDGET-HANDLE    NO-UNDO.  /* Handle da Frame Principal do programa */
    DEF INPUT  PARAM p-nome-obj   AS CHARACTER        NO-UNDO.  /* Nome do objeto que se dejesa achar o handle */
    DEF OUTPUT PARAM p-handl-obj  AS WIDGET-HANDLE    NO-UNDO.  /* Handle do Componente */

    DEF VAR h-aux   AS WIDGET-HANDLE        NO-UNDO.
    DEF VAR h-ant   AS WIDGET-HANDLE        NO-UNDO.
    
    /* Frame Principal */
    ASSIGN h-aux = p-wgh-frame
           p-handl-obj = ?.

    bl-desce:
    REPEAT:
        IF  h-aux:NAME <> p-nome-obj THEN DO:
            ASSIGN h-ant = h-aux
                   h-aux = h-aux:FIRST-CHILD NO-ERROR.
            
            IF NOT VALID-HANDLE(h-aux) THEN ASSIGN h-aux = h-ant:NEXT-SIBLING.

            IF  NOT VALID-HANDLE(h-aux) THEN DO:
                bl-sobe:
                REPEAT:
                    ASSIGN h-aux = h-ant:PARENT.

                    IF h-aux = p-wgh-frame THEN LEAVE bl-desce.

                    ASSIGN h-ant = h-aux
                           h-aux = h-aux:NEXT-SIBLING.

                    IF VALID-HANDLE(h-aux) THEN LEAVE bl-sobe.
                END.
            END.
        END.
        ELSE DO:
            ASSIGN p-handl-obj = h-aux.
            LEAVE bl-desce.
        END.
    END.
END PROCEDURE. /* PROCEDURE busca-handle: */


