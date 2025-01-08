/***********************************************************************
**  Programa..: UPC\FT4004-UPC.P
**  Autor.....: Medeiros - Gestech
**  Data......: Abril/2005 - Desenvolvimento
**  Descricao.: Impedir cadastramento de itens da nota com dep EXP localiz <> branco
**  Vers∆o....: 001 27/04/2005
**                  Desenvolvimento Programa
************************************************************************/
def input param p-ind-event        as char          no-undo.
def input param p-ind-object       as char          no-undo.
def input param p-wgh-object       as handle        no-undo.
def input param p-wgh-frame        AS WIDGET-HANDLE NO-UNDO.
def input param p-cod-table        as char          no-undo.
def input param p-row-table        as rowid         no-undo.

DEFINE NEW GLOBAL SHARED VARIABLE wh-cod-depos-FT4002      AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE h-ft4004-upc             AS WIDGET-HANDLE NO-UNDO.  
DEFINE NEW GLOBAL SHARED VARIABLE wh-cod-depos-ft4004      AS WIDGET-HANDLE NO-UNDO.  
DEFINE NEW GLOBAL SHARED VARIABLE wh-quantidade-ft4004     AS WIDGET-HANDLE NO-UNDO.  
DEFINE NEW GLOBAL SHARED VARIABLE wh-aliquota-ipi-ft4004   AS WIDGET-HANDLE NO-UNDO.  
DEFINE NEW GLOBAL SHARED VARIABLE wh-cd-trib-icms-ft4004   AS WIDGET-HANDLE NO-UNDO.  
DEFINE NEW GLOBAL SHARED VARIABLE wh-frame-fpage4-ft4004   AS WIDGET-HANDLE NO-UNDO.  
DEFINE NEW GLOBAL SHARED VARIABLE wh-frame-fpage5-ft4004   AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-frame-fpage1-ft4004   AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE tx-codigo-orig-ft4004    AS WIDGET-HANDLE NO-UNDO.  
DEFINE NEW GLOBAL SHARED VARIABLE wh-codigo-orig-ft4004    AS WIDGET-HANDLE NO-UNDO.  
DEFINE NEW GLOBAL SHARED VARIABLE wgh-folder               AS WIDGET-HANDLE NO-UNDO.   
DEFINE NEW GLOBAL SHARED VARIABLE wh-vl-preori-ped-ft4004  AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE adm-current-page AS INTEGER     NO-UNDO.
DEF VAR c-objeto  AS CHAR            NO-UNDO.

DEFINE VARIABLE iParent  AS INTEGER     NO-UNDO.
DEFINE VARIABLE iSysMenu AS INTEGER     NO-UNDO.
DEFINE VARIABLE iCnt     AS INTEGER     NO-UNDO.
DEFINE VARIABLE iRetCode AS INTEGER     NO-UNDO.

RUN upc/upc-ft4004nfse.p (INPUT p-ind-event,
                          INPUT p-ind-object,
                          INPUT p-wgh-object,
                          input p-wgh-frame,
                          input p-cod-table, 
                          input p-row-table). 

assign c-objeto = entry(num-entries(p-wgh-object:private-data, "~/"), p-wgh-object:private-data, "~/").

