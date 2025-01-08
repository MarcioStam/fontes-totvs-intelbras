/***********************************************************************
**  Programa..: UPC\PD4000K-UPC.P
**  Autor.....: Marcio Chaves - Gestech
**  Data......: NOVEMBRO/2004 - Desenvolvimento
**  Descricao.: 
**  Vers∆o....: 001 16/11/2004
**                  Desenvolvimento Programa
************************************************************************/
def input param p-ind-event        as char          no-undo.
def input param p-ind-object       as char          no-undo.
def input param p-wgh-object       as handle        no-undo.
def input param p-wgh-frame        as widget-handle no-undo.
def input param p-cod-table        as char          no-undo.
def input param p-row-table        as rowid         no-undo.

DEF VAR c-objeto AS CHAR     NO-UNDO.
DEF VAR l-ok     AS LOGICAL  NO-UNDO.
DEF VAR h-frame  AS HANDLE   NO-UNDO.
DEF VAR cReturn  AS CHAR     NO-UNDO.
def var h-buffer      as handle        no-undo.
def var ponteiro      as widget-handle no-undo.
DEF VAR c_cod_estab_usuar AS CHAR.

assign c-objeto = entry(num-entries(p-wgh-object:file-name,"~/"), 
                        p-wgh-object:file-name,"~/").
  
{esapi\esapi002tt.i}    /* Definicao da temp-table de origem */

/****************************  Variaveis    ****************************/

DEF NEW GLOBAL SHARED VAR gr-ped-venda      AS ROWID         NO-UNDO.
DEF NEW GLOBAL SHARED VAR whBtAdd           AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR whBtOK            AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR whBtCancel        AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR whBtLocalAdd      AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR whBtReporte       AS WIDGET-HANDLE NO-UNDO.
/*DEF NEW GLOBAL SHARED VAR whBtFIFO          AS WIDGET-HANDLE NO-UNDO.*/
DEF NEW GLOBAL SHARED VAR whBtLocalOK       AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR whBtLocalCancel   AS WIDGET-HANDLE NO-UNDO.

DEF NEW GLOBAL SHARED VAR whbrEntregas      AS WIDGET-HANDLE NO-UNDO.

DEF BUFFER bsaldo-estoq FOR saldo-estoq.

DEF VAR c-grupo-aloca  LIKE estabelec.grupo-aloca   NO-UNDO.
DEF VAR deQtDisponivel LIKE saldo-estoq.qtidade-atu NO-UNDO.


