/***********************************************************************
**  Programa..: UPC\CD0222A-UPC.P
**  Autor.....: Isac Abrahao
**  Data......: 23/08/2021
**  Descricao.: Inclusao de desconto no produto composto - Salesforce
************************************************************************/
def input param p-ind-event        as char          no-undo.
def input param p-ind-object       as char          no-undo.
def input param p-wgh-object       as handle        no-undo.
def input param p-wgh-frame        as widget-handle no-undo.
def input param p-cod-table        as char          no-undo.
def input param p-row-table        as rowid         no-undo.

DEF NEW GLOBAL SHARED VAR wh-txt-dec1-cd0222a  AS WIDGET-HANDLE   NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-dec1-cd0222a      AS WIDGET-HANDLE   NO-UNDO.

DEF VAR wh-objeto AS WIDGET-HANDLE NO-UNDO.

DEF VAR c-objeto  AS CHAR  NO-UNDO.


/*
MESSAGE "event" p-ind-event SKIP
        "obj type" p-ind-object SKIP
        "obj" c-objeto SKIP
        "table" p-cod-table VIEW-AS ALERT-BOX.*/


IF p-ind-event = "INITIALIZE" THEN DO:

   IF NOT VALID-HANDLE(wh-objeto) THEN DO:
   
      RUN busca-handle(INPUT 'qt-filho',
                       INPUT  p-wgh-frame,
                       OUTPUT wh-objeto).
      
      IF VALID-HANDLE(wh-objeto) THEN DO:
      
         CREATE TEXT wh-txt-dec1-cd0222a
         ASSIGN FRAME        = p-wgh-frame
                FORMAT       = "x(12)"
                WIDTH        = 9
                SCREEN-VALUE = "% Desconto:"
                ROW          = wh-objeto:ROW + 0.1
                COL          = wh-objeto:COL + 25
                VISIBLE      = YES.
    
         CREATE FILL-IN wh-dec1-cd0222a
         ASSIGN FRAME             = p-wgh-frame
               SIDE-LABEL-HANDLE  = wh-txt-dec1-cd0222a:HANDLE
                DATA-TYPE         = "DECIMAL" 
                FORMAT            = ">>9.99" 
                SCREEN-VALUE     = '0'
                WIDTH             = wh-objeto:WIDTH
                HEIGHT            = wh-objeto:HEIGHT
                ROW               = wh-objeto:ROW
                COL               = wh-txt-dec1-cd0222a:COL + wh-txt-dec1-cd0222a:WIDTH                 VISIBLE           = YES
                SENSITIVE         = YES.
         
      END.
   END.
END.

IF VALID-HANDLE(wh-txt-dec1-cd0222a) THEN
   ASSIGN wh-txt-dec1-cd0222a:SCREEN-VALUE = '% Desconto:'.


IF p-ind-event = "ADD" THEN DO:
   IF VALID-HANDLE(wh-dec1-cd0222a) THEN
      ASSIGN wh-dec1-cd0222a:SCREEN-VALUE = "0".
END.


IF p-ind-event = "ASSIGN" THEN DO:
   IF VALID-HANDLE(wh-dec1-cd0222a) THEN DO:
      FIND prod-composto WHERE ROWID(prod-composto) = p-row-table EXCLUSIVE-LOCK NO-ERROR.
    
      IF AVAIL prod-composto THEN DO:
         IF DEC(wh-dec1-cd0222a:SCREEN-VALUE) > 100 THEN DO:
            MESSAGE 'Desconto nao pode ser superior a 100%'
                VIEW-AS ALERT-BOX ERROR BUTTONS OK.
            RETURN ERROR.
         END.

         ASSIGN prod-composto.dec-1 = DEC(wh-dec1-cd0222a:SCREEN-VALUE).
      END.
   END.    
END.

IF p-ind-event = "DISPLAY" THEN DO:
   IF VALID-HANDLE(wh-dec1-cd0222a) THEN DO:
      FIND prod-composto WHERE ROWID(prod-composto) = p-row-table EXCLUSIVE-LOCK NO-ERROR.
    
      IF AVAIL prod-composto THEN DO:
         ASSIGN wh-dec1-cd0222a:SCREEN-VALUE = STRING(prod-composto.dec-1).
      END.
   END.    
END.




PROCEDURE busca-handle:
    DEF INPUT  PARAM p-nome     AS CHAR.
    DEF INPUT  PARAM p-frame    AS WIDGET-HANDLE.
    DEF OUTPUT PARAM p-object   AS WIDGET-HANDLE.
    DEF VAR h-frame             AS WIDGET-HANDLE.

    DEF VAR wh-objeto           AS WIDGET-HANDLE.
    
    ASSIGN h-frame = p-frame:FIRST-CHILD.

    DO WHILE VALID-HANDLE(h-frame):

        IF h-frame:TYPE <> "field-group" THEN DO: 

            /*
            IF h-frame:Type = "frame" THEN 
            DO:
                RUN busca-handle(INPUT  p-nome,
                                 INPUT  h-frame,
                                 OUTPUT wh-objeto).

                IF wh-objeto <> ? THEN  
                DO:
                    ASSIGN p-object = wh-objeto.
                    LEAVE.
                END.
            END.*/
           
            IF h-frame:NAME = p-nome THEN DO:
                ASSIGN p-object = h-frame.
                LEAVE.
            END.

            ASSIGN h-frame = h-frame:NEXT-SIBLING.
        END.
        ELSE
            ASSIGN h-frame = h-frame:FIRST-CHILD.
    END.

END PROCEDURE.