/* MESSAGE "Evento " p-ind-event  SKIP        */
/*         "Objeto " p-ind-object SKIP        */
/*         "Tabela " p-cod-table  SKIP        */
/*         "Rowid  " STRING(p-row-table) SKIP */
/*         "Objeto " c-objeto     SKIP        */
/*         p-wgh-frame:NAME                   */
/*         VIEW-AS ALERT-BOX INFO BUTTONS OK. */


      if p-ind-event = "AFTER-INITIALIZE" then do:
          IF  NOT VALID-HANDLE(h-ft4004-upc) THEN
              RUN upc/ft4004-upc.p PERSISTENT SET h-ft4004-upc(INPUT "",            
                                                               INPUT "",            
                                                               INPUT p-wgh-object,  
                                                               INPUT p-wgh-frame,   
                                                               INPUT "",            
                                                               INPUT p-row-table).


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

             if p-wgh-frame:type = "frame" and p-wgh-frame:name = "fpage0" then do:
                run pi-busca-handle (input p-wgh-frame,
                                     input p-ind-event,
                                     input 'frame':U,
                                     input 'fpage5':U,
                                     input NO,
                                     output wh-frame-fpage5-ft4004).

                run pi-busca-handle (input p-wgh-frame,
                                     input p-ind-event,
                                     input 'frame':U,
                                     input 'fpage4':U,
                                     input NO,
                                     output wh-frame-fpage4-ft4004).

                run pi-busca-handle (input p-wgh-frame,
                                     input p-ind-event,
                                     input 'frame':U,
                                     input 'fpage1':U,
                                     input NO,
                                     output wh-frame-fpage1-ft4004).
                /*
                wh-vl-preori-ped-ft4004b = getObject(p-wgh-frame, "vl-preori-ped")
                */


             END.
      END.

      IF VALID-HANDLE (wh-frame-fpage1-ft4004) THEN DO:
          run pi-busca-handle (input wh-frame-fpage1-ft4004,
                               input p-ind-event,
                               input 'fill-in':U,
                               input 'vl-preori-ped':U,
                               input NO,
                               output wh-vl-preori-ped-ft4004).  

          IF  VALID-HANDLE(wh-vl-preori-ped-ft4004) THEN
              ASSIGN wh-vl-preori-ped-ft4004:FORMAT = ">>>,>>>,>>9.9999".

      END.

      IF VALID-HANDLE (wh-frame-fpage4-ft4004) THEN DO:
          run pi-busca-handle (input wh-frame-fpage4-ft4004,
                               input p-ind-event,
                               input 'fill-in':U,
                               input 'quantidade':U,
                               input NO,
                               output wh-quantidade-ft4004).  

          run pi-busca-handle (input wh-frame-fpage4-ft4004,
                               input p-ind-event,
                               input 'fill-in':U,
                               input 'cod-depos':U,
                               input NO,
                               output wh-cod-depos-ft4004).  

          ON "ENTRY":U OF wh-cod-depos-ft4004 PERSISTENT RUN pi-entry-cod-depos IN h-ft4004-upc.
      END.

      IF VALID-HANDLE(wh-frame-fpage5-ft4004) THEN DO:
          if p-ind-event = "AFTER-INITIALIZE" then do:
              run pi-busca-handle (input wh-frame-fpage5-ft4004,
                                   input p-ind-event,
                                   input 'fill-in':U,
                                   input 'aliquota-ipi':U,
                                   input NO,
                                   output wh-aliquota-ipi-ft4004).

              run pi-busca-handle (input wh-frame-fpage5-ft4004,
                                   input p-ind-event,
                                   input 'COMBO-BOX':U,
                                   input 'cb-cd-trib-icm':U,
                                   input NO,
                                   output wh-cd-trib-icms-ft4004).

              CREATE TEXT tx-codigo-orig-ft4004
                            ASSIGN FRAME        = wh-frame-fpage5-ft4004
                                   FORMAT       = "x(14)"
                                   WIDTH        = 20
                                   SCREEN-VALUE = "Codigo Origem:"
                                   ROW          = wh-aliquota-ipi-ft4004:ROW - 3.85
                                   COL          = wh-aliquota-ipi-ft4004:COL - 10.7
                                   VISIBLE      = YES.

              CREATE FILL-IN wh-codigo-orig-ft4004
                            ASSIGN FRAME             = wh-frame-fpage5-ft4004
                                   DATA-TYPE         = "integer"
                                   FORMAT            = "9"
                                   WIDTH             = 3
                                   HEIGHT            = 0.80
                                   ROW               = wh-aliquota-ipi-ft4004:ROW - 3.90
                                   COL               = wh-aliquota-ipi-ft4004:COL
                                   VISIBLE           = YES
                                   SENSITIVE         = NO.

              ASSIGN wh-frame-fpage5-ft4004:HIDDEN = YES.

          END.

          IF p-ind-event = 'after-change-page' THEN DO:
              IF VALID-HANDLE(wh-cd-trib-icms-ft4004) THEN DO:
                      ASSIGN wh-cd-trib-icms-ft4004:SENSITIVE = YES.
              END.
          END.

          IF VALID-HANDLE(wh-codigo-orig-ft4004) THEN DO:
              IF p-ind-event = "after-DISABLE" THEN
                  ASSIGN  wh-codigo-orig-ft4004:SENSITIVE = FALSE.
              ELSE
                  IF p-ind-event = "AFTER-enable" THEN DO:
                     ASSIGN wh-codigo-orig-ft4004:SENSITIVE = TRUE.
                  END.
                  
          END.

          IF p-ind-event = "before-display" THEN DO:   
                  FIND FIRST wt-it-docto WHERE
                       ROWID(wt-it-docto) = p-row-table NO-ERROR.

                  FIND int-wt-it-docto
                       WHERE int-wt-it-docto.seq-wt-docto = wt-it-docto.seq-wt-docto
                         AND int-wt-it-docto.seq-wt-it-docto = wt-it-docto.seq-wt-it-docto
                      NO-LOCK NO-ERROR.

                  IF AVAIL int-wt-it-docto THEN DO:
                     ASSIGN  wh-codigo-orig-ft4004:SCREEN-VALUE =  string(int-wt-it-docto.codigo-orig).
                  END.
                  ELSE DO:
                      FIND ITEM
                          WHERE ITEM.it-codigo = wt-it-docto.it-codigo
                          NO-LOCK NO-ERROR.
                      IF AVAIL item THEN
                         ASSIGN wh-codigo-orig-ft4004:SCREEN-VALUE =  string(ITEM.codigo-orig).
                      ELSE
                         ASSIGN wh-codigo-orig-ft4004:SCREEN-VALUE =  "0".
                  END.
          END.
          ELSE IF p-ind-event = "before-assign" THEN DO:
                      FIND FIRST wt-it-docto WHERE
                           ROWID(wt-it-docto) = p-row-table NO-LOCK NO-ERROR.

                      FIND int-wt-it-docto
                           WHERE int-wt-it-docto.seq-wt-docto    = wt-it-docto.seq-wt-docto
                             AND int-wt-it-docto.seq-wt-it-docto = wt-it-docto.seq-wt-it-docto
                          EXCLUSIVE-LOCK NO-ERROR.

                      IF AVAIL int-wt-it-docto THEN DO:
                         ASSIGN  int-wt-it-docto.codigo-orig = int(wh-codigo-orig-ft4004:SCREEN-VALUE).
                      END.
                      ELSE DO:
                          CREATE int-wt-it-docto.
                          ASSIGN int-wt-it-docto.seq-wt-docto    = wt-it-docto.seq-wt-docto
                                 int-wt-it-docto.seq-wt-it-docto = wt-it-docto.seq-wt-it-docto
                                 int-wt-it-docto.codigo-orig     = int(wh-codigo-orig-ft4004:SCREEN-VALUE).

                      END.
               END.
      END.           

     IF p-ind-event = "BEFORE-ASSIGN" THEN DO:
        FIND FIRST wt-it-docto WHERE ROWID(wt-it-docto) = p-row-table NO-LOCK NO-ERROR.
        IF AVAIL wt-it-docto THEN DO:
            FIND FIRST wt-fat-ser-lote OF wt-it-docto NO-LOCK NO-ERROR.
            IF AVAIL wt-fat-ser-lote THEN DO:
                IF  (wt-fat-ser-lote.cod-depos = "EXP" 
                OR   wt-fat-ser-lote.cod-depos = "WEX"
                OR   wt-fat-ser-lote.cod-depos = "WEC")
                AND wt-fat-ser-lote.cod-localiz <> "" THEN DO:
                    RUN utp/ut-msgs.p (INPUT "show":U, 
                                       INPUT 27979, 
                                       INPUT "Item do dep¢sito EXP, WEC ou WEX com localizaá∆o n∆o pode ser faturado!").
                END.
            END.
        END.
     /*        MESSAGE wt-it-docto.cod-depos SKIP wt-it-docto.cod-localiz VIEW-AS ALERT-BOX. */
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
    
