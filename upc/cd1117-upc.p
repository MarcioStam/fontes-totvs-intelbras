/***********************************************************************
**  Programa..: upc\ft0303-upc.p
**  Autor.....: Clayton Antunes
**  Data......: setembro/2006 - Desenvolvimento
**  Descricao.: 
**  Vers∆o....: 001 - 00/00/2002
**                  Desenvolvimento Programa
************************************************************************/

{utp/ut-glob.i}

def input param p-ind-event        as char          no-undo.
def input param p-ind-object       as char          no-undo.
def input param p-wgh-object       as handle        no-undo.
def input param p-wgh-frame        as widget-handle no-undo.
def input param p-cod-table        as char          no-undo.
def input param p-row-table        as rowid         no-undo.

DEFINE VARIABLE h-object           AS HANDLE        NO-UNDO.
DEFINE VARIABLE h-campo            AS HANDLE        NO-UNDO.

DEF NEW GLOBAL SHARED VAR tx-altura       AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR tx-largura      AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR tx-comprimento  AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR tx-misturar     AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR tx-mm1          AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR tx-mm2          AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR tx-mm3          AS WIDGET-HANDLE NO-UNDO.

DEF NEW GLOBAL SHARED VAR wh-label-volume AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-emite-roman  AS WIDGET-HANDLE NO-UNDO.


DEF NEW GLOBAL SHARED VAR wh-altura      AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-largura     AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-comprimento AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-de-volume   AS WIDGET-HANDLE NO-UNDO.


DEF NEW GLOBAL SHARED VAR wh-cod-imagem      AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR h-ft0303-upc       AS WIDGET-HANDLE NO-UNDO.


DEFINE NEW GLOBAL SHARED VARIABLE wh-button       AS WIDGET-HANDLE    NO-UNDO.


DEFINE VARIABLE c-char AS   CHAR.

assign c-char = entry(num-entries(p-wgh-object:file-name,"~/"), p-wgh-object:file-name,"~/").





/*
MESSAGE "Evento " p-ind-event  SKIP
        "Objeto " p-ind-object SKIP
        "Nome   " c-char SKIP
        "Tabela " p-cod-table  SKIP
        "Rowid  " STRING(p-row-table)
    VIEW-AS ALERT-BOX INFO BUTTONS OK. 
*/



