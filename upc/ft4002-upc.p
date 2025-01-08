/* ---------------------------------------------------------------------------
Programa : ft4002-upc.p
Funcao   : 
Autor    : 
Data     : 
Alteraá∆o:
--------------------------------------------------------------------------- */
DEFINE INPUT PARAMETER p-ind-event      AS CHARACTER        NO-UNDO.
DEFINE INPUT PARAMETER p-ind-object     AS CHARACTER        NO-UNDO.
DEFINE INPUT PARAMETER p-wgh-object     AS HANDLE           NO-UNDO.
DEFINE INPUT PARAMETER p-wgh-frame      AS WIDGET-HANDLE    NO-UNDO.
DEFINE INPUT PARAMETER p-cod-table      AS CHARACTER        NO-UNDO.
DEFINE INPUT PARAMETER p-row-table      AS ROWID            NO-UNDO.

{esp/es0018.i}

DEFINE VARIABLE h-object    AS HANDLE           NO-UNDO.
DEFINE VARIABLE c-objeto    AS CHARACTER        NO-UNDO.
DEFINE VARIABLE h-frame     AS HANDLE           NO-UNDO.
DEFINE VARIABLE wgh-frame   AS WIDGET-HANDLE    NO-UNDO.

DEFINE VARIABLE iParent  AS INTEGER     NO-UNDO.
DEFINE VARIABLE iSysMenu AS INTEGER     NO-UNDO.
DEFINE VARIABLE iCnt     AS INTEGER     NO-UNDO.
DEFINE VARIABLE iRetCode AS INTEGER     NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE wh-dt-emis-nota-ft4002UPC     AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-nat-operacao-ft4002UPC     AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-cod-canal-venda-ft4002UPC  AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-nr-pedcli-ft4002UPC        AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-cod-estabel-ft4002UPC      AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-serie-ft4002UPC            AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-txt-deposito               AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-cod-depos-FT4002           AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-txt-TribRPS                AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-TribRPS-FT4002             AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE p-row-pedido                  AS ROWID         NO-UNDO.

DEF NEW GLOBAL SHARED VAR C-Seg-Usuario           AS   CHAR   FORM "x(12)" NO-UNDO.

ASSIGN c-objeto   = ENTRY(NUM-ENTRIES(p-wgh-object:PRIVATE-DATA, "~/"), p-wgh-object:PRIVATE-DATA, "~/").

/* MESSAGE '1 p-ind-event         ' p-ind-event        SKIP */
/*         'p-ind-object        ' p-ind-object         SKIP */
/*         'p-wgh-object        ' p-wgh-object         SKIP */
/*         'p-wgh-frame         ' p-wgh-frame          SKIP */
/*         'p-cod-table         ' p-cod-table          SKIP */
/*         'string(p-row-table) ' string(p-row-table)  SKIP */
/*         'string(h-object   ) ' string(h-object   )  SKIP */
/*         'c-objeto            ' c-objeto             SKIP */
/*         'string(h-frame    ) ' string(h-frame    )       */
/*     VIEW-AS ALERT-BOX INFO BUTTONS OK.                   */


if p-ind-event = "AFTER-INITIALIZE" then do:

    RUN GetParent(INPUT  p-wgh-object:CURRENT-WINDOW:HWND,
                  OUTPUT iParent).
    
    /* Get handle to our the window's system menu (Restore, Maximize, Move, close etc.) */
    RUN GetSystemMenu(INPUT  iParent,
                    INPUT  0,
                    OUTPUT iSysMenu).
      
    IF iSysMenu <> 0 THEN DO:
      /* Get System menu's menu count */
      RUN GetMenuItemCount(INPUT  iSysMenu,
                           OUTPUT iCnt).
    
      IF iCnt <> 0 THEN DO:
          /* Menu count is based on 0 (0, 1, 2, 3...) */
    
          /* remove the "close option" */
          RUN RemoveMenu(INPUT  iSysMenu,
                         INPUT  iCnt - 1, 
                         INPUT  1280,
                         OUTPUT iRetCode).
    
          /* remove the seperator */
          RUN RemoveMenu(INPUT  iSysMenu,
                         INPUT  iCnt - 2,
                         INPUT  1280,
                         OUTPUT iRetCode).
    
          /* Force caption bar's refresh which will disable the window close ("X") button */
          RUN DrawMenuBar(INPUT  iParent,
                          OUTPUT iRetCode).
      END.
    END.

/*     if p-wgh-frame:type = "frame" and p-wgh-frame:name = "fpage0" then do: */
/*        run pi-busca-handle (input p-wgh-frame,                             */
/*                             input p-ind-event,                             */
/*                             input 'frame':U,                               */
/*                             input 'fpage5':U,                              */
/*                             input NO,                                      */
/*                             output wh-frame-fpage5-ft4004).                */
/*     END.                                                                   */
END.


