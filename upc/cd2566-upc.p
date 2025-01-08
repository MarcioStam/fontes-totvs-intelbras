/***************************************************************************
Programa      : upc/cd2566-upc.p
Programa base : CD2566
Vers∆o        : 2.04.000 - Desenvolvimento
******************************************************************************/
{utp/ut-glob.i}

{esp/es0018.i}

/* Definicao de parametros */    
DEF INPUT PARAM p-ind-event  AS CHAR          NO-UNDO.
DEF INPUT PARAM p-ind-object AS CHAR          NO-UNDO.
DEF INPUT PARAM p-wgh-object AS HANDLE        NO-UNDO.
DEF INPUT PARAM p-wgh-frame  AS WIDGET-HANDLE NO-UNDO.
DEF INPUT PARAM p-cod-table  AS CHAR          NO-UNDO.
DEF INPUT PARAM p-row-table  AS ROWID         NO-UNDO.
DEF         VAR c-objeto     AS CHAR          NO-UNDO.

DEF         VAR c-pto-base   AS c             NO-UNDO.


DEF NEW GLOBAL SHARED VAR h-cd2566-narrativa                       AS HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR h-cd2566-nome-comex                      AS HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR h-cd2566-local-origem-destino-comex      AS HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR h-cd2566-nome-comex-txt                  AS HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR h-cd2566-local-origem-destino-comex-txt  AS HANDLE NO-UNDO.

