
/*******************************************************************************
** Programa: iwm0101.w
** Autor...: Datasul SC
** Data....: 08/2018
** OBS.....: UPC que inclui campo da tabela wm-param na pagina 1 do programa wm0101
** Objetivo: Manutená∆o do campo
*******************************************************************************/
def input param p-ind-event        as char          no-undo.
def input param p-ind-object       as char          no-undo.
def input param p-wgh-object       as handle        no-undo.
def input param p-wgh-frame        as widget-handle no-undo.
def input param p-cod-table        as char          no-undo.
def input param p-row-table        as rowid         no-undo.

DEF NEW GLOBAL SHARED VAR wh-fill   AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR tx-label  AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR h-fPage1  AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR h-fPage5  AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-lbl-num-dias-alerta    AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-num-dias-alerta        AS WIDGET-HANDLE NO-UNDO.

DEF NEW GLOBAL SHARED VAR h-bo      AS HANDLE        NO-UNDO.
DEF VAR h-frame AS HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE l-permite         AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE c-permite-antes   AS CHAR NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE c-permite-tela    AS CHAR NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE w-container       AS HANDLE NO-UNDO.

{include/i_fclpreproc.i} /* Include que define o processador do Facelift ativado ou n∆o. */

&IF "{&aplica_facelift}" = "YES" &THEN
	{include/i_fcldef.i}
&endif

{scbo/bosc050.i ttWm-param}

DEF VAR h-objeto   AS HANDLE        NO-UNDO.
DEF VAR c-char-2 AS CHAR          NO-UNDO.

/******************************************************************************************/
/******************************************************************************************/
/******************************************************************************************/
if p-ind-event = "INITIALIZE" and p-ind-object = "CONTAINER" then
  assign w-container = p-wgh-object.

/******************************************************************************************/
/******************************************************************************************/
/******************************************************************************************/
if p-ind-event = "BEFORE-INITIALIZE" and p-ind-object = "CONTAINER" then
  assign w-container = p-wgh-object.

/******************************************************************************************/
/******************************************************************************************/
/******************************************************************************************/
IF p-ind-event = "before-change-page" 
THEN DO:
    IF valid-handle(l-permite) THEN
        ASSIGN c-permite-tela = l-permite:SCREEN-VALUE.
END.
                                      
/******************************************************************************************/
/******************************************************************************************/
/******************************************************************************************/
/*encontrar o handle da frame onde deseja criar o campo*/
IF  p-ind-event = "AFTER-INITIALIZE" THEN DO:

    assign h-frame = p-wgh-frame:FIRST-CHILD.
    assign h-frame = h-frame:FIRST-CHILD.
    do  while valid-handle(h-frame):
        IF  h-frame:TYPE <> "field-group" THEN DO:
            IF  h-frame:NAME = "fPage1" THEN DO:
                ASSIGN h-fpage1 = h-frame.
            END.
            IF  h-frame:NAME = "fPage5" THEN DO:
                ASSIGN h-fpage5 = h-frame.
            END.
            assign h-frame = h-frame:NEXT-SIBLING.
            /* ver observaá∆o sobre o NEXT-SIBLING no fim deste exemplo */
        END.
        ELSE DO:
            LEAVE.
        END.
    end.
    RUN piCriaObjetos.

    FIND FIRST in-wm-param NO-LOCK NO-ERROR.
    IF NOT AVAIL in-wm-param THEN DO: 
       FIND FIRST wm-param NO-LOCK NO-ERROR.
       CREATE in-wm-param.
       ASSIGN in-wm-param.nr-sequencia      = wm-param.nr-sequencia
              in-wm-param.log-separa-ckd    = NO
              in-wm-param.num-dias-alerta   = 0.
       FIND FIRST in-wm-param NO-LOCK NO-ERROR.
    END.

    IF AVAIL in-wm-param THEN DO:
        IF in-wm-param.log-separa-ckd = YES THEN
            ASSIGN l-permite:SCREEN-VALUE = "yes".
        ELSE
            ASSIGN l-permite:SCREEN-VALUE = "no".

        ASSIGN wh-num-dias-alerta:SCREEN-VALUE = IF in-wm-param.num-dias-alerta = 0 THEN "3" ELSE STRING(in-wm-param.num-dias-alerta).

    END.
    

    IF l-permite:SCREEN-VALUE = "YES" 
         THEN ASSIGN c-permite-antes = "YES"
                     c-permite-tela  = "YES". 
         ELSE ASSIGN c-permite-antes = "NO"
                     c-permite-tela  = "NO". 
    
