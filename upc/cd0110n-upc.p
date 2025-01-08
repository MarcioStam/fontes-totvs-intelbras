/***********************************************************************
**  Programa..: upc\cd0110n-upc.p
**  Autor.....: Nicolas Martinez
**  Data......: Janeiro/2020 - Desenvolvimento
**  Descricao.: Em troca do cd0110-upc.p devido ao multiestabelecimento
**  Vers∆o....: 001 - 01/01/2020
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

DEF NEW GLOBAL SHARED VAR tx-canal      AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR tx-ativo      AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR tx-projeto    AS WIDGET-HANDLE NO-UNDO.

DEF NEW GLOBAL SHARED VAR wh-canal      AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-canal-venda      AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-ativo      AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-projeto    AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-classific      AS WIDGET-HANDLE NO-UNDO.


DEF NEW GLOBAL SHARED VAR wh-cod-imagem      AS WIDGET-HANDLE NO-UNDO.

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
   
IF  p-ind-event  = "AFTER-INITIALIZE" THEN DO:    
    ASSIGN h-object = p-wgh-frame:FIRST-CHILD.
    ASSIGN h-object = h-object:FIRST-CHILD.

    DO WHILE VALID-HANDLE(h-object):


        IF h-object:TYPE <> "field-group" THEN DO:
            IF h-object:NAME = 'rtKeys-2' THEN DO:
                ASSIGN wh-cod-imagem = h-object.
                LEAVE.
            END.
            ASSIGN h-object = h-object:NEXT-SIBLING NO-ERROR.
        END.
        ELSE LEAVE.
    END.    

    IF p-wgh-frame:NAME = "fpage0"  THEN DO:

        ASSIGN wh-cod-imagem:HEIGHT = wh-cod-imagem:HEIGHT + 1.3.

            /************* Cria canal venda ****************/
        CREATE TEXT tx-canal
        ASSIGN FRAME        = p-wgh-frame
               FORMAT       = "x(12)"
               WIDTH        = 12
               SCREEN-VALUE = "Canal venda:"
               ROW          = 5.13
               COL          = 67
               VISIBLE      = YES.

        CREATE FILL-IN wh-canal
        ASSIGN FRAME             = p-wgh-frame
               DATA-TYPE         = "Integer"
               /* FORMAT            = "Dec" */
               WIDTH             = 4
               HEIGHT            = 0.88
               ROW               = 4.97
               COL               = 76
               VISIBLE           = YES
               SENSITIVE         = NO

               SIDE-LABEL-HANDLE = tx-canal:HANDLE

               TRIGGERS:
                    ON F5 PERSISTENT RUN upc\cd0110-upca.p.
                    ON MOUSE-SELECT-DBLCLICK PERSISTENT RUN upc\cd0110-upca.p. 
               END TRIGGERS.               

        /************************************************/


        /***************** Cria ativo ******************/
        CREATE TEXT tx-ativo
        ASSIGN FRAME        = p-wgh-frame
               FORMAT       = "x(6)"
               WIDTH        = 6
               SCREEN-VALUE = "Ativo:"
               ROW          = 5.13
               COL          = 81
               VISIBLE      = YES.               
    
        CREATE FILL-IN wh-ativo
        ASSIGN FRAME             = p-wgh-frame
               DATA-TYPE         = "logical"
               FORMAT            = "Sim/N∆o" 
               WIDTH             = 4
               HEIGHT            = 0.88
               ROW               = 4.97
               COL               = 85
               VISIBLE           = YES
               SENSITIVE         = NO.
    
        IF VALID-HANDLE(wh-ativo) AND VALID-HANDLE(tx-ativo) THEN 
        ASSIGN wh-ativo:SCREEN-VALUE  = "Sim". 
        /************************************************/
    
        
        /**************** Cria projeto ******************/
        CREATE TEXT tx-projeto
        ASSIGN FRAME        = p-wgh-frame
               FORMAT       = "x(8)"
               WIDTH        = 4
               SCREEN-VALUE = "Proje:"
               ROW          = 6.13
               COL          = 81
               VISIBLE      = YES.
    
        CREATE FILL-IN wh-projeto
        ASSIGN FRAME             = p-wgh-frame
               DATA-TYPE         = "logical"
               FORMAT            = "Sim/N∆o" 
               WIDTH             = 4
               HEIGHT            = 0.88
               ROW               = 5.97
               COL               = 85
               VISIBLE           = YES
               SENSITIVE         = NO.
    
        IF VALID-HANDLE(wh-projeto) AND VALID-HANDLE(tx-projeto) THEN 
           ASSIGN wh-projeto:SCREEN-VALUE  = "Sim". 
       /************************************************/


        IF VALID-HANDLE(wh-ativo) THEN
           wh-ativo:MOVE-AFTER-TAB-ITEM(wh-ativo).

        IF VALID-HANDLE(wh-projeto) THEN
           wh-projeto:MOVE-AFTER-TAB-ITEM(wh-projeto).


        FIND FIRST centro-custo WHERE
             ROWID(centro-custo) = p-row-table NO-ERROR.
        IF AVAIL centro-custo THEN DO:
           IF centro-custo.nr-up-report = 0 THEN
              ASSIGN wh-ativo:SCREEN-VALUE = "N∆o".
           ELSE
              ASSIGN wh-ativo:SCREEN-VALUE = "Sim".
    
           IF centro-custo.val-unit-up[1] = 0 THEN
              ASSIGN wh-projeto:SCREEN-VALUE = "N∆o".
           ELSE
              ASSIGN wh-projeto:SCREEN-VALUE = "Sim".
        END.
    END.

    wh-canal:LOAD-MOUSE-POINTER('image/lupa.cur').
    
