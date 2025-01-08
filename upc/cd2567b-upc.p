/***************************************************************************
Programa      : upc/cd2567b-upc.p
Programa base : cd2567b
VersÆo        : 2.04.000 - Desenvolvimento
******************************************************************************/
{utp/ut-glob.i}


/* Definicao de parametros */    
DEF           INPUT PARAM p-ind-event                     AS CHAR          NO-UNDO.
DEF           INPUT PARAM p-ind-object                    AS CHAR          NO-UNDO.
DEF           INPUT PARAM p-wgh-object                    AS HANDLE        NO-UNDO.
DEF           INPUT PARAM p-wgh-frame                     AS WIDGET-HANDLE NO-UNDO.
DEF           INPUT PARAM p-cod-table                     AS CHAR          NO-UNDO.
DEF           INPUT PARAM p-row-table                     AS ROWID         NO-UNDO.
DEF                   VAR c-objeto                        AS CHAR          NO-UNDO.

DEF NEW GLOBAL SHARED VAR h-cd2567b-cod-itiner            AS HANDLE        NO-UNDO.
DEF NEW GLOBAL SHARED VAR h-cd2567b-cod-pto-contr         AS HANDLE        NO-UNDO.

DEF NEW GLOBAL SHARED VAR h-cd2567b-btOK                  AS HANDLE        NO-UNDO.
DEF NEW GLOBAL SHARED VAR h-cd2567b-btSave-falso          AS HANDLE        NO-UNDO.
DEF NEW GLOBAL SHARED VAR h-cd2567b-btSave                AS HANDLE        NO-UNDO.
DEF NEW GLOBAL SHARED VAR h-cd2567b-btOK-falso            AS HANDLE        NO-UNDO.
DEF NEW GLOBAL SHARED VAR h-cd2567b-btCancel              AS HANDLE        NO-UNDO.

DEF NEW GLOBAL SHARED VAR h-cd2567b-flg-embarque2         AS HANDLE        NO-UNDO.
DEF NEW GLOBAL SHARED VAR h-cd2567b-flg-chegada1          AS HANDLE        NO-UNDO.
DEF NEW GLOBAL SHARED VAR h-cd2567b-flg-chegada2          AS HANDLE        NO-UNDO.
DEF NEW GLOBAL SHARED VAR h-cd2567b-flg-liberacao         AS HANDLE        NO-UNDO.
DEF NEW GLOBAL SHARED VAR h-cd2567b-flg-emissao-nf        AS HANDLE        NO-UNDO.
DEF NEW GLOBAL SHARED VAR h-cd2567b-flg-instrucao         AS HANDLE        NO-UNDO.