END.

/******************************************************************************************/
/******************************************************************************************/
/******************************************************************************************/
IF p-ind-event = "After-change-page" THEN DO:
    IF VALID-HANDLE(l-permite) THEN
        ASSIGN l-permite:SENSITIVE = YES.

    IF VALID-HANDLE(wh-num-dias-alerta) THEN
        ASSIGN wh-num-dias-alerta:SENSITIVE = YES.

END.

/******************************************************************************************/
/******************************************************************************************/
/******************************************************************************************/
IF  p-ind-event = "BEFORE-ENABLE" 
THEN DO:
    IF VALID-HANDLE(l-permite) THEN
        ASSIGN l-permite:SENSITIVE = YES.

    IF VALID-HANDLE(wh-num-dias-alerta) THEN
        ASSIGN wh-num-dias-alerta:SENSITIVE = YES.
END.

/******************************************************************************************/
/******************************************************************************************/
/******************************************************************************************/
IF  p-ind-event = "BEFORE-DISABLE"  
THEN DO:
    IF VALID-HANDLE(l-permite) THEN
        ASSIGN l-permite:SENSITIVE = NO.

    IF VALID-HANDLE(wh-num-dias-alerta) THEN
        ASSIGN wh-num-dias-alerta:SENSITIVE = NO.
END.

/******************************************************************************************/
/******************************************************************************************/
/******************************************************************************************/
IF  p-ind-event = "AFTER-ASSIGN"
THEN DO:

    FIND FIRST in-wm-param EXCLUSIVE-LOCK NO-ERROR.
    IF AVAIL in-wm-param THEN DO:
        IF VALID-HANDLE(l-permite) THEN DO:
            IF l-permite:SCREEN-VALUE = "yes" THEN
               ASSIGN in-wm-param.log-separa-ckd = YES.
            ELSE
               ASSIGN in-wm-param.log-separa-ckd = NO.
    
               ASSIGN l-permite:SENSITIVE = NO.
        END.

        IF VALID-HANDLE(wh-num-dias-alerta) THEN
            ASSIGN in-wm-param.num-dias-alerta = INT(wh-num-dias-alerta:SCREEN-VALUE).

    END.

END.

/******************************************************************************************/
/******************************************************************************************/
/******************************************************************************************/
//Luciano Leonhardt
PROCEDURE piCriaObjetos:

    CREATE TOGGLE-BOX l-permite
        ASSIGN FRAME = h-fpage1
               COL = 37
               ROW = 4.2
               HIDDEN = NO
               SENSITIVE = YES
               LABEL = "Permite Separar Item do Kit CKD".

    ASSIGN l-permite:SCREEN-VALUE = c-permite-tela.

    IF VALID-HANDLE(h-fpage5)
    THEN DO:
        //INI - Luciano Leonhardt
        CREATE TEXT wh-lbl-num-dias-alerta
            ASSIGN FRAME        = h-fpage5
                   FORMAT       = "x(16)"
                   WIDTH        = 14
                   SCREEN-VALUE = "Dias Alerta:"
                   HELP         = "Dias de antecedància para envio de Alerta Criaá∆o da µreas de Picking."
                   ROW          = 1.80
                   COL          = 57
                   VISIBLE      = YES.
    
        CREATE FILL-IN wh-num-dias-alerta
        ASSIGN FRAME            = h-fpage5
               NAME             = "wh-num-dias-alerta"
               DATA-TYPE        = "INTEGER"
               FORMAT           = ">9"
               WIDTH            = 5
               HEIGHT           = 0.88
               SCREEN-VALUE     = '0'
               ROW              = 1.67
               COL              = 65
               VISIBLE          = YES
               SENSITIVE        = NO.
        //FIM - Luciano Leonhardt
    END.

END PROCEDURE.