ASSIGN 
   c-objeto = ENTRY(NUM-ENTRIES(p-wgh-object:PRIVATE-DATA, "~/"),p-wgh-object:PRIVATE-DATA, "~/")
   c-objeto = ENTRY(NUM-ENTRIES(c-objeto, "~\"), c-objeto, "~\")
   c-objeto = REPLACE(c-objeto, "'", "").

/*
MESSAGE "EVENTO" p-ind-event  SKIP
        "OBJETO" p-ind-object SKIP
        "NOME OBJ" c-objeto   SKIP
        "FRAME" p-wgh-frame   SKIP
        "TABELA" p-cod-table  SKIP
        "ROWID" string(p-row-table) 
        VIEW-AS ALERT-BOX.
*/


IF  p-ind-event  = "BEFORE-INITIALIZE" 
AND p-ind-object = "CONTAINER" 
THEN DO:
   RUN pi_busca_widget (INPUT p-wgh-frame,
                        INPUT "narrativa",
                       OUTPUT h-cd2566-narrativa).

   h-cd2566-narrativa:HEIGHT = 3.

   CREATE TEXT h-cd2566-nome-comex-txt
   ASSIGN 
       FRAME        = p-wgh-frame
       FORMAT       = "x(17)"
       WIDTH        = 18
       SCREEN-VALUE = "Nome Ponto Comex:"
       ROW          = h-cd2566-narrativa:ROW + 3.7
       COL          = 21
       VISIBLE      = YES.

   /*
   CREATE FILL-IN h-cd2566-nome-comex
   ASSIGN 
       FRAME              = p-wgh-frame
       SIDE-LABEL-HANDLE  = h-cd2566-nome-comex-txt:HANDLE
       DATA-TYPE          = "character"
       FORMAT             = "x(50)"
       WIDTH              = 55
       HEIGHT             = 0.88
       ROW                = h-cd2566-narrativa:ROW + 3.5
       COL                = 35 
       VISIBLE            = YES
       SENSITIVE          = NO.
   */
   RUN pi-pto-base.

   CREATE COMBO-BOX h-cd2566-nome-comex
   ASSIGN 
      FRAME           = p-wgh-frame
      DATA-TYPE       = "character"
      FORMAT          = "x(50)" 
      WIDTH           = 55
      ROW             = h-cd2566-narrativa:ROW + 3.5
      COL             = 35 
      VISIBLE         = YES
      SENSITIVE       = NO
      LIST-ITEMS      = c-pto-base
      INNER-LINES     = NUM-ENTRIES(c-pto-base)
      SCREEN-VALUE    = ENTRY(1,c-pto-base)
      .


   CREATE TEXT h-cd2566-local-origem-destino-comex-txt
   ASSIGN 
       FRAME        = p-wgh-frame
       FORMAT       = "x(21)"
       WIDTH        = 25
       SCREEN-VALUE = "Local Origem/Destino:"
       ROW          = h-cd2566-narrativa:ROW + 4.7
       COL          = 20
       VISIBLE      = YES.

   CREATE FILL-IN h-cd2566-local-origem-destino-comex
   ASSIGN 
       FRAME              = p-wgh-frame
       SIDE-LABEL-HANDLE  = h-cd2566-local-origem-destino-comex-txt:HANDLE
       DATA-TYPE          = "character"
       FORMAT             = "x(50)"
       WIDTH              = 55
       HEIGHT             = 0.88
       ROW                = h-cd2566-narrativa:ROW + 4.5
       COL                = 35 
       VISIBLE            = YES
       SENSITIVE          = NO.
END.

IF  p-ind-event  = "AFTER-DISPLAY"       
AND p-ind-object = "CONTAINER"        
AND VALID-HANDLE(h-cd2566-nome-comex) 
THEN DO:
   RUN pi-pto-base.
   ASSIGN 
      h-cd2566-nome-comex                :SCREEN-VALUE = "" //ENTRY(1,c-pto-base)
      h-cd2566-local-origem-destino-comex:SCREEN-VALUE = "".
   FIND FIRST pto-contr NO-LOCK 
        WHERE ROWID(pto-contr) = p-row-table 
        NO-ERROR.
   IF AVAIL pto-contr 
   THEN DO:
      FIND FIRST int-pto-contr NO-LOCK
           WHERE int-pto-contr.cod-pto-contr = pto-contr.cod-pto-contr 
           NO-ERROR.
      IF AVAIL int-pto-contr 
      THEN ASSIGN
         h-cd2566-nome-comex                :SCREEN-VALUE = int-pto-contr.nome-comex                
         h-cd2566-local-origem-destino-comex:SCREEN-VALUE = int-pto-contr.local-origem-destino-comex
         .
   END.
END.

IF  p-ind-event  = "AFTER-ASSIGN"       
AND p-ind-object = "CONTAINER"        
AND VALID-HANDLE(h-cd2566-nome-comex) 
THEN DO:
   FIND FIRST pto-contr NO-LOCK 
        WHERE ROWID(pto-contr) = p-row-table 
        NO-ERROR.
   IF AVAIL pto-contr 
   THEN DO:
      FIND FIRST int-pto-contr
           WHERE int-pto-contr.cod-pto-contr = pto-contr.cod-pto-contr 
           NO-ERROR.
      IF NOT AVAIL int-pto-contr 
      THEN DO:
         CREATE int-pto-contr.
         ASSIGN
            int-pto-contr.cod-pto-contr = pto-contr.cod-pto-contr.
      END.
      ASSIGN
         int-pto-contr.nome-comex                 = h-cd2566-nome-comex                :SCREEN-VALUE 
         int-pto-contr.local-origem-destino-comex = h-cd2566-local-origem-destino-comex:SCREEN-VALUE 
         .
   END.
END.

IF  p-ind-event  = "AFTER-ENABLE"       
AND p-ind-object = "CONTAINER"        
AND VALID-HANDLE(h-cd2566-local-origem-destino-comex) 
THEN ASSIGN 
   h-cd2566-nome-comex                :SENSITIVE = YES
   h-cd2566-local-origem-destino-comex:SENSITIVE = YES.

IF  p-ind-event  = "AFTER-DISABLE"       
AND p-ind-object = "CONTAINER"        
AND VALID-HANDLE(h-cd2566-local-origem-destino-comex) 
THEN ASSIGN 
   h-cd2566-nome-comex                :SENSITIVE = NO
   h-cd2566-local-origem-destino-comex:SENSITIVE = NO.

RETURN "OK".

PROCEDURE pi_busca_widget:
    DEF INPUT  PARAM p_wh_frame     AS WIDGET-HANDLE    NO-UNDO.
    DEF INPUT  PARAM p_nome_obj     AS CHARACTER        NO-UNDO.
    DEF OUTPUT PARAM p_wh_objeto    AS WIDGET-HANDLE    NO-UNDO.

    DEF VAR h_hwd                   AS WIDGET-HANDLE    NO-UNDO.
                                     
    ASSIGN 
       h_hwd       = p_wh_frame:FIRST-CHILD
       p_wh_objeto = ?.

    DO WHILE VALID-HANDLE(h_hwd):
       IF  h_hwd:TYPE <> "field-group" 
       AND h_hwd:TYPE <> "frame"       
       THEN DO:
          IF h_hwd:NAME = p_nome_obj 
          THEN DO:
             ASSIGN 
                p_wh_objeto = h_hwd.
             LEAVE.
          END. /* if h_hwd:name = p_nome_obj */
       END.
       ELSE DO:
          IF h_hwd:NAME = p_nome_obj 
          THEN DO:
              ASSIGN 
                 p_wh_objeto = h_hwd.
              LEAVE.
          END. /* if h_hwd:name = p_nome_obj */

          RUN pi_busca_widget (INPUT h_hwd,
                               INPUT p_nome_obj,
                               OUTPUT p_wh_objeto).

          IF  VALID-HANDLE(p_wh_objeto) 
          THEN RETURN.
       END. /* else if h_hwd:name = p_nome_obj */

       ASSIGN 
          h_hwd = h_hwd:NEXT-SIBLING.
    END. /* do while valid-handle(h_hwd) */
END PROCEDURE. /* pi_busca_widget */

PROCEDURE pi-pto-base:

    RUN esp/es0018p.p (INPUT "cd2566":U,
                       INPUT 1,
                       INPUT 0,
                       INPUT "":U,
                       OUTPUT TABLE tt-prog-ponto).

    FOR EACH tt-prog-ponto:
        ASSIGN
           c-pto-base = c-pto-base
                      + ","
                      + tt-prog-ponto.conteudo.
    END.

END.