if p-ind-event  = "after-initialize" and 
   p-ind-object = "CONTAINER" then do:

    IF VALID-HANDLE(wh-cod-depos-FT4002) 
    OR VALID-HANDLE(wh-nr-pedcli-ft4002UPC) THEN DO:
        run utp/ut-msgs.p (INPUT "show":U,
                           INPUT 17006,
                           INPUT "Atená∆o, j† existe uma Tela do FT4002 aberta em sua sess∆o EMS, favor fechar a tela recÇm aberta. ~~ " +
                                 "Por restriá‰es tÇcnicas, n∆o Ç poss°vel trabalhar com mais de uma tela do FT4002 na mesma sess∆o do EMS.").
    END.

    ASSIGN wgh-frame    = p-wgh-frame:FIRST-CHILD
           wgh-frame    = wgh-frame:FIRST-CHILD
           p-row-pedido = p-row-table.

    DO WHILE VALID-HANDLE(wgh-frame):
        IF wgh-frame:TYPE <> "field-group" THEN DO:

            IF wgh-frame:NAME = "dt-emis-nota":U THEN
                ASSIGN wh-dt-emis-nota-ft4002UPC = wgh-frame.

            IF wgh-frame:NAME = "nat-operacao":U THEN
                ASSIGN wh-nat-operacao-ft4002UPC = wgh-frame.

            IF wgh-frame:NAME = "cod-canal-venda":U THEN
                ASSIGN wh-cod-canal-venda-ft4002UPC = wgh-frame.

            IF wgh-frame:NAME = "nr-pedcli":U THEN 
                ASSIGN wh-nr-pedcli-ft4002UPC = wgh-frame.

            IF wgh-frame:NAME = "cod-estabel":U THEN 
                ASSIGN wh-cod-estabel-ft4002UPC = wgh-frame.

            IF wgh-frame:NAME = "serie":U THEN 
                ASSIGN wh-serie-ft4002UPC = wgh-frame.
            
            ASSIGN wgh-frame = wgh-frame:NEXT-SIBLING NO-ERROR.
        END. /* IF wgh-frame:TYPE <> "field-group" THEN DO: */
        ELSE LEAVE.
    END. /* DO WHILE VALID-HANDLE(wgh-frame): */

    IF VALID-HANDLE(wh-dt-emis-nota-ft4002UPC   ) THEN DO:
        CREATE TOGGLE-BOX wh-TribRPS-FT4002
        ASSIGN FRAME            = wh-dt-emis-nota-ft4002UPC:FRAME
               WIDTH            = 21
               LABEL            = "TRIB. FORA MUNICIPIO"
               ROW              = 3
               COLUMN           = 35
               VISIBLE          = YES.
    END.

    IF VALID-HANDLE(wh-cod-canal-venda-ft4002UPC) THEN DO:
        CREATE TEXT wh-txt-deposito
        ASSIGN FRAME        = wh-cod-canal-venda-ft4002UPC:FRAME
               WIDTH        = 7
               FORMAT       = "x(7)":U
               SCREEN-VALUE = "Depos:":U
               ROW          = wh-cod-canal-venda-ft4002UPC:ROW
               COLUMN       = wh-cod-canal-venda-ft4002UPC:COLUMN - 26
               VISIBLE      = YES.

        CREATE COMBO-BOX wh-cod-depos-FT4002
        ASSIGN FRAME            = wh-cod-canal-venda-ft4002UPC:FRAME
               DATA-TYPE        = "character"
               WIDTH            = 10
               ROW              = wh-cod-canal-venda-ft4002UPC:ROW
               COLUMN           = wh-txt-deposito:COLUMN + 5
               VISIBLE          = YES
               INNER-LINES      = 4
               HELP             = "Dep¢sito"
               FONT             = 1
            TRIGGERS:
               ON "VALUE-CHANGED":U PERSISTENT RUN upc/ft4002-upc2.p.
            END TRIGGERS.

        /******************* Valores combo-box */
        FOR FIRST ponto-programa
            WHERE ponto-programa.nome-programa = "espdp006"
              AND ponto-programa.ponto         = 5,
            EACH conteudo-programa NO-LOCK
            WHERE conteudo-programa.cod-programa      = ponto-programa.cod-programa
              AND ENTRY(2,conteudo-programa.conteudo) = c-seg-usuario:     /* Usuario que tera a localizacao habilitado */
            IF wh-cod-depos-FT4002:LIST-ITEMS = ? THEN
                ASSIGN wh-cod-depos-FT4002:LIST-ITEMS = ENTRY(1,conteudo-programa.conteudo).
            ELSE
                ASSIGN wh-cod-depos-FT4002:LIST-ITEMS = wh-cod-depos-FT4002:LIST-ITEMS + "," + ENTRY(1,conteudo-programa.conteudo).
        END. /* FOR FIRST ponto-programa */

        IF wh-cod-depos-FT4002:LIST-ITEMS = ? THEN
            ASSIGN wh-cod-depos-FT4002:LIST-ITEMS = "exp":U.

        ASSIGN wh-cod-depos-FT4002:LIST-ITEMS = wh-cod-depos-FT4002:LIST-ITEMS + ",":U + "tnf":U
               wh-cod-depos-FT4002:LIST-ITEMS = LC(wh-cod-depos-FT4002:LIST-ITEMS).

        FIND FIRST ped-venda 
            WHERE rowid(ped-venda) = p-row-table NO-LOCK NO-ERROR.
        IF AVAIL ped-venda THEN DO:
            FIND FIRST int-ped-venda
            WHERE int-ped-venda.nr-pedido   = ped-venda.nr-pedido
              AND int-ped-venda.cod-estabel = ped-venda.cod-estabel NO-LOCK NO-ERROR.  
            IF AVAIL int-ped-venda THEN DO:
                IF SUBSTRING(int-ped-venda.char-1, 11, 1) = "S" THEN
                    ASSIGN wh-cod-depos-FT4002:SCREEN-VALUE      = "TNF".
                ELSE DO: 
                    /*Para quando for estabelecimento WMS*/
                    IF  ped-venda.cod-estabel = "104" THEN
                        ASSIGN wh-cod-depos-FT4002:SCREEN-VALUE      = "WEX".
                    ELSE
                        ASSIGN wh-cod-depos-FT4002:SCREEN-VALUE      = "EXP".
                END.
                    
            END.
        END. /* IF AVAIL ped-venda THEN DO: */
        /*************** Fim Valores combo-box */

        IF VALID-HANDLE(wh-cod-canal-venda-ft4002UPC) THEN
            wh-cod-depos-FT4002:MOVE-AFTER-TAB-ITEM(wh-cod-canal-venda-ft4002UPC).

    END. /* IF VALID-HANDLE(wh-cod-canal-venda-ft4002UPC) THEN DO: */
