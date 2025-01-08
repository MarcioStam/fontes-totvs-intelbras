/***************************************************************************
Programa      : upc/cd2567a-upc.p
Programa base : CD2567a
Vers∆o        : 2.04.000 - Desenvolvimento
******************************************************************************/
{utp/ut-glob.i}


/* Definicao de parametros */    
DEF INPUT PARAM p-ind-event  AS CHAR          NO-UNDO.
DEF INPUT PARAM p-ind-object AS CHAR          NO-UNDO.
DEF INPUT PARAM p-wgh-object AS HANDLE        NO-UNDO.
DEF INPUT PARAM p-wgh-frame  AS WIDGET-HANDLE NO-UNDO.
DEF INPUT PARAM p-cod-table  AS CHAR          NO-UNDO.
DEF INPUT PARAM p-row-table  AS ROWID         NO-UNDO.
DEF         VAR c-objeto     AS CHAR          NO-UNDO.

DEF NEW GLOBAL SHARED VAR h-cd2567a-btOK                  AS HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR h-cd2567a-btOK-falso            AS HANDLE NO-UNDO.

DEF NEW GLOBAL SHARED VAR h-cd2567a-btSave                AS HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR h-cd2567a-btSave-falso          AS HANDLE NO-UNDO.

DEF NEW GLOBAL SHARED VAR h-cd2567a-cod-itiner            AS HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR h-cd2567a-narrativa             AS HANDLE NO-UNDO.

DEF NEW GLOBAL SHARED VAR h-cd2567a-flg-integra-comex     AS HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR h-cd2567a-flg-integra-comex-txt AS HANDLE NO-UNDO.

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
                        INPUT "btOK",
                       OUTPUT h-cd2567a-btOK).
   
   RUN pi_busca_widget (INPUT p-wgh-frame,
                        INPUT "btSave",
                       OUTPUT h-cd2567a-btSave).

   RUN pi_busca_widget (INPUT p-wgh-frame,
                        INPUT "cod-itiner",
                       OUTPUT h-cd2567a-cod-itiner).

   RUN pi_busca_widget (INPUT p-wgh-frame,
                        INPUT "narrativa",
                       OUTPUT h-cd2567a-narrativa).


   IF VALID-HANDLE(h-cd2567a-btOK)
   THEN DO:
       CREATE BUTTON h-cd2567a-btOK-falso
           ASSIGN 
              FRAME       = h-cd2567a-btOK:FRAME
              WIDTH       = h-cd2567a-btOK:WIDTH
              HEIGHT      = h-cd2567a-btOK:HEIGHT
              LABEL       = h-cd2567a-btOK:LABEL + " *"
              ROW         = h-cd2567a-btOK:ROW
              COLUMN      = h-cd2567a-btOK:COLUMN
              TOOLTIP     = h-cd2567a-btOK:TOOLTIP
              HELP        = h-cd2567a-btOK:HELP
              NAME        = "falso-" + h-cd2567a-btOK:NAME
              SENSITIVE   = YES
              VISIBLE     = YES
              FONT        = h-cd2567a-btOK:FONT
           TRIGGERS:
              ON 'choose':U PERSISTENT RUN upc/cd2567a-upc.p ("btOK"      ,
                                                              "btx"       ,
                                                              p-wgh-object,
                                                              p-wgh-frame ,
                                                              p-cod-table ,
                                                              p-row-table 
                                                            ).
           END TRIGGERS.

       h-cd2567a-btOK      :SENSITIVE = NO.
       h-cd2567a-btOK-falso:MOVE-AFTER-TAB-ITEM(h-cd2567a-btOK) NO-ERROR.
   END.

   IF VALID-HANDLE(h-cd2567a-btSave)
   THEN DO:
       CREATE BUTTON h-cd2567a-btSave-falso
           ASSIGN 
              FRAME       = h-cd2567a-btSave:FRAME
              WIDTH       = h-cd2567a-btSave:WIDTH
              HEIGHT      = h-cd2567a-btSave:HEIGHT
              LABEL       = h-cd2567a-btSave:LABEL + " *"
              ROW         = h-cd2567a-btSave:ROW
              COLUMN      = h-cd2567a-btSave:COLUMN
              TOOLTIP     = h-cd2567a-btSave:TOOLTIP
              HELP        = h-cd2567a-btSave:HELP
              NAME        = "falso-" + h-cd2567a-btSave:NAME
              SENSITIVE   = YES
              VISIBLE     = YES
              FONT        = h-cd2567a-btSave:FONT
           TRIGGERS:
              ON 'choose':U PERSISTENT RUN upc/cd2567b-upc.p ("btSave"    ,
                                                              "btx"       ,
                                                              p-wgh-object,
                                                              p-wgh-frame ,
                                                              p-cod-table ,
                                                              p-row-table 
                                                            ).
           END TRIGGERS.

       
       h-cd2567a-btSave      :SENSITIVE = NO.
       h-cd2567a-btSave-falso:MOVE-AFTER-TAB-ITEM(h-cd2567a-btSave) NO-ERROR.
   END.


   CREATE TEXT h-cd2567a-flg-integra-comex-txt
   ASSIGN 
       FRAME        = p-wgh-frame
       FORMAT       = "x(25)"
       WIDTH        = 14
       SCREEN-VALUE = "Integra COMEX"
       ROW          = h-cd2567a-narrativa:ROW + .3
       COL          = h-cd2567a-narrativa:COL + 34.5
       VISIBLE      = YES.

   CREATE TOGGLE-BOX h-cd2567a-flg-integra-comex
   ASSIGN 
       FRAME        = p-wgh-frame
       WIDTH        = 2
       ROW          = h-cd2567a-narrativa:ROW + .2
       COL          = h-cd2567a-narrativa:COL + 32
       VISIBLE      = YES.