END.

IF p-ind-event = "AFTER-ADD" THEN DO:
   IF p-wgh-frame:NAME = "fpage0"  THEN DO:
      ASSIGN wh-canal:SENSITIVE      = YES
             wh-ativo:SENSITIVE      = YES
             wh-projeto:SENSITIVE    = YES
             tx-canal:SCREEN-VALUE   = "Canal venda:"
             tx-ativo:SCREEN-VALUE   = "Ativo:"
             tx-projeto:SCREEN-VALUE = "Proje:".
   END.
END.

IF p-ind-event = "AFTER-ENABLE" THEN DO:
    IF p-wgh-frame:NAME = "fpage0"  THEN DO:
       ASSIGN wh-canal:SENSITIVE  = YES
              wh-ativo:SENSITIVE = YES
              wh-projeto:SENSITIVE  = YES.
    END.
END.

IF p-ind-event = "AFTER-CANCEL" THEN DO:
   ASSIGN wh-canal:SENSITIVE   = NO
          wh-ativo:SENSITIVE   = NO
          wh-projeto:SENSITIVE = NO
          tx-canal:VISIBLE     = YES
          tx-ativo:VISIBLE     = YES
          tx-projeto:VISIBLE   = YES.
END.

IF p-ind-event = "AFTER-DISPLAY" THEN DO:
   
   IF p-wgh-frame:NAME = "fpage0"  THEN DO:
      FIND FIRST centro-custo WHERE
           ROWID(centro-custo) = p-row-table NO-ERROR.
      IF AVAIL centro-custo THEN DO:

         IF VALID-HANDLE(wh-ativo) AND VALID-HANDLE(tx-ativo) 
         THEN DO:         
             IF centro-custo.nr-up-report = 0 THEN
                ASSIGN wh-ativo:SCREEN-VALUE = "N∆o".
             ELSE
                ASSIGN wh-ativo:SCREEN-VALUE = "Sim".
         END.

         IF VALID-HANDLE(wh-projeto) AND VALID-HANDLE(wh-projeto) 
         THEN DO:
             IF centro-custo.val-unit-up[1] = 0 THEN
                ASSIGN wh-projeto:SCREEN-VALUE = "N∆o".
             ELSE
                ASSIGN wh-projeto:SCREEN-VALUE = "Sim".
         END.

         IF VALID-HANDLE(wh-canal) AND VALID-HANDLE(wh-canal) 
         THEN DO:
             IF centro-custo.val-unit-up[2] = 0 THEN
                ASSIGN wh-canal:SCREEN-VALUE = "0".
             ELSE
                ASSIGN wh-canal:SCREEN-VALUE = string(centro-custo.val-unit-up[2]).
         END.
      END. 
   END. 
END.

IF p-ind-event = "AFTER-ASSIGN" THEN DO:   
    FIND FIRST centro-custo WHERE
         ROWID(centro-custo) = p-row-table NO-ERROR.
    IF AVAIL centro-custo THEN DO:
       IF wh-ativo:SCREEN-VALUE = "" THEN DO:
          MESSAGE "Preencher ativo sim/n∆o"
              VIEW-AS ALERT-BOX INFO BUTTONS OK.
          RETURN "NOK".
       END.

       IF wh-projeto:SCREEN-VALUE = "" THEN DO:
          MESSAGE "Preencher projeto sim/n∆o"
              VIEW-AS ALERT-BOX INFO BUTTONS OK.
          RETURN "NOK".
       END.

       IF wh-canal:SCREEN-VALUE <> ""   AND
          wh-canal:SCREEN-VALUE <> "0"  THEN DO:
          FIND FIRST canal-venda WHERE 
               canal-venda.cod-canal-venda = INT(wh-canal:SCREEN-VALUE) NO-LOCK NO-ERROR.
          IF NOT AVAIL canal-venda THEN DO:
             MESSAGE "Canal de venda n∆o cadastrado"
                 VIEW-AS ALERT-BOX INFO BUTTONS OK.
             RETURN "NOK".
          END.
          ELSE DO:
             ASSIGN centro-custo.val-unit-up[2] = DEC(wh-canal:SCREEN-VALUE).
          END.
       END.

       IF wh-ativo:SCREEN-VALUE = "N∆o" THEN DO:
          ASSIGN centro-custo.nr-up-report = 0.
       END.
       ELSE DO:
          ASSIGN centro-custo.nr-up-report = 1.
       END.

       IF wh-projeto:SCREEN-VALUE = "N∆o" THEN DO:
          ASSIGN centro-custo.val-unit-up[1] = 0.
       END.
       ELSE DO:
          ASSIGN centro-custo.val-unit-up[1] = 1.
       END.      

    END.

    ASSIGN wh-canal:SENSITIVE   = NO
           wh-ativo:SENSITIVE   = NO
           wh-projeto:SENSITIVE = NO
           tx-canal:VISIBLE     = YES
           tx-ativo:VISIBLE     = YES
           tx-projeto:VISIBLE   = YES.
END.