IF  p-ind-event  = "INITIALIZE" THEN DO:    
    IF  NOT VALID-HANDLE(h-ft0303-upc) THEN
        RUN upc/ft0303-upc.p PERSISTENT SET h-ft0303-upc (INPUT "",
                                                            INPUT "",
                                                            INPUT p-wgh-object,
                                                            INPUT p-wgh-frame,
                                                            INPUT "",
                                                            INPUT p-row-table).

    ASSIGN h-object = p-wgh-frame:FIRST-CHILD.
    ASSIGN h-object = h-object:FIRST-CHILD.
            
    DO WHILE VALID-HANDLE(h-object):
        IF h-object:TYPE <> "field-group" THEN DO:
            IF h-object:NAME = 'cod-imagem' THEN DO:
                ASSIGN wh-cod-imagem = h-object.
                LEAVE.
            END.
            ASSIGN h-object = h-object:NEXT-SIBLING NO-ERROR.
        END.
        ELSE LEAVE.
    END.    



    IF p-wgh-frame:NAME = "f-main"  THEN DO:

        /* Altera label */
        CREATE TEXT tx-misturar
        ASSIGN FRAME        = p-wgh-frame
               FORMAT       = "x(20)"
               WIDTH        = 10
               SCREEN-VALUE = "Misturar itens"
               ROW          = 6.80
               COL          = 39.5
               VISIBLE      = YES.         

        
        /*  Cria campo e texto para a altura */
        CREATE TEXT tx-altura
        ASSIGN FRAME        = p-wgh-frame
               FORMAT       = "x(20)"
               WIDTH        = 20
               SCREEN-VALUE = "Altura:"
               ROW          = 4.73
               COL          = 63
               VISIBLE      = YES.   
        /*  Cria campo e texto para o comprimento */
        CREATE TEXT tx-comprimento
        ASSIGN FRAME        = p-wgh-frame
               FORMAT       = "x(20)"
               WIDTH        = 20
               SCREEN-VALUE = "Comprim:"
               ROW          = 6.73
               COL          = 61
               VISIBLE      = YES.
        CREATE TEXT tx-mm1
        ASSIGN FRAME        = p-wgh-frame
               FORMAT       = "x(4)"
               WIDTH        = 04
               SCREEN-VALUE = "mm"
               ROW          = 4.73
               COL          = 77
               VISIBLE      = YES.  
        CREATE TEXT tx-mm2
        ASSIGN FRAME        = p-wgh-frame
               FORMAT       = "x(4)"
               WIDTH        = 04
               SCREEN-VALUE = "mm"
               ROW          = 5.73
               COL          = 77
               VISIBLE      = YES.                  
        CREATE TEXT tx-mm3
        ASSIGN FRAME        = p-wgh-frame
               FORMAT       = "x(4)"
               WIDTH        = 04
               SCREEN-VALUE = "mm"
               ROW          = 6.73
               COL          = 77
               VISIBLE      = YES.  
        CREATE FILL-IN wh-altura
        ASSIGN FRAME             = p-wgh-frame
               DATA-TYPE         = "decimal"
               FORMAT            = ">>>9.99"
               WIDTH             = 8
               HEIGHT            = 0.88
               ROW               = 4.67
               COL               = 68
               VISIBLE           = YES
               SENSITIVE         = NO.
        

        /*  Cria campo e texto para a largura */
        CREATE TEXT tx-largura
        ASSIGN FRAME        = p-wgh-frame
               FORMAT       = "x(40)"
               WIDTH        = 20
               SCREEN-VALUE = "Kg              Largura:"
               ROW          = 5.73
               COL          = 54
               VISIBLE      = YES.

        CREATE FILL-IN wh-largura
        ASSIGN FRAME             = p-wgh-frame
               DATA-TYPE         = "decimal"
               FORMAT            = ">>>9.99"
               WIDTH             = 8
               HEIGHT            = 0.88
               ROW               = 5.67
               COL               = 68
               VISIBLE           = YES
               SENSITIVE         = NO.



    
        CREATE FILL-IN wh-comprimento
        ASSIGN FRAME             = p-wgh-frame
               DATA-TYPE         = "decimal"
               FORMAT            = ">>>9.99"
               WIDTH             = 8
               HEIGHT            = 0.88
               ROW               = 6.67
               COL               = 68
               VISIBLE           = YES
               SENSITIVE         = NO.



        IF VALID-HANDLE(wh-altura) THEN
           wh-altura:MOVE-AFTER-TAB-ITEM(wh-altura).

        IF VALID-HANDLE(wh-largura) THEN
           wh-largura:MOVE-AFTER-TAB-ITEM(wh-largura).

        IF VALID-HANDLE(wh-comprimento) THEN
           wh-comprimento:MOVE-AFTER-TAB-ITEM(wh-comprimento).

        RUN tela-upc (INPUT p-wgh-frame,
                      INPUT p-ind-Event,
                      INPUT "toggle-box",     /*** Type ***/
                      INPUT "emite-roman",         /*** Name ***/
                      INPUT NO,            /*** Apresenta Mensagem dos Objetos ***/
                      INPUT 1,             /*** Quando existir mais de um objeto com o mesmo nome ***/
                      OUTPUT wh-emite-roman).

        RUN tela-upc (INPUT p-wgh-frame,
                      INPUT p-ind-Event,
                      INPUT "fill-in",     /*** Type ***/
                      INPUT "de-volume",         /*** Name ***/
                      INPUT NO,            /*** Apresenta Mensagem dos Objetos ***/
                      INPUT 1,             /*** Quando existir mais de um objeto com o mesmo nome ***/
                      OUTPUT wh-de-volume).

        ASSIGN wh-de-volume:ROW = 7.67
               wh-de-volume:COL = 68
               wh-emite-roman:ROW = 6.67
               wh-de-volume:SENSITIVE   = NO.

        RUN tela-upc-literal (INPUT p-wgh-frame,
                      INPUT p-ind-Event,
                      INPUT "literal",     /*** Type ***/
                      INPUT "Volume",         /*** Name ***/
                      INPUT NO,            /*** Apresenta Mensagem dos Objetos ***/
                      INPUT 1,             /*** Quando existir mais de um objeto com o mesmo nome ***/
                      OUTPUT wh-label-volume).

        ASSIGN wh-label-volume:COL = 58
               wh-label-volume:ROW = 7.67
               wh-label-volume:WIDTH = 30
               wh-label-volume:SCREEN-VALUE = "Volume:                                           m3".

        ON "LEAVE"                 OF  wh-comprimento PERSISTENT RUN pi-calcula-volume IN h-ft0303-upc.
        ON "LEAVE"                 OF  wh-largura PERSISTENT RUN pi-calcula-volume IN h-ft0303-upc.
        ON "LEAVE"                 OF  wh-altura PERSISTENT RUN pi-calcula-volume IN h-ft0303-upc.

    END.
    

END.