IF  p-ind-object  = "CONTAINER"         AND 
    c-objeto      = "PD4000K.W"         THEN DO:

    IF  p-ind-event   = "BEFORE-INITIALIZE" AND 
        gr-ped-venda <> ?                   THEN DO:

        ASSIGN h-frame = p-wgh-frame:FIRST-CHILD.
        ASSIGN h-frame = h-frame:FIRST-CHILD.

        DO  WHILE VALID-HANDLE(h-frame):
            IF  h-frame:TYPE <> "field-group" THEN DO:
                CASE h-frame:NAME:
                    WHEN "btOk"        THEN ASSIGN whBtOk       = h-frame.
                    WHEN "btCancel"    THEN ASSIGN whBtCancel   = h-frame.
                    WHEN "btAdd"       THEN ASSIGN whBtAdd      = h-frame.
                    WHEN "brEntregas"  THEN ASSIGN whbrEntregas = h-frame.
                END.
                ASSIGN h-frame = h-frame:NEXT-SIBLING.
            END.
            ELSE LEAVE.
        END.
        /*ASSIGN brEntregas = p-wgh-frame.*/
        /* Cria Bot∆o ADD */
        IF  VALID-HANDLE(whBtAdd) THEN DO:
            CREATE BUTTON whBtLocalAdd
            ASSIGN FRAME     = whBtAdd:FRAME
                   WIDTH     = whBtAdd:WIDTH
                   HEIGHT    = whBtAdd:HEIGHT
                   ROW       = whBtAdd:ROW
                   LABEL     = whBtAdd:LABEL
                   COL       = whBtAdd:COL
                   SENSITIVE = whBtAdd:SENSITIVE
                   VISIBLE   = whBtAdd:VISIBLE
            TRIGGERS:
                  ON CHOOSE PERSISTENT RUN upc\pd4000k-upca.p.
            END TRIGGERS.
            
            whBtLocalAdd:LOAD-IMAGE-UP(whBtAdd:IMAGE-UP).
            whBtLocalAdd:LOAD-IMAGE-INSENSITIVE(whBtAdd:IMAGE-INSENSITIVE).
        END.

        /* Cria Bot∆o Reporte 
        IF  VALID-HANDLE(whBtOk) THEN DO:
            CREATE BUTTON whBtReporte
            ASSIGN FRAME     = whBtOk:FRAME
                   WIDTH     = whBtOk:WIDTH
                   HEIGHT    = whBtOk:HEIGHT
                   ROW       = whBtOk:ROW
                   LABEL     = whBtOk:LABEL
                   COL       = whBtOk:COL + 50 
                   SENSITIVE = whBtOk:SENSITIVE
                   VISIBLE   = whBtOk:VISIBLE
            TRIGGERS:
                  ON CHOOSE PERSISTENT RUN upc\pd4000k-upcb.p.
            END TRIGGERS.
            ASSIGN whBtReporte:LABEL  = "Reporte".

        END.
        */
        /* Cria Bot∆o OK */
        IF  VALID-HANDLE(whBtOk) THEN DO:
            CREATE BUTTON whBtLocalOK
            ASSIGN FRAME     = whBtOk:FRAME
                   WIDTH     = whBtOk:WIDTH
                   HEIGHT    = whBtOk:HEIGHT
                   ROW       = whBtOk:ROW
                   LABEL     = whBtOk:LABEL
                   COL       = whBtOk:COL  
                   SENSITIVE = whBtOk:SENSITIVE
                   VISIBLE   = whBtOk:VISIBLE
            TRIGGERS:
                  ON CHOOSE PERSISTENT RUN upc\pd4000k-upcc.p.
            END TRIGGERS.
        END.

        /* Cria Bot∆o Cancela */
        IF  VALID-HANDLE(whBtCancel) THEN DO:
            CREATE BUTTON whBtLocalCancel
            ASSIGN FRAME     = whBtCancel:FRAME
                   WIDTH     = whBtCancel:WIDTH
                   HEIGHT    = whBtCancel:HEIGHT
                   ROW       = whBtCancel:ROW
                   LABEL     = whBtCancel:LABEL
                   COL       = whBtCancel:COL 
                   SENSITIVE = whBtCancel:SENSITIVE
                   VISIBLE   = whBtCancel:VISIBLE
            TRIGGERS:
                  ON CHOOSE PERSISTENT RUN upc\pd4000k-upcd.p.
            END TRIGGERS.
        END.

        /* Cria Bot∆o Transf FIFO 
        IF  VALID-HANDLE(whBtOk) THEN DO:
            CREATE BUTTON whBtFifo
            ASSIGN FRAME     = whBtOk:FRAME
                   WIDTH     = whBtOk:WIDTH + 5
                   HEIGHT    = whBtOk:HEIGHT
                   ROW       = whBtOk:ROW
                   LABEL     = whBtOk:LABEL
                   COL       = whBtOk:COL + 60 
                   SENSITIVE = whBtOk:SENSITIVE
                   VISIBLE   = whBtOk:VISIBLE
            TRIGGERS:
                  ON CHOOSE PERSISTENT RUN upc\pd4000k-upce.p.
            END TRIGGERS.
            ASSIGN whBtFifo:LABEL  = "Trans.FIFO".

        END.
        */
        /**
         ** L¢gica para Transferància de Dep¢sitos via FIFO.
         **/
        RUN upc\pd4000k-upce.p.
        /* Logica passada para programa pd4000kupce.p */
    END.
    IF  VALID-HANDLE(whBtAdd) THEN 
        ASSIGN whBtLocalAdd:SENSITIVE = whBtAdd:SENSITIVE
               whBtLocalAdd:VISIBLE   = whBtAdd:VISIBLE.
    IF  VALID-HANDLE(whBtOk) THEN 
        ASSIGN /*whBtReporte:SENSITIVE = whBtOk:SENSITIVE */
               /*whBtReporte:VISIBLE   = whBtOk:VISIBLE   */
               /*whBtFifo:SENSITIVE    = whBtOk:SENSITIVE 
               whBtFifo:VISIBLE      = whBtOk:VISIBLE   */
               whBtLocalOK:SENSITIVE = whBtOk:SENSITIVE 
               whBtLocalOK:VISIBLE   = whBtOk:VISIBLE.
    IF  VALID-HANDLE(whBtCancel) THEN 
        ASSIGN whBtLocalCancel:SENSITIVE = whBtCancel:SENSITIVE
               whBtLocalCancel:VISIBLE   = whBtCancel:VISIBLE.
END.