END.

IF p-ind-event = 'HabilitaCalculaPedido' THEN DO:
    IF VALID-HANDLE(wh-cod-depos-FT4002) THEN 
        ASSIGN wh-cod-depos-FT4002:SENSITIVE = YES.

    IF VALID-HANDLE(wh-TribRPS-FT4002) THEN
        ASSIGN wh-TribRPS-FT4002:SENSITIVE      = YES
               wh-TribRPS-FT4002:SCREEN-VALUE   = 'no'.

    IF  VALID-HANDLE(wh-dt-emis-nota-ft4002UPC)
    AND VALID-HANDLE(wh-cod-estabel-ft4002UPC) THEN DO:

        IF date(wh-dt-emis-nota-ft4002UPC:SCREEN-VALUE) > TODAY THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U,
                               INPUT 17006,
                               INPUT "Data de faturamento n∆o pode ser maior que a Data atual!~~Data de Emiss∆o da Nota Fiscal deve ser " + STRING(TODAY,"99/99/9999")).
            APPLY "ENTRY" TO wh-dt-emis-nota-ft4002UPC.
            RETURN "NOK".
        END.
        ELSE DO:
           IF date(wh-dt-emis-nota-ft4002UPC:SCREEN-VALUE) <> TODAY THEN DO:
               FIND FIRST bloqueio-fat NO-LOCK NO-ERROR.
               IF AVAIL bloqueio-fat THEN DO:
                   IF LOOKUP(wh-cod-estabel-ft4002UPC:SCREEN-VALUE,bloqueio-fat.estab-fatcom) = 0 THEN DO:
                       RUN utp/ut-msgs.p (INPUT "SHOW":U,
                                          INPUT 17006,
                                          INPUT "Data de faturamento Ç diferente da Data de Emiss∆o da Nota Fiscal!~~Data de Emiss∆o da Nota Fiscal deve ser " + STRING(TODAY,"99/99/9999")).
                       APPLY "ENTRY" TO wh-dt-emis-nota-ft4002UPC.
                       RETURN "NOK".
                   END.
               END.
           END.
        END.
    END.
END.