IF p-ind-event = "ADD" THEN DO:
   IF p-wgh-frame:NAME = "f-main"  THEN DO:
      ASSIGN wh-altura:SENSITIVE         = YES
             wh-largura:SENSITIVE        = YES
             wh-comprimento:SENSITIVE    = YES
             tx-altura:SCREEN-VALUE      = "Altura:"
             tx-largura:SCREEN-VALUE     = "Kg              Largura:"
             tx-comprimento:SCREEN-VALUE = "Comprim:"
             tx-misturar:SCREEN-VALUE    = "Misturar itens"
             tx-mm1:SCREEN-VALUE    = "mm"
             tx-mm2:SCREEN-VALUE    = "mm"
             tx-mm3:SCREEN-VALUE    = "mm".

   END.

   /* Altera label */
/*    CREATE TEXT tx-misturar                  */
/*    ASSIGN FRAME        = p-wgh-frame        */
/*           FORMAT       = "x(20)"            */
/*           WIDTH        = 10                 */
/*           SCREEN-VALUE = "Misturar   itens" */
/*           ROW          = 6.80               */
/*           COL          = 39.5               */
/*           VISIBLE      = YES.               */

END.



IF p-ind-event = "ENABLE" THEN DO:
    IF p-wgh-frame:NAME = "f-main"  THEN DO:
       ASSIGN wh-altura:SENSITIVE = YES
              wh-largura:SENSITIVE  = YES
              wh-comprimento:SENSITIVE  = YES
                  wh-de-volume:SENSITIVE   = NO.
    END.
END.



IF p-ind-event = "CANCEL" OR p-ind-event = "DISABLE" THEN DO:
   ASSIGN wh-altura:SENSITIVE = NO
          wh-largura:SENSITIVE   = NO
          wh-comprimento:SENSITIVE   = NO
          tx-altura:VISIBLE = YES
          tx-largura:VISIBLE = YES
          tx-comprimento:VISIBLE = YES.
END.



IF p-ind-event = "DISPLAY" THEN DO:
   IF p-wgh-frame:NAME = "f-main"  THEN DO:
      FIND FIRST embalag WHERE
           ROWID(embalag) = p-row-table NO-ERROR.
      IF AVAIL embalag THEN DO:
         ASSIGN wh-altura:SCREEN-VALUE      = string(embalag.altura) 
                wh-largura:SCREEN-VALUE     = string(embalag.largura) 
                wh-comprimento:SCREEN-VALUE = string(embalag.comprim).

         RUN pi-calcula-volume IN h-ft0303-upc. 
      END.
   END.
END.




IF p-ind-event = "ASSIGN" THEN DO:   
    FIND FIRST embalag WHERE
         ROWID(embalag) = p-row-table NO-ERROR.
    IF AVAIL embalag THEN DO:
       ASSIGN embalag.altura = DEC(wh-altura:SCREEN-VALUE)
              embalag.largura = DEC(wh-largura:SCREEN-VALUE)
              embalag.comprim = DEC(wh-comprimento:SCREEN-VALUE).
    END.
END.

IF  p-ind-event = "DESTROY" THEN DO:
    IF  VALID-HANDLE(h-ft0303-upc) THEN DO:
        DELETE PROCEDURE h-ft0303-upc.
        ASSIGN h-ft0303-upc = ?.
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
                    "P-Ind-Event"    pIndEvent  SKIP
            wgh-obj:SCREEN-VALUE VIEW-AS ALERT-BOX.  

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
    
PROCEDURE tela-upc-literal:
    DEFINE INPUT  PARAMETER  pWghFrame    AS WIDGET-HANDLE NO-UNDO.
    DEFINE INPUT  PARAMETER  pIndEvent    AS CHARACTER     NO-UNDO.
    DEFINE INPUT  PARAMETER  pObjType     AS CHARACTER     NO-UNDO.
    DEFINE INPUT  PARAMETER  pObjScreen     AS CHARACTER     NO-UNDO.
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
                    "P-Ind-Event"    pIndEvent  SKIP
            wgh-obj:SCREEN-VALUE VIEW-AS ALERT-BOX.  

        IF wgh-obj:TYPE = pObjType AND
           wgh-obj:SCREEN-VALUE = pObjScreen THEN DO:
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


PROCEDURE pi-calcula-volume:
        IF VALID-HANDLE(wh-de-volume) THEN DO:
            ASSIGN wh-de-volume:SCREEN-VALUE = string(DEC(wh-altura:SCREEN-VALUE) * DEC(wh-largura:SCREEN-VALUE) * DEC(wh-comprimento:SCREEN-VALUE) / 1000000000).
        END.
END PROCEDURE.
