/***********************************************************************
**  Programa..: upc\im0100-upc.p
**  Autor.....: Clayton Antunes
**  Data......: JUlHO/2006 - Desenvolvimento
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

DEF NEW GLOBAL SHARED VAR tx-credito-interno AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-credito-interno AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR tx-protocolo       AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-protocolo       AS WIDGET-HANDLE NO-UNDO.

DEFINE VARIABLE c-char AS   CHAR.

assign c-char = entry(num-entries(p-wgh-object:file-name,"~/"), p-wgh-object:file-name,"~/").


/*                                        */
/*                                        */
/*  MESSAGE "Evento " p-ind-event  SKIP   */
/*         "Objeto " p-ind-object SKIP    */
/*         "Nome   " c-char SKIP          */
/*         "Tabela " p-cod-table  SKIP    */
/*         "Rowid  " STRING(p-row-table)  */
/*     VIEW-AS ALERT-BOX INFO BUTTONS OK. */

   


IF  p-ind-event  = "INITIALIZE" THEN DO:    
/*     ASSIGN h-object = p-wgh-frame:FIRST-CHILD.                */
/*     ASSIGN h-object = h-object:FIRST-CHILD.                   */
/*                                                               */
/*     DO WHILE VALID-HANDLE(h-object):                          */
/*         IF h-object:TYPE <> "field-group" THEN DO:            */
/*             IF h-object:NAME = 'cod-imagem' THEN DO:          */
/*                 ASSIGN wh-cod-imagem = h-object.              */
/*                 LEAVE.                                        */
/*             END.                                              */
/*             ASSIGN h-object = h-object:NEXT-SIBLING NO-ERROR. */
/*         END.                                                  */
/*         ELSE LEAVE.                                           */
/*     END.                                                      */
    


    IF p-wgh-frame:NAME = "f-main"  THEN DO:

            /************* Cria Perc.Credito Interno ****************/
        CREATE TEXT tx-credito-interno
        ASSIGN FRAME        = p-wgh-frame
               FORMAT       = "x(22)"
               WIDTH        = 22
               SCREEN-VALUE = "Perc.Credito Interno:"
               ROW          = 7.83
               COL          = 57
               VISIBLE      = YES.

        CREATE FILL-IN wh-credito-interno
        ASSIGN FRAME             = p-wgh-frame
               DATA-TYPE         = "Decimal"
               /* FORMAT            = "Dec" */
               WIDTH             = 5
               HEIGHT            = 0.88 /*0.98*/
               ROW               = 7.67
               COL               = 71
               VISIBLE           = YES
               SENSITIVE         = NO

               SIDE-LABEL-HANDLE = tx-credito-interno:HANDLE.

        /************************************************/

        CREATE TEXT tx-protocolo
        ASSIGN FRAME        = p-wgh-frame
               FORMAT       = "x(22)"
               WIDTH        = 22
               SCREEN-VALUE = "Nr Protocolo ICMS:"
               ROW          = 8.83
               COL          = 57.8
               VISIBLE      = YES.

        CREATE FILL-IN wh-protocolo
        ASSIGN FRAME             = p-wgh-frame
               DATA-TYPE         = "character"
               FORMAT            = "x(12)" 
               WIDTH             = 13
               HEIGHT            = 0.88
               ROW               = 8.67
               COL               = 71
               VISIBLE           = YES
               SENSITIVE         = NO

               SIDE-LABEL-HANDLE = tx-protocolo:HANDLE.
    
    END.
END.



IF p-ind-event = "ADD" THEN DO:
   IF p-wgh-frame:NAME = "f-main"  THEN DO:
      ASSIGN wh-credito-interno:SENSITIVE      = YES
             tx-credito-interno:SCREEN-VALUE   = "Perc.Credito Interno:"
             wh-protocolo:SENSITIVE            = YES
             tx-protocolo:SCREEN-VALUE         = "Nr Protocolo ICMS:".
   END.
END.



IF p-ind-event = "ENABLE" THEN DO:
    IF p-wgh-frame:NAME = "f-main"  THEN DO:
       ASSIGN wh-credito-interno:SENSITIVE  = YES
              wh-protocolo:SENSITIVE        = YES.
    END.
END.


IF p-ind-event = "CANCEL" THEN 
   ASSIGN wh-credito-interno:SENSITIVE = NO
          tx-credito-interno:VISIBLE   = YES
          wh-protocolo:SENSITIVE       = NO 
          tx-protocolo:VISIBLE         = YES.

IF p-ind-event = "DISPLAY" THEN DO:
   IF p-wgh-frame:NAME = "f-main"  THEN DO:
      FIND FIRST item-uf WHERE
           ROWID(item-uf) = p-row-table NO-ERROR.
      IF AVAIL item-uf THEN DO:


          FIND int-item-uf
               WHERE int-item-uf.estado          = item-uf.estado
                 AND int-item-uf.cod-estado-orig = item-uf.cod-estado-orig
                 AND int-item-uf.it-codigo       = item-uf.it-codigo
               NO-LOCK NO-ERROR.

          IF NOT AVAIL INT-item-uf THEN DO:
              CREATE int-item-uf.
              ASSIGN int-item-uf.estado          = item-uf.estado  
                     int-item-uf.cod-estado-orig = item-uf.cod-estado-orig
                     int-item-uf.it-codigo       = item-uf.it-codigo.
          END.

         IF int-item-uf.perc-credito-interno = 0 THEN
            ASSIGN wh-credito-interno:SCREEN-VALUE = "0".
         ELSE
            ASSIGN wh-credito-interno:SCREEN-VALUE = string(int-item-uf.perc-credito-interno).

         ASSIGN wh-protocolo:SCREEN-VALUE = int-item-uf.protocolo.

      END.
   END.
END.

IF p-ind-event = "ASSIGN" THEN DO:   
    FIND FIRST item-uf WHERE
         ROWID(item-uf) = p-row-table NO-ERROR.

    IF AVAIL item-uf THEN DO:
        FIND int-item-uf
             WHERE int-item-uf.estado = item-uf.estado
               AND int-item-uf.it-codigo = item-uf.it-codigo
               AND int-item-uf.cod-estado-orig = item-uf.cod-estado-orig
             exclusive-LOCK NO-ERROR.

        IF NOT AVAIL INT-item-uf THEN DO:
            CREATE int-item-uf.
            ASSIGN int-item-uf.estado          = item-uf.estado  
                   int-item-uf.cod-estado-orig = item-uf.cod-estado-orig
                   int-item-uf.it-codigo       = item-uf.it-codigo.
        END.

        ASSIGN int-item-uf.perc-credito-interno = dec(wh-credito-interno:SCREEN-VALUE).
               int-item-uf.protocolo            = wh-protocolo:SCREEN-VALUE.
    END.

    ASSIGN wh-credito-interno:SENSITIVE = NO
           tx-credito-interno:VISIBLE   = YES
           wh-protocolo:SENSITIVE       = NO
           tx-protocolo:VISIBLE         = YES.
END.


    
