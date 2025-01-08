DEF input param p-ind-event          as char          no-undo.
def input param p-ind-object         as char          no-undo.
def input param p-wgh-object         as handle        no-undo.
def input param p-wgh-frame          as widget-handle no-undo.
def input param p-cod-table          as char          no-undo.
def input param p-row-table          as RECID         no-undo.

DEF VAR h-frame   AS HANDLE          NO-UNDO.
DEF VAR h-buffer  AS HANDLE          NO-UNDO.

/* Global Variable Definitions **********************************************/
define new global shared var whBrDigita         as widget-handle no-undo.
define var wh_button                            as widget-handle  no-undo.

/****************************  Variaveis    ****************************/

IF  p-ind-event  = "INITIALIZE" and
    p-wgh-frame:NAME = "f_dlg_03_planilha_vendor_fechamento_1" THEN DO:
    create button wh_button
    assign frame      = p-wgh-frame
           width      = 10
           height     = 1.08
           row        = 18.35
           col        = 35
           sensitive  = yes
           LABEL      = "Destina‡Æo"
           visible    = yes
           tooltip    = "Altera o portador dos t¡tulos selecionados!"
           triggers:
               on choose PERSISTENT run upc\vdr702za_upca.p.
           end triggers.

  /*  wh_button:load-image("image/ii-barras.bmp":U) */. 

    ASSIGN h-frame = p-wgh-frame:FIRST-CHILD. /* pegando o Field-Group */
    ASSIGN h-frame = h-frame:FIRST-CHILD.     /* pegando o 1o. Campo */
    DO WHILE h-frame <> ?:
       IF h-frame:TYPE <> "field-group" THEN DO:  
          CASE h-frame:NAME:
               WHEN "br_tt_browse_dupl_vendor" THEN
                    ASSIGN whBrDigita = h-frame.
          END CASE.
          ASSIGN h-frame = h-frame:NEXT-SIBLING.
       END.
       ELSE DO:
          ASSIGN h-frame = h-frame:FIRST-CHILD.
       END.
    END.

    /**** AS LINHA ABAIXO BUSCAM O NOME DAS COLUNAS DO BROWSE *********/

/*    DEF VAR i AS INT INIT 1.
    DO WHILE NOT ERROR-STATUS:ERROR:
        
        h-buffer = whbrdigita:GET-BROWSE-COLUMN(i) NO-ERROR.
       
        ASSIGN i = i + 1.
        
        MESSAGE h-buffer:NAME   SKIP
            i
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
    END. */
END.