if p-ind-event  = "before-display" and 
   p-ind-object = "CONTAINER" then do:

    ASSIGN p-row-pedido = p-row-table.

    IF VALID-HANDLE(wh-cod-canal-venda-ft4002UPC) THEN DO:

        /******************* Valores combo-box */
        FIND FIRST ped-venda 
            WHERE rowid(ped-venda) = p-row-table NO-LOCK NO-ERROR.
        IF AVAIL ped-venda THEN DO:
            FIND FIRST int-ped-venda
            WHERE int-ped-venda.nr-pedido   = ped-venda.nr-pedido
              AND int-ped-venda.cod-estabel = ped-venda.cod-estabel NO-LOCK NO-ERROR.  
            IF AVAIL int-ped-venda THEN DO:
                IF SUBSTRING(int-ped-venda.char-1, 11, 1) = "S" THEN
                    ASSIGN wh-cod-depos-FT4002:SCREEN-VALUE      = "TNF".
                ELSE DO:
                    /*Para quando for estabelecimento WMS*/
                    IF  ped-venda.cod-estabel = "104" THEN
                        ASSIGN wh-cod-depos-FT4002:SCREEN-VALUE      = "WEX".
                    ELSE
                        ASSIGN wh-cod-depos-FT4002:SCREEN-VALUE      = "EXP".
                END.
            END.
        END. /* IF AVAIL ped-venda THEN DO: */
        /*************** Fim Valores combo-box */
    END. /* IF VALID-HANDLE(wh-cod-canal-venda-ft4002UPC) THEN DO: */
END.

if (p-ind-event  = "AFTER-CONTROL-TOOL-BAR"
OR  p-ind-event  = "Carrega-tt-wt-it-docto") 
and p-ind-object = "CONTAINER" then do:

    IF NOT VALID-HANDLE(wh-serie-ft4002UPC) THEN DO:
        ASSIGN wgh-frame    = p-wgh-frame:FIRST-CHILD
               wgh-frame    = wgh-frame:FIRST-CHILD
               p-row-pedido = p-row-table.
    
        DO WHILE VALID-HANDLE(wgh-frame):
            IF wgh-frame:TYPE <> "field-group" THEN DO:
                IF wgh-frame:NAME = "serie":U THEN 
                    ASSIGN wh-serie-ft4002UPC = wgh-frame.
                
                ASSIGN wgh-frame = wgh-frame:NEXT-SIBLING NO-ERROR.
            END. /* IF wgh-frame:TYPE <> "field-group" THEN DO: */
            ELSE LEAVE.
        END. /* DO WHILE VALID-HANDLE(wgh-frame): */
    END.
    
    IF  VALID-HANDLE(wh-serie-ft4002UPC) THEN DO:

        FIND FIRST ped-venda 
            WHERE rowid(ped-venda) = p-row-table NO-LOCK NO-ERROR.
        IF AVAIL ped-venda THEN DO:
    
            IF CAN-FIND(FIRST int-pedido-vtex NO-LOCK
                        WHERE int-pedido-vtex.nr-pedcli = ped-venda.nr-pedcli) THEN DO:
                FIND FIRST int-pedido-vtex NO-LOCK
                     WHERE int-pedido-vtex.nr-pedcli = ped-venda.nr-pedcli NO-ERROR.
    
                RUN esp/es0018p.p (INPUT "esftp016":U,
                                   INPUT 3,
                                   INPUT 0,
                                   INPUT "":U,
                                   OUTPUT TABLE tt-prog-ponto).
                IF CAN-FIND(FIRST tt-prog-ponto 
                            WHERE tt-prog-ponto.conteudo = int-pedido-vtex.marketplace) THEN
                    ASSIGN wh-serie-ft4002UPC:SCREEN-VALUE      = "90".
            END.
        END.
    END.

END.

PROCEDURE GetSystemMenu EXTERNAL "user32":U :
    DEFINE INPUT  PARAMETER HWND     AS LONG.
    DEFINE INPUT  PARAMETER bRevert  AS LONG.
    DEFINE RETURN PARAMETER lRetCode AS LONG.
END.

PROCEDURE GetMenuItemCount EXTERNAL "user32":U :
    DEFINE INPUT  PARAMETER hMenu    AS LONG.
    DEFINE RETURN PARAMETER iRetCode AS LONG.
END.

Procedure DrawMenuBar External "user32":
  define input parameter hMenu      as  long.
  define return parameter iRetCode  as  long.
End.

Procedure RemoveMenu External "user32":
  define input parameter hMenu      as  long.
  define input parameter nPosition  as  long.
  define input parameter wFlags     as  long.
  define return parameter iRetCode  as  long.
End.

Procedure GetParent External "user32":
  define input  parameter thishwnd     as long.
  define return parameter parenthwnd   as long.
End.

