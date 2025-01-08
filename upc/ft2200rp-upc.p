/*
  Autor: Antonio Carlos Gallo - Intelbras 
   Data: 05-08-08
Assunto: Criado para marcar o flag- cancela titulo = yes 


   Alteracao.: 29 de junho de 2009
   Autor.....: Renersson Ricardo Agostini - GATI - Gestao e Tecnologia em TI
   Objetivo..: Controle e validacoes necessarias para o processo de NFE.
---------------------------------------------------------------------------- */


def input param p-ind-event      as char          no-undo.
def input param p-ind-object     as char          no-undo.
def input param p-wgh-object     as handle        no-undo.
def input param p-wgh-frame      as widget-handle no-undo.
def input param p-cod-table      as char          no-undo.
def input param p-row-table      as rowid         no-undo.

DEF VAR h-frame                                    AS HANDLE        NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-nota          AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-serie         AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-cod-estabel   AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-frame4        AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-cancel-tit    AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wgh-desc-cancela AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wgh-dt-cancela   AS WIDGET-HANDLE NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE wh-objeto      AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-old-button  AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-new-button  AS WIDGET-HANDLE NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE wgh-nr-protocolo AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wgh-protocolo-siare    AS WIDGET-HANDLE NO-UNDO.
def new global shared VAR wh-envia-email          as WIDGET-HANDLE NO-UNDO.


IF  p-ind-object  = "CONTAINER" THEN DO: 
    /*c-objeto      = "PROGRAMA.W" */  

   IF p-ind-event = "BEFORE-INITIALIZE" THEN DO:
      ASSIGN wh-objeto = p-wgh-frame:FIRST-CHILD NO-ERROR.
   
      DO  WHILE VALID-HANDLE(wh-objeto):
   
          IF wh-objeto:NAME = "btOK" THEN
              ASSIGN wh-old-button = wh-objeto.
   
          IF  wh-objeto:TYPE = "field-group" THEN
              ASSIGN wh-objeto = wh-objeto:FIRST-CHILD.
          ELSE ASSIGN wh-objeto = wh-objeto:NEXT-SIBLING.
      END.
   END. 

   IF p-ind-event = "AFTER-INITIALIZE " THEN DO:
       CREATE BUTTON wh-new-button
       ASSIGN FRAME      = wh-old-button:FRAME
              WIDTH      = wh-old-button:WIDTH    
              HEIGHT     = wh-old-button:HEIGHT   
              ROW        = wh-old-button:ROW      
              COL        = wh-old-button:COL
              LABEL      = wh-old-button:LABEL    
              VISIBLE    = wh-old-button:VISIBLE  
              SENSITIVE  = wh-old-button:SENSITIVE
       TRIGGERS:
           ON CHOOSE PERSISTENT RUN upc\ft2201a-upc.p.
       END TRIGGERS.
       
       IF VALID-HANDLE(wh-new-button) THEN
           wh-new-button:LOAD-IMAGE(wh-old-button:IMAGE).
   
       IF VALID-HANDLE(wh-new-button) THEN DO:
           wh-new-button:MOVE-TO-TOP().
       END.
   
   END.

   IF  p-ind-event   = "BEFORE-INITIALIZE" THEN DO: 
        
        ASSIGN h-frame = p-wgh-frame:FIRST-CHILD.
        ASSIGN h-frame = h-frame:FIRST-CHILD.
        DO  WHILE VALID-HANDLE(h-frame):
            IF  h-frame:TYPE <> "field-group" THEN DO:
                CASE h-frame:NAME:
                    WHEN "fPage4"        THEN DO: 

                        ASSIGN wh-frame4 = h-frame:FIRST-CHILD.
                        ASSIGN wh-frame4 = wh-frame4:FIRST-CHILD.
                        DO  WHILE VALID-HANDLE(wh-frame4):
                            IF  wh-frame4:TYPE <> "field-group" THEN DO:
                                CASE wh-frame4:NAME:
                                    WHEN "nr-nota-fis"        THEN ASSIGN wh-nota          = wh-frame4.
                                    WHEN "serie"              THEN ASSIGN wh-serie         = wh-frame4. 
                                    WHEN "cod-estabel"        THEN ASSIGN wh-cod-estabel   = wh-frame4.
                                    WHEN "rs-cancela-titulos" THEN ASSIGN wh-cancel-tit    = wh-frame4.
                                    WHEN "dt-cancela"         THEN ASSIGN wgh-dt-cancela   = wh-frame4.
                                    WHEN "desc-cancela"       THEN ASSIGN wgh-desc-cancela = wh-frame4.
                                END CASE.
                            END.
                            ASSIGN wh-frame4 = wh-frame4:NEXT-SIBLING NO-ERROR.
                        END. 
                    END.
                    /*WHEN "fPage6" THEN DO:*/
                      
                END. /*CASE h-frame:NAME:*/
                ASSIGN h-frame = h-frame:NEXT-SIBLING NO-ERROR.
            END. /* IF  h-frame:TYPE <> "field-group" THEN DO: */ 
            ELSE LEAVE.

        END. /* DO  WHILE VALID-HANDLE(h-frame): */ 
        IF VALID-HANDLE(wh-cod-estabel) THEN
           ON 'LEAVE':U OF wh-cod-estabel PERSISTENT RUN upc\ft2200-upc-a.p.

    END. /* IF  p-ind-event   = "BEFORE-INITIALIZE" THEN DO: */ 

    IF  p-ind-event   = "AFTER-INITIALIZE" THEN DO: 
        ASSIGN wh-cancel-tit:CHECKED = YES. 
    
/*         CREATE TOGGLE-BOX wh-envia-email                   */
/*         ASSIGN  FRAME              = p-wgh-frame           */
/* /*              FORMAT             = w-nr-linha:FORMAT  */ */
/*                 WIDTH              = 11.57                 */
/*                 HEIGHT             = 0.83                  */
/*                 ROW                = 2.8                   */
/*                 COL                = 68                    */
/*                 BGCOLOR            = ?                     */
/*                 VISIBLE            = YES                   */
/*                 SENSITIVE          = YES                   */
/*                 NAME               = 'Linha Produ»’o'      */
/*                 FONT               = 1                     */
/*                 LABEL              = "Envia Email?".       */
        
        DEFINE VARIABLE prot-c AS CHARACTER FORMAT "x(25)":U 
         VIEW-AS FILL-IN 
         SIZE 25 BY .88 NO-UNDO.
        
        create fill-in wgh-protocolo-siare
        assign frame        = p-wgh-frame
               DATA-TYPE    = "character"
               width        = 25
               col          = 20
               row          = 13.93
               height       = 0.88
               visible      = NO
               sensitive    = TRUE
               format       = "x(25)"
               name         = "nr-protocolo". 
        
        Create Text wgh-nr-protocolo
        Assign Row          = 13.83
               Column       = 10.57
               Frame        = p-wgh-frame
               Sensitive    = No
               Visible      = NO
               Height-Chars = 0.88
               Width-Chars  = 9.43
               FORMAT       = "x(13)"
               Screen-Value = "Nr Protocolo:". 
    END.

END. /* IF  p-ind-object  = "CONTAINER" THEN DO:  */ 