ASSIGN 
   c-objeto = ENTRY(NUM-ENTRIES(p-wgh-object:PRIVATE-DATA, "~/"),p-wgh-object:PRIVATE-DATA, "~/")
   c-objeto = ENTRY(NUM-ENTRIES(c-objeto, "~\"), c-objeto, "~\")
   c-objeto = REPLACE(c-objeto, "'", "").

DEF VAR i AS i      NO-UNDO. 
DEF VAR h AS HANDLE NO-UNDO. 
DEF VAR f AS HANDLE NO-UNDO. 
DEF VAR l AS c      NO-UNDO. 

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
                        INPUT "cod-itiner",
                       OUTPUT h-cd2567b-cod-itiner).

   RUN pi_busca_widget (INPUT p-wgh-frame,
                        INPUT "cod-pto-contr",
                       OUTPUT h-cd2567b-cod-pto-contr).

   RUN pi_busca_widget (INPUT p-wgh-frame,
                        INPUT "btOK",
                       OUTPUT h-cd2567b-btOK).
   
   RUN pi_busca_widget (INPUT p-wgh-frame,
                        INPUT "btSave",
                       OUTPUT h-cd2567b-btSave).

   RUN pi_busca_widget (INPUT p-wgh-frame,
                        INPUT "btCancel",
                       OUTPUT h-cd2567b-btCancel).


   IF VALID-HANDLE(h-cd2567b-btOK)
   THEN DO:
       CREATE BUTTON h-cd2567b-btOK-falso
           ASSIGN 
              FRAME       = h-cd2567b-btOK:FRAME
              WIDTH       = h-cd2567b-btOK:WIDTH
              HEIGHT      = h-cd2567b-btOK:HEIGHT
              LABEL       = h-cd2567b-btOK:LABEL + " *"
              ROW         = h-cd2567b-btOK:ROW
              COLUMN      = h-cd2567b-btOK:COLUMN
              TOOLTIP     = h-cd2567b-btOK:TOOLTIP
              HELP        = h-cd2567b-btOK:HELP
              NAME        = "falso-" + h-cd2567b-btOK:NAME
              AUTO-GO     = YES
              SENSITIVE   = YES
              VISIBLE     = YES
              FONT        = h-cd2567b-btOK:FONT
           TRIGGERS:
              ON 'choose':U PERSISTENT RUN upc/cd2567b-upc.p ("btOK"      ,
                                                              "btx"       ,
                                                              p-wgh-object,
                                                              p-wgh-frame ,
                                                              p-cod-table ,
                                                              p-row-table 
                                                            ).
           END TRIGGERS.

       h-cd2567b-btOK      :SENSITIVE = NO.
       h-cd2567b-btOK-falso:MOVE-AFTER-TAB-ITEM(h-cd2567b-btOK) NO-ERROR.
   END.

   IF VALID-HANDLE(h-cd2567b-btSave)
   THEN DO:
       CREATE BUTTON h-cd2567b-btSave-falso
           ASSIGN 
              FRAME       = h-cd2567b-btSave:FRAME
              WIDTH       = h-cd2567b-btSave:WIDTH
              HEIGHT      = h-cd2567b-btSave:HEIGHT
              LABEL       = h-cd2567b-btSave:LABEL + " *"
              ROW         = h-cd2567b-btSave:ROW
              COLUMN      = h-cd2567b-btSave:COLUMN
              TOOLTIP     = h-cd2567b-btSave:TOOLTIP
              HELP        = h-cd2567b-btSave:HELP
              NAME        = "falso-" + h-cd2567b-btSave:NAME
              SENSITIVE   = YES
              VISIBLE     = YES
              FONT        = h-cd2567b-btSave:FONT
           TRIGGERS:
              ON 'choose':U PERSISTENT RUN upc/cd2567b-upc.p ("btSave"      ,
                                                              "btx"       ,
                                                              p-wgh-object,
                                                              p-wgh-frame ,
                                                              p-cod-table ,
                                                              p-row-table 
                                                            ).
           END TRIGGERS.

       
       h-cd2567b-btSave      :SENSITIVE = NO.
       h-cd2567b-btSave-falso:MOVE-AFTER-TAB-ITEM(h-cd2567b-btSave) NO-ERROR.
   END.

   ASSIGN
      l = "l-despacho,l-embarque,l-desembarque,l-chegada,l-recebimento,l-solicita-li".
   DO i = 1 TO NUM-ENTRIES(l):
      RUN pi_busca_widget (INPUT p-wgh-frame,
                           INPUT ENTRY(i,l),
                          OUTPUT h).

      IF ENTRY(i,l) = "l-solicita-li"
      THEN DO:
         ASSIGN
            h:COL   = h:COL - 31
            h:LABEL = "Invoice".
         NEXT.
      END.

      IF VALID-HANDLE(h) 
      THEN ASSIGN
         h:COL = h:COL - 18
         .
      IF ENTRY(i,l) = "l-embarque"
      THEN DO:
         h:LABEL = "Embarque 1".
         CREATE TOGGLE-BOX h-cd2567b-flg-embarque2
         ASSIGN 
             FRAME        = p-wgh-frame
             LABEL        = "Embaque 2"
             WIDTH        = 12
             ROW          = h:ROW
             COL          = h:COL + 12
             VISIBLE      = YES.
         CREATE TOGGLE-BOX h-cd2567b-flg-chegada1
         ASSIGN 
             FRAME        = p-wgh-frame
             LABEL        = "Chegada 1"
             WIDTH        = 12
             ROW          = h:ROW
             COL          = h:COL + 25
             VISIBLE      = YES.
         CREATE TOGGLE-BOX h-cd2567b-flg-chegada2
         ASSIGN 
             FRAME        = p-wgh-frame
             LABEL        = "Chegada 2"
             WIDTH        = 10
             ROW          = h:ROW
             COL          = h:COL + 37
             VISIBLE      = YES.
      END.
      IF ENTRY(i,l) = "l-chegada"
      THEN DO:
         h:WIDTH = 19.
         CREATE TOGGLE-BOX h-cd2567b-flg-instrucao
         ASSIGN 
             FRAME        = p-wgh-frame
             LABEL        = "Instru‡Æo"
             WIDTH        = 12
             ROW          = h:ROW
             COL          = h:COL + 24.7
             VISIBLE      = YES.
         CREATE TOGGLE-BOX h-cd2567b-flg-liberacao 
         ASSIGN 
             FRAME        = p-wgh-frame
             LABEL        = "Libera‡Æo"
             WIDTH        = 12
             ROW          = h:ROW
             COL          = h:COL + 37.7
             VISIBLE      = YES.
         CREATE TOGGLE-BOX h-cd2567b-flg-emissao-nf
         ASSIGN 
             FRAME        = p-wgh-frame
             LABEL        = "EmissÆo NF"
             WIDTH        = 10
             ROW          = h:ROW
             COL          = h:COL + 49.7
             VISIBLE      = YES.
      END.
   END.

END.


IF  p-ind-event  = "AFTER-ADD" 
AND p-ind-object = "CONTAINER" 
THEN DO:
    ASSIGN
       h-cd2567b-flg-embarque2 :CHECKED = NO
       h-cd2567b-flg-chegada1  :CHECKED = NO
       h-cd2567b-flg-chegada2  :CHECKED = NO
       h-cd2567b-flg-instrucao :CHECKED = NO
       h-cd2567b-flg-liberacao :CHECKED = NO
       h-cd2567b-flg-emissao-nf:CHECKED = NO
       .                                   
END.

IF  p-ind-event  = "AFTER-ENABLE" //p-ind-event  = "AFTER-DISPLAY"       
AND p-ind-object = "CONTAINER"        
THEN DO:
   ASSIGN
      h-cd2567b-flg-embarque2 :CHECKED = NO
      h-cd2567b-flg-chegada1  :CHECKED = NO
      h-cd2567b-flg-chegada2  :CHECKED = NO
      h-cd2567b-flg-instrucao :CHECKED = NO
      h-cd2567b-flg-liberacao :CHECKED = NO
      h-cd2567b-flg-emissao-nf:CHECKED = NO
      .                                   
   FIND FIRST itinerario NO-LOCK 
        WHERE itinerario.cod-itiner = h-cd2567b-cod-itiner:INPUT-VALUE
        NO-ERROR.
   IF AVAIL itinerario 
   THEN DO:
       FIND FIRST int-itinerario NO-LOCK
            WHERE int-itinerario.cod-itiner = h-cd2567b-cod-itiner:INPUT-VALUE
            NO-ERROR.
       IF AVAIL int-itinerario 
       AND h-cd2567b-cod-pto-contr:INPUT-VALUE > 0
       THEN ASSIGN
          h-cd2567b-flg-embarque2 :CHECKED = (int-itinerario.cdn-pto-embarque2  = h-cd2567b-cod-pto-contr:INPUT-VALUE)
          h-cd2567b-flg-chegada1  :CHECKED = (int-itinerario.cdn-pto-chegada1   = h-cd2567b-cod-pto-contr:INPUT-VALUE)
          h-cd2567b-flg-chegada2  :CHECKED = (int-itinerario.cdn-pto-chegada2   = h-cd2567b-cod-pto-contr:INPUT-VALUE)
          h-cd2567b-flg-instrucao :CHECKED = (int-itinerario.cdn-pto-instrucao  = h-cd2567b-cod-pto-contr:INPUT-VALUE)
          h-cd2567b-flg-liberacao :CHECKED = (int-itinerario.cdn-pto-liberacao  = h-cd2567b-cod-pto-contr:INPUT-VALUE)
          h-cd2567b-flg-emissao-nf:CHECKED = (int-itinerario.cdn-pto-emissao-nf = h-cd2567b-cod-pto-contr:INPUT-VALUE)
          .

       /*
       MESSAGE 

          "int-itinerario.cdn-pto-embarque2 " int-itinerario.cdn-pto-embarque2  (int-itinerario.cdn-pto-embarque2  = h-cd2567b-cod-pto-contr:INPUT-VALUE)  SKIP
          "int-itinerario.cdn-pto-chegada1  " int-itinerario.cdn-pto-chegada1   (int-itinerario.cdn-pto-chegada1   = h-cd2567b-cod-pto-contr:INPUT-VALUE)  SKIP
          "int-itinerario.cdn-pto-chegada2  " int-itinerario.cdn-pto-chegada2   (int-itinerario.cdn-pto-chegada2   = h-cd2567b-cod-pto-contr:INPUT-VALUE)  SKIP
          "int-itinerario.cdn-pto-instrucao " int-itinerario.cdn-pto-instrucao  (int-itinerario.cdn-pto-instrucao  = h-cd2567b-cod-pto-contr:INPUT-VALUE)  SKIP
          "int-itinerario.cdn-pto-liberacao " int-itinerario.cdn-pto-liberacao  (int-itinerario.cdn-pto-liberacao  = h-cd2567b-cod-pto-contr:INPUT-VALUE)  SKIP
          "int-itinerario.cdn-pto-emissao-nf" int-itinerario.cdn-pto-emissao-nf (int-itinerario.cdn-pto-emissao-nf = h-cd2567b-cod-pto-contr:INPUT-VALUE)  SKIP

          VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
       */

   END.
END.


IF  p-ind-event  = "BEFORE-ENABLE"       
AND p-ind-object = "CONTAINER"        
THEN ASSIGN 
   h-cd2567b-flg-embarque2 :CHECKED = NO
   h-cd2567b-flg-chegada1  :CHECKED = NO
   h-cd2567b-flg-chegada2  :CHECKED = NO
   h-cd2567b-flg-instrucao :CHECKED = NO
   h-cd2567b-flg-liberacao :CHECKED = NO
   h-cd2567b-flg-emissao-nf:CHECKED = NO
   .                                   


IF  p-ind-event  = "AFTER-ENABLE"       
AND p-ind-object = "CONTAINER"        
THEN ASSIGN 
   h-cd2567b-flg-embarque2 :SENSITIVE = YES
   h-cd2567b-flg-chegada1  :SENSITIVE = YES
   h-cd2567b-flg-chegada2  :SENSITIVE = YES
   h-cd2567b-flg-instrucao :SENSITIVE = YES
   h-cd2567b-flg-liberacao :SENSITIVE = YES
   h-cd2567b-flg-emissao-nf:SENSITIVE = YES
   h-cd2567b-btSave-falso  :SENSITIVE = h-cd2567b-btSave:SENSITIVE.
   .


IF  p-ind-object = "btx" 
THEN DO:
   FIND FIRST int-itinerario 
        WHERE int-itinerario.cod-itiner = h-cd2567b-cod-itiner:INPUT-VALUE
        NO-ERROR.
   IF NOT AVAIL int-itinerario
   THEN DO:
      CREATE int-itinerario.
      ASSIGN 
         int-itinerario.cod-itiner = h-cd2567b-cod-itiner:INPUT-VALUE.
   END.

   IF  h-cd2567b-flg-chegada1  :CHECKED  = NO
   AND int-itinerario.cdn-pto-chegada1   = h-cd2567b-cod-pto-contr:INPUT-VALUE
   THEN ASSIGN
      int-itinerario.cdn-pto-chegada1    = 0.

   IF  h-cd2567b-flg-embarque2 :CHECKED  = NO
   AND int-itinerario.cdn-pto-embarque2  = h-cd2567b-cod-pto-contr:INPUT-VALUE
   THEN ASSIGN
      int-itinerario.cdn-pto-embarque2   = 0.

   IF  h-cd2567b-flg-chegada2  :CHECKED  = NO
   AND int-itinerario.cdn-pto-chegada2   = h-cd2567b-cod-pto-contr:INPUT-VALUE
   THEN ASSIGN 
      int-itinerario.cdn-pto-chegada2    = 0.

   IF  h-cd2567b-flg-liberacao :CHECKED  = NO
   AND int-itinerario.cdn-pto-liberacao  = h-cd2567b-cod-pto-contr:INPUT-VALUE
   THEN ASSIGN
      int-itinerario.cdn-pto-liberacao   = 0.

   IF  h-cd2567b-flg-emissao-nf:CHECKED  = NO
   AND int-itinerario.cdn-pto-emissao-nf = h-cd2567b-cod-pto-contr:INPUT-VALUE
   THEN ASSIGN
      int-itinerario.cdn-pto-emissao-nf  = 0.

   IF  h-cd2567b-flg-instrucao :CHECKED  = NO
   AND int-itinerario.cdn-pto-instrucao  = h-cd2567b-cod-pto-contr:INPUT-VALUE
   THEN ASSIGN
      int-itinerario.cdn-pto-instrucao   = 0.



   IF h-cd2567b-flg-chegada1  :CHECKED
   THEN ASSIGN
      int-itinerario.cdn-pto-chegada1   = h-cd2567b-cod-pto-contr:INPUT-VALUE.
   IF h-cd2567b-flg-embarque2 :CHECKED
   THEN ASSIGN
      int-itinerario.cdn-pto-embarque2  = h-cd2567b-cod-pto-contr:INPUT-VALUE.
   IF h-cd2567b-flg-chegada2  :CHECKED
   THEN ASSIGN
      int-itinerario.cdn-pto-chegada2   = h-cd2567b-cod-pto-contr:INPUT-VALUE.
   IF h-cd2567b-flg-liberacao :CHECKED
   THEN ASSIGN
      int-itinerario.cdn-pto-liberacao  = h-cd2567b-cod-pto-contr:INPUT-VALUE.
   IF h-cd2567b-flg-emissao-nf:CHECKED
   THEN ASSIGN
      int-itinerario.cdn-pto-emissao-nf = h-cd2567b-cod-pto-contr:INPUT-VALUE.
   IF h-cd2567b-flg-instrucao :CHECKED
   THEN ASSIGN
      int-itinerario.cdn-pto-instrucao  = h-cd2567b-cod-pto-contr:INPUT-VALUE.

   /*
   MESSAGE 1                                 SKIP
       'h-cd2567b-flg-embarque2 :CHECKED   ' h-cd2567b-flg-embarque2 :CHECKED      SKIP
       'h-cd2567b-cod-pto-contr:INPUT-VALUE' h-cd2567b-cod-pto-contr:INPUT-VALUE   SKIP
       'int-itinerario.cdn-pto-embarque2   ' int-itinerario.cdn-pto-embarque2      SKIP
       VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
   */
   IF  p-ind-event  = "btOK" 
   THEN DO:
      APPLY "choose" TO h-cd2567b-btOK.
      IF VALID-HANDLE(h-cd2567b-btCancel) 
      THEN APPLY "choose" TO h-cd2567b-btCancel.
   END.
   IF  p-ind-event  = "btSave" 
   THEN APPLY "choose" TO h-cd2567b-btSave.

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