PROCEDURE pi-busca-handle:
    DEFINE INPUT  PARAMETER  pWghFrame    AS WIDGET-HANDLE NO-UNDO.
    DEFINE INPUT  PARAMETER  pIndEvent    AS CHARACTER     NO-UNDO.
    DEFINE INPUT  PARAMETER  pObjType     AS CHARACTER     NO-UNDO.
    DEFINE INPUT  PARAMETER  pObjName     AS CHARACTER     NO-UNDO.
    DEFINE INPUT  PARAMETER  pApresMsg    AS LOGICAL       NO-UNDO.
    DEFINE OUTPUT PARAMETER  phObj        AS HANDLE        NO-UNDO.
    
    DEFINE VARIABLE wgh-obj AS WIDGET-HANDLE NO-UNDO.
            
    ASSIGN wgh-obj = pWghFrame:FIRST-CHILD.

    DO  WHILE VALID-HANDLE(wgh-obj):

        IF  pApresMsg = YES THEN
            MESSAGE
                "Nome do Objeto " wgh-obj:NAME SKIP
                "Type do Objeto " wgh-obj:TYPE skip
                "P-Ind-Event    " pIndEvent
                VIEW-AS ALERT-BOX.

        IF  wgh-obj:TYPE    =   pObjType    AND 
            wgh-obj:NAME    =   pObjName    THEN DO:
            ASSIGN phObj = wgh-obj:HANDLE.
            /*LEAVE.*/
        END. 

        IF  wgh-obj:TYPE = "field-group" THEN    
            ASSIGN wgh-obj = wgh-obj:FIRST-CHILD.
        ELSE 
            ASSIGN wgh-obj = wgh-obj:NEXT-SIBLING.
    END.           
END PROCEDURE.

PROCEDURE pi-entry-cod-depos:
    
    IF  VALID-HANDLE (wh-cod-depos-ft4004) 
    AND VALID-HANDLE (wh-cod-depos-FT4002) THEN DO:
        ASSIGN wh-cod-depos-ft4004:SCREEN-VALUE = wh-cod-depos-FT4002:SCREEN-VALUE.

        ASSIGN wh-cod-depos-ft4004:SENSITIVE = NO.

        APPLY "leave" TO wh-cod-depos-ft4004.

    END.
END PROCEDURE.