END.

IF  p-ind-event  = "AFTER-DISPLAY"       
AND p-ind-object = "CONTAINER"        
AND VALID-HANDLE(h-cd2567a-flg-integra-comex) 
THEN DO:
   ASSIGN 
      h-cd2567a-flg-integra-comex:CHECKED      = NO.
   FIND FIRST itinerario NO-LOCK 
        WHERE itinerario.cod-itiner = h-cd2567a-cod-itiner:INPUT-VALUE
        NO-ERROR.
   IF AVAIL itinerario 
   THEN DO:
       FIND FIRST int-itinerario NO-LOCK
            WHERE int-itinerario.cod-itiner = h-cd2567a-cod-itiner:INPUT-VALUE
            NO-ERROR.
       IF AVAIL int-itinerario 
       THEN ASSIGN
          h-cd2567a-flg-integra-comex:CHECKED = int-itinerario.log-integra-comex.
   END.
END.

IF  p-ind-event  = "AFTER-ENABLE"       
AND p-ind-object = "CONTAINER"        
AND VALID-HANDLE(h-cd2567a-flg-integra-comex) 
THEN ASSIGN 
   h-cd2567a-flg-integra-comex:SENSITIVE = YES
   h-cd2567a-btSave-falso     :SENSITIVE = h-cd2567a-btSave:SENSITIVE.

IF  p-ind-object = "btx"
//IF  p-ind-object = "CONTAINER"   
//AND p-ind-event  = "BEFORE-DESTROY-INTERFACE" 
THEN DO:
   FIND FIRST int-itinerario 
        WHERE int-itinerario.cod-itiner = h-cd2567a-cod-itiner:INPUT-VALUE
        NO-ERROR.
   IF NOT AVAIL int-itinerario
   THEN DO:
      CREATE int-itinerario.
      ASSIGN 
         int-itinerario.cod-itiner = h-cd2567a-cod-itiner:INPUT-VALUE.
   END.
   ASSIGN 
      int-itinerario.log-integra-comex = h-cd2567a-flg-integra-comex:CHECKED.
   RELEASE int-itinerario.
   IF  p-ind-event  = "btOK"
   THEN APPLY "CHOOSE" TO h-cd2567a-btOK.
   IF  p-ind-event  = "btSave"
   THEN APPLY "CHOOSE" TO h-cd2567a-btSave.
END.


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

